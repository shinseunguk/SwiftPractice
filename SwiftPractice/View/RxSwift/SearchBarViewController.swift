//
//  SearchBarViewController.swift
//  SwiftPractice
//
//  Created by ukseung.dev on 2023/06/01.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift
import RxViewController

final class SearchBarViewController: UIViewController, UIViewControllerAttribute {
    let disposeBag = DisposeBag()
    let viewModel = SearchBarViewModel()
    var navTitle: String?
    
    var isFirstSubscription = true
    
    var menuItemArray : [MenuItem]?
    
    let searchController = UISearchController(searchResultsController: nil).then {
        $0.searchBar.setValue("취소", forKey: "cancelButtonText")
    }
    
    lazy var tableView = UITableView().then {
        $0.register(TitleTableViewCell.self, forCellReuseIdentifier: "TitleTableViewCell")
    }
    
    lazy var noResultsLabel = UILabel().then {
        $0.isHidden = true
        $0.textAlignment = .center
        $0.textColor = .gray
        $0.font = UIFont.systemFont(ofSize: 16)
        $0.text = "검색 결과가 없습니다."
    }
    
    lazy var activityIndicator = UIActivityIndicatorView(style: .large).then {
        $0.color = .gray
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        setUI()
        setAttributes()
        bindRx()
    }
    
    func setNavigationBar() {
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    func setUI() {
        self.view.backgroundColor = .white
        
        self.view.addSubview(tableView)
        self.view.addSubview(noResultsLabel)
        self.view.addSubview(activityIndicator)
    }
    
    func setAttributes() {
        tableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        noResultsLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        activityIndicator.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
    }
    
    func bindRx() {
        let firstLoad = rx.viewWillAppear
            .take(1)
            .map { _ in () }
        let reload = tableView.refreshControl?.rx
            .controlEvent(.valueChanged)
            .map { _ in () } ?? Observable.just(())
        
        Observable.merge([firstLoad, reload])
            .bind(to: viewModel.fetchMenus)
            .disposed(by: disposeBag)
        
        searchController.searchBar.rx.text
        //            .filter{ $0 != nil && $0 != "" }
            .debounce(.milliseconds(700), scheduler: MainScheduler.instance)
            .subscribe(onNext: {
                guard let text = $0 else { return }
                self.viewModel.filterData(searchText: text)
            })
            .disposed(by: disposeBag)
        
        viewModel.isLoading
            .subscribe(onNext: { [weak self] in
                $0 ? self?.activityIndicator.startAnimating() : self?.activityIndicator.stopAnimating()
            })
            .disposed(by: disposeBag)
        
        viewModel.allMenus
            .bind(to: tableView.rx.items(cellIdentifier: "TitleTableViewCell", cellType: TitleTableViewCell.self)) { row, item, cell in
                cell.title.text = item.name
            }
            .disposed(by: disposeBag)
        
        viewModel.allMenus
            .subscribe(onNext: { [weak self] _ in
                self?.tableView.reloadData()
            })
            .disposed(by: disposeBag)
        
        viewModel.allMenus
            .subscribe(onNext: { menus in
                if menus.isEmpty {
                    self.tableView.isHidden = true
                    self.noResultsLabel.isHidden = false
                } else {
                    self.tableView.isHidden = false
                    self.noResultsLabel.isHidden = true
                    self.tableView.reloadData()
                }
            })
            .disposed(by: disposeBag)
    }
}

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
    
    var menuItemArray : [MenuItem]?
    
    let searchController = UISearchController(searchResultsController: nil).then {
        $0.searchBar.setValue("취소", forKey: "cancelButtonText")
    }
    
    lazy var tableView = UITableView().then {
        $0.register(TitleTableViewCell.self, forCellReuseIdentifier: "TitleTableViewCell")
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
    }
    
    func setAttributes() {
        tableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
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
    }
}

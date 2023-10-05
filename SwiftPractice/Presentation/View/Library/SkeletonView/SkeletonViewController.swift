//
//  SkeletonViewController.swift
//  SwiftPractice
//
//  Created by ukseung.dev on 2023/06/19.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxViewController
import SkeletonView

final class SkeletonViewController: UIViewController, UIViewControllerAttribute {
    let viewModel = SkeletonViewModel()
    let disposeBag = DisposeBag()
    
    var array: [ViewMenu] = []
    var navTitle: String?
    
    private let cellHeightRelay = BehaviorRelay<CGFloat>(value: 80) // 초기 높이 값으로 80을 설정합니다.
    
    let refreshControl = UIRefreshControl()
    
    lazy var tableView = UITableView().then {
        $0.register(KioskTableViewCell.self, forCellReuseIdentifier: "KioskTableViewCell")
        $0.isSkeletonable = true
        $0.showAnimatedSkeleton()
        $0.refreshControl = refreshControl
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
        self.navigationItem.title = navTitle ?? ""
    }
    
    func setUI() {
        self.view.backgroundColor = .white
        
        self.view.addSubview(tableView)
        self.view.addSubview(activityIndicator)
    }
    
    func setAttributes() {
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        activityIndicator.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
    }
    
    func bindRx() {
        // 처음 로딩할 때 하고, 당겨서 새로고침 할 때

        let firstLoad = rx.viewWillAppear
            .take(1)
            .map { _ in () }
        let reload = tableView.refreshControl?.rx
            .controlEvent(.valueChanged)
            .map { _ in () } ?? Observable.just(())

        Observable.merge([firstLoad, reload])
            .bind(to: viewModel.fetchMenus)
            .disposed(by: disposeBag)
        
        viewModel.allMenus
            .do(onNext: { _ in self.refreshControl.endRefreshing() })
            .bind(to: tableView.rx.items(cellIdentifier: "KioskTableViewCell",
                                         cellType: KioskTableViewCell.self)) {
                _, item, cell in

                cell.onData.onNext(item)
                cell.onChanged
                    .map { (item, $0) }
                    .bind(to: self.viewModel.increaseMenuCount)
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
        
        cellHeightRelay
            .bind(to: tableView.rx.rowHeight)
            .disposed(by: disposeBag)
        
        viewModel.activated
            .do(onNext:{ $0 ? self.tableView.showSkeleton() : self.tableView.hideSkeleton() })
            .subscribe(onNext: { [weak self] in
                $0 ? self?.activityIndicator.startAnimating() : self?.activityIndicator.stopAnimating()
            })
            .disposed(by: disposeBag)
                
        viewModel.errorMessage
                .subscribe(onNext: { [weak self] in
                    self?.showAlert("Order Fail", "\($0)")
                })
                .disposed(by: disposeBag)
    }
}

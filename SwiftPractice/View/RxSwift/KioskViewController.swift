//
//  KioskViewController.swift
//  SwiftPractice
//
//  Created by ukseung.dev on 2023/05/26.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift
import RxViewController

final class KioskViewController: UIViewController, UIViewControllerAttribute {
    let viewModel = KioskViewModel()
    let disposeBag = DisposeBag()
    
    var navTitle: String?
    
    var menuArray: [String] = []
    var priceArray: [Int] = []
    
    lazy var loadingIndicator = UIActivityIndicatorView().then {
        $0.color = .gray
        $0.hidesWhenStopped = true
    }
    
    let titleLabel = UILabel().then {
        $0.text = "Bear Fried Center"
        $0.font = .boldSystemFont(ofSize: 40)
        $0.textAlignment = .left
        $0.sizeToFit()
    }
    
    lazy var tableView = UITableView().then {
        $0.register(KioskTableViewCell.self, forCellReuseIdentifier: "KioskTableViewCell")
    }
    
    let orderView = UIView().then {
        $0.backgroundColor = .lightGray
    }
    
    let orderViewLabel = UILabel().then {
        $0.text = "Your orders"
        $0.sizeToFit()
        $0.textColor = .black
        $0.font = .boldSystemFont(ofSize: 18)
    }
    
    let clearButton = UIButton().then {
        $0.setTitle("Clear", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = .boldSystemFont(ofSize: 15)
        $0.backgroundColor = .systemBlue
        $0.layer.cornerRadius = 5
    }
    
    let itemCountLabel = UILabel().then {
        $0.textColor = .blue
        $0.font = .systemFont(ofSize: 17)
        $0.sizeToFit()
    }
    
    let totalPriceLabel = UILabel().then {
        $0.text = "￦ 0"
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 40)
        $0.sizeToFit()
    }
    
    let orderButton = UIButton().then {
        $0.setTitle("ORDER", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = .boldSystemFont(ofSize: 20)
        $0.backgroundColor = .black
        $0.contentVerticalAlignment = .top
        $0.titleEdgeInsets = UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 0)
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
        
        self.view.addSubview(loadingIndicator)
        self.view.addSubview(titleLabel) // Bear Fried Center
        self.view.addSubview(tableView) // 테이블뷰
        
        self.view.addSubview(orderView) // You Orders
        self.orderView.addSubview(orderViewLabel)
        self.orderView.addSubview(clearButton)
        self.orderView.addSubview(itemCountLabel)
        self.orderView.addSubview(totalPriceLabel)
        
        self.view.addSubview(orderButton) // 하단 ORDER 버튼
    }
    
    func setAttributes() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide)
            $0.left.equalTo(15)
            $0.right.equalTo(-15)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(orderView.snp.top)
        }
        
        orderView.snp.makeConstraints {
            $0.height.equalTo(120)
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(orderButton.snp.top)
        }
        
        orderViewLabel.snp.makeConstraints {
            $0.top.equalTo(10)
            $0.left.equalTo(20)
        }
        
        clearButton.snp.makeConstraints {
            $0.centerY.equalTo(orderViewLabel.snp.centerY)
            $0.left.equalTo(orderViewLabel.snp.right).offset(20)
            $0.width.equalTo(55)
        }
        
        itemCountLabel.snp.makeConstraints {
            $0.centerY.equalTo(orderViewLabel.snp.centerY)
            $0.right.equalTo(-30)
        }
        
        totalPriceLabel.snp.makeConstraints {
            $0.top.equalTo(itemCountLabel.snp.bottom).offset(20)
            $0.right.equalTo(-20)
        }
        
        orderButton.snp.makeConstraints {
            $0.height.equalTo(100)
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    func bindRx() {
        
        rx.viewWillAppear
            .subscribe(onNext: { _ in
                self.viewModel.fetchUsers()
            })
            .disposed(by: disposeBag)
        
        viewModel.menu
            .bind(to: tableView.rx.items(cellIdentifier: "KioskTableViewCell", cellType: KioskTableViewCell.self)) { index, menu, cell in
                cell.titleLabel.text = menu.name
                cell.priceLabel.text = String(menu.price ?? 0)
            }
            .disposed(by: disposeBag)
        
        viewModel.totalCount
            .map { "\($0) items" }
            .bind(to: itemCountLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.totalPrice
            .map { "￦ \($0)" }
            .bind(to: totalPriceLabel.rx.text)
            .disposed(by: disposeBag)
    }
}


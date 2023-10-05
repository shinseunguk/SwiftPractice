//
//  Kiosk2ViewController.swift
//  SwiftPractice
//
//  Created by ukseung.dev on 2023/06/08.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

final class Kiosk2ViewController: UIViewController, UIViewControllerAttribute {
    let disposeBag = DisposeBag()
    let viewModel = Kiosk2ViewModel()
    
    var navTitle: String?
    var viewMenu: [ViewMenu]? {
        didSet {
            guard let viewMenu = viewMenu else { return }
            tLog(viewMenu)
            viewModel.fetchMenu.onNext(viewMenu)
        }
    }
    
    lazy var titleView = UIView().then {
        $0.backgroundColor = .black
    }
    
    lazy var titleLabel = UILabel().then {
        $0.text = "Receipt"
        $0.textColor = .white
        $0.font = .boldSystemFont(ofSize: 30)
        $0.backgroundColor = .black
        $0.sizeToFit()
    }
    
    lazy var orderedItemsLabel = UILabel().then {
        $0.text = "Ordered Items"
        $0.textColor = .black
        $0.font = .boldSystemFont(ofSize: 28)
        $0.sizeToFit()
    }
    
    lazy var tableView = UITableView().then {
        $0.isScrollEnabled = false
        $0.separatorStyle = .none
        $0.register(TitleTableViewCell.self, forCellReuseIdentifier: "TitleTableViewCell")
    }
    
    lazy var priceToPayLabel = UILabel().then {
        $0.text = "Price to Pay"
        $0.textColor = .black
        $0.font = .boldSystemFont(ofSize: 24)
        $0.sizeToFit()
    }
    
    lazy var itemsLabel = UILabel().then {
        $0.text = "Items"
        $0.textColor = .lightGray
        $0.font = .systemFont(ofSize: 24)
        $0.sizeToFit()
    }
    
    lazy var itemsPriceLabel = UILabel().then {
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 24)
        $0.sizeToFit()
    }
    
    lazy var vatLabel = UILabel().then {
        $0.text = "VAT"
        $0.textColor = .lightGray
        $0.font = .systemFont(ofSize: 24)
        $0.sizeToFit()
    }
    
    lazy var vatPriceLabel = UILabel().then {
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 24)
        $0.sizeToFit()
    }
    
    lazy var divisionView = UIView().then {
        $0.backgroundColor = .gray
    }
    
    lazy var totalPriceLabel = UILabel().then {
        $0.textColor = .black
        $0.font = .boldSystemFont(ofSize: 28)
        $0.sizeToFit()
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
        
        self.view.addSubview(titleView)
        titleView.addSubview(titleLabel)
        
        self.view.addSubview(orderedItemsLabel)
        
        self.view.addSubview(tableView)
        
        self.view.addSubview(priceToPayLabel)
        self.view.addSubview(itemsLabel)
        self.view.addSubview(itemsPriceLabel)
        self.view.addSubview(vatLabel)
        self.view.addSubview(vatPriceLabel)
        
        self.view.addSubview(divisionView)
        self.view.addSubview(totalPriceLabel)
    }
    
    func setAttributes() {
        titleView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.height.equalTo(150)
        }
        
        titleLabel.snp.makeConstraints {
            $0.left.equalTo(20)
            $0.bottom.equalTo(-10)
        }
        
        orderedItemsLabel.snp.makeConstraints {
            $0.top.equalTo(titleView.snp.bottom).offset(30)
            $0.left.equalTo(25)
        }
        
        tableView.snp.makeConstraints {
            $0.left.equalTo(20)
            $0.right.equalTo(-20)
            $0.top.equalTo(orderedItemsLabel.snp.bottom).offset(20)
            $0.height.equalTo(viewModel.allMenus.value.count * 50)
        }
        
        priceToPayLabel.snp.makeConstraints {
            $0.top.equalTo(tableView.snp.bottom).offset(40)
            $0.left.equalTo(20)
        }
        
        itemsLabel.snp.makeConstraints {
            $0.top.equalTo(priceToPayLabel.snp.bottom).offset(25)
            $0.left.equalTo(20)
        }
        
        itemsPriceLabel.snp.makeConstraints {
            $0.centerY.equalTo(itemsLabel.snp.centerY)
            $0.right.equalTo(-20)
        }
        
        vatLabel.snp.makeConstraints {
            $0.top.equalTo(itemsLabel.snp.bottom).offset(10)
            $0.left.equalTo(20)
        }
        
        vatPriceLabel.snp.makeConstraints {
            $0.centerY.equalTo(vatLabel.snp.centerY)
            $0.right.equalTo(-20)
        }
        
        divisionView.snp.makeConstraints {
            $0.top.equalTo(vatPriceLabel.snp.bottom).offset(20)
            $0.left.equalTo(20)
            $0.right.equalTo(-20)
            $0.height.equalTo(2)
        }
        
        totalPriceLabel.snp.makeConstraints {
            $0.top.equalTo(divisionView.snp.bottom).offset(20)
            $0.right.equalTo(-20)
        }
    }
    
    func bindRx() {
        viewModel.allMenus
            .bind(to: tableView.rx.items(cellIdentifier: "TitleTableViewCell", cellType: TitleTableViewCell.self)) { index, item, cell in
                cell.selectionStyle = .none
                
                cell.title.text = "\(item.name) \(item.count)개"
            }
            .disposed(by: disposeBag)
        
        viewModel.itemsPrice
            .bind(to: itemsPriceLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.vatPrice
            .bind(to: vatPriceLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.totalPrice
            .bind(to: totalPriceLabel.rx.text)
            .disposed(by: disposeBag)
    }
}

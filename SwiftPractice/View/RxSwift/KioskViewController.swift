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

final class KioskViewController: UIViewController, UIViewControllerAttribute {
    let viewModel = KioskViewModel()
    let disposeBag = DisposeBag()
    
    var navTitle: String?
    
    var menuArray: [String] = []
    
    let titleLabel = UILabel().then {
        $0.text = "Bear Fried Center"
        $0.font = .boldSystemFont(ofSize: 40)
        $0.textAlignment = .left
        $0.sizeToFit()
    }
    
    lazy var tableView = UITableView().then {
        $0.delegate = self
        $0.dataSource = self
        $0.register(TitleTableViewCell.self, forCellReuseIdentifier: "TitleTableViewCell")
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
        
        setTableViewArray()
        setNavigationBar()
        setUI()
        setAttributes()
        bindRx()
    }
    
    func setTableViewArray() {
        _ = [
            "김말이",
            "오징어튀김",
            "새우튀김",
            "고구마튀김",
            "탕수육",
            "야채튀김",
            "만두튀김",
            "멸치튀김",
            "감자튀김",
            "떡튀김",
            "쏘세지튀김",
            "곰튀김",
            "치킨",
            "피자",
            "햄버거"
        ].map {
            menuArray.append($0)
        }
    }
    
    func setNavigationBar() {
        self.navigationItem.title = navTitle ?? ""
    }
    
    func setUI() {
        self.view.backgroundColor = .white
        self.view.addSubview(titleLabel)
        self.view.addSubview(tableView)
        self.view.addSubview(orderButton)
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
            $0.height.equalTo(300)
        }
        
        orderButton.snp.makeConstraints {
            $0.height.equalTo(100)
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    func bindRx() {
        
    }
}

extension KioskViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TitleTableViewCell", for: indexPath) as! TitleTableViewCell
        
        let item = menuArray[indexPath.row]
        cell.title.text = item
        
        return cell
    }
}


//
//  SwipeToDeleteCellViewController.swift
//  SwiftPractice
//
//  Created by ukseung.dev on 2023/05/19.
//

import Foundation
import UIKit
import SnapKit

class SwipeToDeleteCellViewController: UIViewController, UIViewControllerAttribute {
    
    var navTitle: String?
    var lastContentOffset: CGFloat = 0.0
    var tableViewArray: [Int] = []
    
    lazy var tableView = UITableView().then {
        $0.delegate = self
        $0.dataSource = self
        $0.register(TitleTableViewCell.self, forCellReuseIdentifier: "TitleTableViewCell")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTableViewArray()
        setNavigationBar()
        setUI()
        setAttributes()
        bindRx() // 미사용 함수
    }
    
    func setTableViewArray() {
        for x in 0...100 {
            tableViewArray.append(x)
        }
    }
    
    func setNavigationBar() {
        self.navigationItem.title = navTitle ?? ""
    }
    
    func setUI() {
        self.view.backgroundColor = .white
        self.view.addSubview(tableView)
    }
    
    func setAttributes() {
        tableView.snp.makeConstraints {
            $0.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
    /// 미사용 함수
    func bindRx() {
        
    }
}

extension SwipeToDeleteCellViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TitleTableViewCell", for: indexPath) as! TitleTableViewCell
        cell.title.text = String(tableViewArray[indexPath.row])
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // 선택한 셀 삭제
            tableView.beginUpdates() // beginUpdate
            
            tableView.deleteRows(at: [indexPath], with: .fade) // 셀 삭제 애니메이션 설정
            
            tableViewArray.remove(at: indexPath.row) // 데이터 소스에서 해당 셀의 데이터 삭제
            
            tableView.endUpdates() // endUpdate
        }
    }
}

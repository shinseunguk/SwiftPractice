//
//  IndexController.swift
//  SwiftPractice
//
//  Created by ukBook on 2023/05/12.
//

import UIKit
import Then
import SnapKit

final class IndexController: UIViewController, UIViewControllerAttribute {
    
    var tableView0Array : [String] = []
    var tableView1Array : [String] = []
    
    var tableViewCount: Int = 0
    let spacing: CGFloat = 30
    
    lazy var scrollView = UIScrollView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .clear
        $0.isScrollEnabled = true
        $0.delegate = self
    }
    
    lazy var contentView = UIView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .systemBlue
    }
    
    lazy var tableView0 = DynamicHeightTableView().then {
        $0.delegate = self
        $0.dataSource = self
        $0.layer.borderColor = UIColor.red.cgColor
        $0.backgroundColor = .white
        $0.isScrollEnabled = false
        $0.register(TitleTableViewCell.self, forCellReuseIdentifier: "TitleTableViewCell")
    }
    
    lazy var tableView1 = DynamicHeightTableView().then {
        $0.delegate = self
        $0.dataSource = self
        $0.layer.borderColor = UIColor.red.cgColor
        $0.backgroundColor = .white
        $0.isScrollEnabled = false
        $0.register(TitleTableViewCell.self, forCellReuseIdentifier: "TitleTableViewCell")
        tableViewCount += 1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        setArray()
        setUI()
        setAttributes()
        bindRx()
    }
    
    /// 네비게이션바 Set
    func setNavigationBar() {
        self.navigationItem.title = "SwiftPractice"
    }
    
    /// indexArray append하는 함수
    func setArray() {
        _ = [
            "scrollViewDidScroll NaviBar hide on/off",
            "456"
        ].map {
            tableView0Array.append($0)
        }
        
        _ = [
            "tableView cell 밀어서 삭제",
            "tableView2",
            "tableView3"
        ].map {
            tableView1Array.append($0)
        }
    }
    
    func setUI() {
        self.view.backgroundColor = .white
        
        self.view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(tableView0)
        contentView.addSubview(tableView1)
    }
    
    func setAttributes() {
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        tableView0.reloadData()
        tableView1.reloadData()
        
        tableView0.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.width.equalToSuperview()
        }
        
        tableView1.snp.makeConstraints {
            $0.top.equalTo(tableView0.snp.bottom).offset(30)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.width.equalToSuperview()
        }
        
        let contentSize = tableView0.contentSize.height + tableView1.contentSize.height + CGFloat(Int(spacing) * tableViewCount)
        
        contentView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(contentSize)
        }
        
        scrollView.contentSize = contentView.bounds.size
    }
    
    
    func bindRx() {
        
    }
}

extension IndexController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == tableView0 {
            return tableView0Array.count
        } else if tableView == tableView1 {
            return tableView1Array.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TitleTableViewCell", for: indexPath) as! TitleTableViewCell
        
        if tableView == tableView0 {
            cell.title.text = tableView0Array[indexPath.row]
        } else if tableView == tableView1 {
            cell.title.text = tableView1Array[indexPath.row]
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true) // 선택 해제
        
        if tableView == tableView0 {
            
            switch indexPath.row {
            case 0:
                let VC = ScrollHideViewController()
                VC.navTitle = tableView0Array[indexPath.row]
                
                self.navigationController?.pushViewController(VC, animated: true)
            case 1:
                break
            default:
                break
            }
            
        } else if tableView == tableView1 {
            
            switch indexPath.row {
            case 0:
                let VC = SwipeToDeleteCellViewController()
                VC.navTitle = tableView1Array[indexPath.row]
                
                self.navigationController?.pushViewController(VC, animated: true)
            case 1:
                break
            case 2:
                break
            default:
                break
            }
            
        }
    }
}

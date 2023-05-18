//
//  ViewController.swift
//  SwiftPractice
//
//  Created by ukBook on 2023/05/12.
//

import UIKit
import Then
import SnapKit

final class ViewController: UIViewController, ViewAttribute {
    
    var indexArray : [String] = []
    var indexString: String?
    
    lazy var indexTableView = UITableView().then {
        $0.delegate = self
        $0.dataSource = self
        $0.layer.borderColor = UIColor.red.cgColor
        $0.register(IndexTableViewCell.self, forCellReuseIdentifier: "IndexTableViewCell")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setArray()
        setUI()
        setAttributes()
        bindRx()
    }
    
    func setArray() {
        _ = [
        "ScrollView로 NavigationBar hide on/off",
        "456"
        ].map {
            indexArray.append($0)
        }
    }

    func setUI() {
        self.view.backgroundColor = .white
        self.view.addSubview(indexTableView)
    }
    
    func setAttributes() {
        indexTableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func bindRx() {
        
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return indexArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IndexTableViewCell", for: indexPath) as! IndexTableViewCell
        cell.title.text = indexArray[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0:
            let VC = View0Cotnroller()
            VC.navTitle = indexArray[indexPath.row]
            self.navigationController?.pushViewController(VC, animated: true)
        default:
            break
        }
        
        
        
    }
}

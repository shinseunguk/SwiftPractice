//
//  IndexViewController.swift
//  SwiftPractice
//
//  Created by ukBook on 2023/05/12.
//

import UIKit
import Then
import SnapKit

final class IndexViewController: UIViewController, UIViewControllerAttribute {
    
//    var tableView0Array : [String] = []
//    var tableView1Array : [String] = []
//    var sections: [String] = []
    
    // 섹션 제목 배열
    let sectionTitles = [
        "UIScrollView",
        "UITableView",
        "Signing & Capabilities",
        "Library",
        "RxSwift"
    ]
    
    // 각 섹션의 데이터 배열
    let sectionData = [
        [
            "ScrollViewDidScroll NaviBar hide on/off"
        ], // UIScrollView
        [
            "TableView cell 밀어서 삭제"
        ], // UITableView
        [
            "Sign In with Apple",
            "Hotspot Configuration"
        ], // Signing & Capabilities
        [
            "Atributika",
            "CryptoSwift"
        ], // Library
        [
            "MVVM+RxSwift 로그인 예제",
            "MVVM+RxSwift 키오스크(곰튀김)"
        ] // Library(RxSwift)
    ]
    
    lazy var tableView = UITableView().then {
        $0.delegate = self
        $0.dataSource = self
        $0.layer.borderColor = UIColor.red.cgColor
        $0.backgroundColor = .white
        $0.register(TitleTableViewCell.self, forCellReuseIdentifier: "TitleTableViewCell")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        setUI()
        setAttributes()
        bindRx()
    }
    
    /// 네비게이션바 Set
    func setNavigationBar() {
        self.navigationItem.title = "SwiftPractice"
    }
    
    
    func setUI() {
        self.view.backgroundColor = .white
        
        self.view.addSubview(tableView)
    }
    
    func setAttributes() {
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    
    func bindRx() {
        
    }
}

extension IndexViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionData[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TitleTableViewCell", for: indexPath) as! TitleTableViewCell
        
        let item = sectionData[indexPath.section][indexPath.row]
        cell.title.text = item
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true) // 선택 해제
        
        switch indexPath.section {
        case 0: // UIScrollView
            
            switch indexPath.row {
            case 0: // scrollViewDidScroll NaviBar hide on/off
                let VC = ScrollHideViewController()
                VC.navTitle = sectionData[indexPath.section][indexPath.row]

                self.navigationController?.pushViewController(VC, animated: true)
            default:
                break
            }
        
        case 1: // UITableView
            
            switch indexPath.row {
            case 0: // tableView Cell 밀어서 삭제
                let VC = SwipeToDeleteCellViewController()
                VC.navTitle = sectionData[indexPath.section][indexPath.row]

                self.navigationController?.pushViewController(VC, animated: true)
            default:
                break
            }
        
        case 2 : // Signing & Capabilities
            
            switch indexPath.row {
            case 0: // Sign In With Apple
                let VC = AppleLoginViewController()
                VC.navTitle = sectionData[indexPath.section][indexPath.row]

                self.navigationController?.pushViewController(VC, animated: true)
            case 1: // Hotspot Configuration
                let VC = HotspotConfigurationViewController()
                VC.navTitle = sectionData[indexPath.section][indexPath.row]

                self.navigationController?.pushViewController(VC, animated: true)
            default:
                break
            }
        case 3 : // Library
            
            switch indexPath.row {
            case 0: // Atributika
                let VC = AtributikaViewController()
                VC.navTitle = sectionData[indexPath.section][indexPath.row]

                self.navigationController?.pushViewController(VC, animated: true)
            case 1: // CryptoSwift
                let VC = CryptoViewController()
                VC.navTitle = sectionData[indexPath.section][indexPath.row]

                self.navigationController?.pushViewController(VC, animated: true)
            default:
                break
            }
            
        case 4 : // RxSwift
            
            switch indexPath.row {
            case 0: // MVVM+RxSwift 로그인 예제
                let VC = LoginViewController()
                VC.navTitle = sectionData[indexPath.section][indexPath.row]

                self.navigationController?.pushViewController(VC, animated: true)
            case 1: // MVVM+RxSwift 키오스크(곰튀김)
                let VC = KioskViewController()
                VC.navTitle = sectionData[indexPath.section][indexPath.row]

                self.navigationController?.pushViewController(VC, animated: true)
            default:
                break
            }
            
        default:
            break
        }
        
        
    }
}

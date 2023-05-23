//
//  HotspotConfigurationViewController.swift
//  SwiftPractice
//
//  Created by ukseung.dev on 2023/05/22.
//

import Foundation
import UIKit
import RxSwift

final class HotspotConfigurationViewController: UIViewController, UIViewControllerAttribute {
    
    let viewModel = HotspotConfigurationViewModel()
    let disposeBag = DisposeBag()
    
    var navTitle: String?
    
    lazy var button = UIButton(type: .system).then {
        $0.setTitle("connectToHotspot", for: .normal)
    }
    
    // getWiFiInformation 로그인 성공 후 UILabel.text
    lazy var wifiInfoLabel = UILabel().then {
        $0.numberOfLines = 0 // 여러 줄
        $0.sizeToFit()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        setUI()
        setAttributes()
        bindRx() // 미사용 함수
    }
    
    func setNavigationBar() {
        self.navigationItem.title = navTitle ?? ""
    }
    
    func setUI() {
        self.view.backgroundColor = .white
        self.view.addSubview(button)
        self.view.addSubview(wifiInfoLabel)
    }
    
    func setAttributes() {
        button.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(30)
            $0.left.equalTo(30)
            $0.right.equalTo(-30)
            $0.height.equalTo(50)
        }
        
        wifiInfoLabel.snp.makeConstraints {
            $0.left.equalTo(20)
            $0.right.equalTo(-20)
            $0.top.equalTo(button.snp.bottom).offset(40)
            $0.height.equalTo(50)
        }
    }
    
    func bindRx() {
        button.rx.tap
            .subscribe(onNext: viewModel.connectToHotspot)
            .disposed(by: disposeBag)
        
        viewModel.inCompleted
            .bind(to: wifiInfoLabel.rx.text)
            .disposed(by: disposeBag)
    }
}

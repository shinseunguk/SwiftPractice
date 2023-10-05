//
//  LocalAuthenticationViewController.swift
//  SwiftPractice
//
//  Created by ukseung.dev on 2023/10/05.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

final class LocalAuthenticationViewController: UIViewController, UIViewControllerAttribute {
    let viewModel = LocalAuthenticationViewModel()
    let disposeBag = DisposeBag()
    var navTitle: String?
    
    
    lazy var authLabel = UILabel().then {
        $0.text = "인증 전"
        $0.textColor = .black
        $0.sizeToFit()
    }
    
    lazy var authButton = UIButton().then {
        $0.setTitle("LocalAuthentication", for: .normal)
        $0.backgroundColor = .systemBlue
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 10
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
        
        self.view.addSubview(authLabel)
        self.view.addSubview(authButton)
    }
    
    func setAttributes() {
        authLabel.snp.makeConstraints {
            $0.bottom.equalTo(authButton.snp.top).offset(-40)
            $0.centerX.equalToSuperview()
        }
        
        authButton.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.width.equalTo(200)
            $0.height.equalTo(40)
        }
    }
    
    func bindRx() {
        viewModel.authenticationSubject
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] AuthType in
                guard let self = self else { return }
                
                switch AuthType {
                case AuthType.success :
                    self.authLabel.textColor = .systemGreen
                default:
                    self.authLabel.textColor = .systemRed
                }

                self.authLabel.text = AuthType.message
            })
            .disposed(by: disposeBag)
        
        authButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                
                self.viewModel.authenticateWithBiometrics()
            })
            .disposed(by: disposeBag)
    }
}


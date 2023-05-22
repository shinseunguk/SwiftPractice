//
//  AppleLoginViewController.swift
//  SwiftPractice
//
//  Created by ukseung.dev on 2023/05/22.
//

import Foundation
import UIKit
import AuthenticationServices
import RxSwift
import RxCocoa

final class AppleLoginViewController: UIViewController, UIViewControllerAttribute {
    
    private let disposeBag = DisposeBag()
    private var viewModel = AppleLoginViewModel()
    private var appleUserInfo = AppleUser(userIdentifier: nil, familyName: nil, givenName: nil, email: nil, state: nil)
    
    // Apple 로그인 버튼 생성
    lazy var appleLoginButton = UIButton(type: .system).then {
        $0.setTitle("Sign In with Apple", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 5
        $0.backgroundColor = .black
    }

    // Apple 로그인 성공 후 UILabel.text
    lazy var userInfoLabel = UILabel().then {
        $0.numberOfLines = 0 // 여러 줄
        $0.sizeToFit()
    }
    
    var navTitle: String?
    
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
        
        self.view.addSubview(appleLoginButton)
        self.view.addSubview(userInfoLabel)
    }
    
    func setAttributes() {
        appleLoginButton.snp.makeConstraints {
            $0.width.equalTo(200)
            $0.height.equalTo(50)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(30)
            $0.centerX.equalToSuperview()
        }
        
        userInfoLabel.snp.makeConstraints {
            $0.left.equalTo(20)
            $0.right.equalTo(-20)
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide)
            $0.top.equalTo(appleLoginButton.snp.bottom).offset(40)
        }
    }
    
    func bindRx() {
        
        // 애플 로그인 버튼 Action
        appleLoginButton.rx.tap
            .bind(to: viewModel.signInButtonTapped)
            .disposed(by: disposeBag)
        
        viewModel.signInCompleted
            .subscribe(onNext: { value in
                self.appleUserInfo = value
                self.userInfoLabel.text = "\(self.appleUserInfo)"
            })
            .disposed(by: disposeBag)
        
    }
}


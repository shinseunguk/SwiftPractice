//
//  LoginViewController.swift
//  SwiftPractice
//
//  Created by ukseung.dev on 2023/05/26.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

final class LoginViewController: UIViewController, UIViewControllerAttribute {
    let disposeBag = DisposeBag()
    let viewModel = LoginViewModel()
    
    var navTitle: String?
    
    let loginTextField = UITextField().then {
        $0.placeholder = "ID"
        $0.borderStyle = .roundedRect
        $0.keyboardType = .emailAddress
    }
    
    let passwordTextField = UITextField().then {
        $0.placeholder = "PassWord"
        $0.borderStyle = .roundedRect
        $0.isSecureTextEntry = true
    }
    
    let loginButton = UIButton(type: .system).then {
        $0.setTitle("로그인", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .systemBlue
        $0.layer.cornerRadius = 5
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
        self.view.addSubview(loginTextField)
        self.view.addSubview(passwordTextField)
        self.view.addSubview(loginButton)
    }
    
    func setAttributes() {
        loginTextField.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(30)
            $0.left.equalTo(30)
            $0.right.equalTo(-30)
            $0.height.equalTo(40)
        }
        
        passwordTextField.snp.makeConstraints {
            $0.top.equalTo(loginTextField.snp.bottom).offset(5)
            $0.left.equalTo(30)
            $0.right.equalTo(-30)
            $0.height.equalTo(40)
        }
        
        loginButton.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.bottom).offset(20)
            $0.left.equalTo(30)
            $0.right.equalTo(-30)
            $0.height.equalTo(50)
        }
    }
    
    func bindRx() {
        loginTextField.rx.text
            .orEmpty
            .asObservable()
            .bind(to: viewModel.identityTextValue)
            .disposed(by: disposeBag)
        
        passwordTextField.rx.text
            .orEmpty
            .asObservable()
            .bind(to: viewModel.passwordTextValue)
            .disposed(by: disposeBag)
        
        viewModel.isValid
            .subscribe(onNext: {
                self.loginButton.alpha = $0 ? 1.0 : 0.3
                self.loginButton.isEnabled = $0
            })
            .disposed(by: disposeBag)
        
        loginButton.rx.tap
            .subscribe(onNext: {
                self.viewModel.login()
            })
            .disposed(by: disposeBag)
            
        viewModel.loginResult
            .map{ $0 ? "로그인 성공" : "로그인 실패" }
            .subscribe(onNext: {
                self.showAlert(message: $0)
            })
            .disposed(by: disposeBag)
    }
    
    func showAlert(message: String) {
       // 알림을 표시하는 로직 구현
       let alertController = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
       alertController.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
       present(alertController, animated: true, completion: nil)
   }
}

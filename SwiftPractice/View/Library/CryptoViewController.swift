//
//  CryptoViewController.swift
//  SwiftPractice
//
//  Created by ukseung.dev on 2023/05/25.
//

import Foundation
import UIKit
import CryptoSwift
import RxSwift
import RxCocoa

enum CryptoError: Error {
    case invalidInputData
    case invalidKey
    case decryptionFailed
}

final class CryptoViewController: UIViewController, UIViewControllerAttribute {
    let disposeBag = DisposeBag()
    let viewModel = CryptoViewModel()
    
    var navTitle: String?
    
    let cryptoTextField = UITextField().then {
        $0.borderStyle = .roundedRect
    }
    
    let cryptoButton = UIButton(type: .system).then {
        $0.setTitle("암호화", for: .normal)
    }
    
    lazy var originLabel = UILabel().then {
        $0.text = "기존 텍스트 :"
        $0.textAlignment = .left
        $0.numberOfLines = 0
        $0.textColor = .black
        $0.lineBreakMode = .byCharWrapping
    }
    
    lazy var encryptLabel = UILabel().then {
        $0.text = "암호화 :"
        $0.textAlignment = .left
        $0.numberOfLines = 0
        $0.textColor = .black
    }
    
    lazy var decryptLabel = UILabel().then {
        $0.text = "복호화 :"
        $0.textAlignment = .left
        $0.numberOfLines = 0
        $0.textColor = .black
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
        self.view.addSubview(cryptoTextField)
        self.view.addSubview(cryptoButton)
        self.view.addSubview(encryptLabel)
        self.view.addSubview(decryptLabel)
        self.view.addSubview(originLabel)
    }
    
    func setAttributes() {
        cryptoTextField.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(30)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(350)
            $0.height.equalTo(50)
        }
        
        cryptoButton.snp.makeConstraints {
            $0.top.equalTo(cryptoTextField.snp.bottom).offset(20)
            $0.centerX.equalTo(cryptoTextField.snp.centerX)
            $0.width.equalTo(200)
            $0.height.equalTo(40)
        }
        
        originLabel.snp.makeConstraints {
            $0.top.equalTo(cryptoButton.snp.bottom).offset(20)
            $0.left.equalTo(20)
            $0.right.equalTo(-20)
            $0.height.equalTo(100)
        }
        
        encryptLabel.snp.makeConstraints {
            $0.top.equalTo(originLabel.snp.bottom).offset(20)
            $0.left.equalTo(20)
            $0.right.equalTo(-20)
            $0.height.equalTo(originLabel.snp.height)
        }
        
        decryptLabel.snp.makeConstraints {
            $0.top.equalTo(encryptLabel.snp.bottom).offset(20)
            $0.left.equalTo(20)
            $0.right.equalTo(-20)
            $0.height.equalTo(originLabel.snp.height)
        }
    }
    
    func bindRx() {
        // cryptoBool에 따라 버튼title / textfield isEnable값 변경
        viewModel.cryptoBool
            .subscribe(onNext: {
                self.cryptoTextField.isEnabled = !$0
                $0 ? self.cryptoButton.setTitle("복호화", for: .normal) : self.cryptoButton.setTitle("암호화", for: .normal)
            })
            .disposed(by: disposeBag)
        
        // cryptoTextField TextDidChange
        cryptoTextField.rx.text
            .orEmpty
            .asObservable()
            .subscribe(onNext: {
                self.originLabel.text = "기존 텍스트 : \($0)"
                self.viewModel.inputText.accept($0)
            })
            .disposed(by: disposeBag)
        
        // cryptoButton 버튼 탭 / 버튼 제목에 따라 함수 분기처리
        cryptoButton.rx.tap
            .subscribe(onNext: {
                let title = self.cryptoButton.titleLabel?.text
                title == "암호화" ? self.viewModel.encrypt() : self.viewModel.decrypt()
            })
            .disposed(by: disposeBag)
        
        // viewModel에서 기존 텍스트에서 암호화된 텍스트 view에 bind
        viewModel.encryptedText
            .map { "암호화 텍스트 : \($0)" }
            .bind(to: encryptLabel.rx.text)
            .disposed(by: disposeBag)
        
        // viewModel에서 암호화 텍스트에서 복호화된 텍스트 view에 bind
        viewModel.decryptedText
            .map { "복호화 텍스트 : \($0)" }
            .bind(to: decryptLabel.rx.text)
            .disposed(by: disposeBag)
    }
}


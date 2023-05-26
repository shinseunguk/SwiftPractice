//
//  LoginViewModel.swift
//  SwiftPractice
//
//  Created by ukseung.dev on 2023/05/26.
//

import Foundation
import RxSwift
import RxCocoa

final class LoginViewModel {
    let identityTextValue = BehaviorRelay<String>(value: "")
    let passwordTextValue = BehaviorRelay<String>(value: "")
    
    let a = PublishSubject<Int>()
    
    
    var isValid : Observable<Bool> { // 아이디 / 비밀번호 Validation
        return Observable.combineLatest(identityTextValue, passwordTextValue)
            .map { return !$0.isEmpty && $0.contains("@") && $0.contains(".") && $1.count >= 8 }
    }
    
    let loginResult = PublishRelay<Bool>() // 로그인 결과
    
    func login() {
        let idValue = identityTextValue.value
        let pwValue = passwordTextValue.value
        
        if idValue == "krdut1@gmail.com" && pwValue == "12345678" {
            self.loginResult.accept(true)
        }else {
            self.loginResult.accept(false)
        }
    }
}

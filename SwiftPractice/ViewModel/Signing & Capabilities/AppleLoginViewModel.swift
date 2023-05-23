//
//  AppleLoginViewModel.swift
//  SwiftPractice
//
//  Created by ukseung.dev on 2023/05/22.
//

import Foundation
import RxSwift
import RxCocoa
import AuthenticationServices

final class AppleLoginViewModel: NSObject {
    let signInButtonTapped = PublishRelay<Void>()
    let signInCompleted = PublishRelay<AppleUser>()
    
    private let disposeBag = DisposeBag()
    
    override init() {
        super.init()
        
        signInButtonTapped
            .subscribe(onNext: { [weak self] in
                self?.performAppleSignIn()
            })
            .disposed(by: disposeBag)
    }
    
    //애플 로그인
    func performAppleSignIn() {
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.performRequests()
    }
}

extension AppleLoginViewModel: ASAuthorizationControllerDelegate {
    
    // 애플 로그인 성공
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            let userIdentifier = appleIDCredential.user
            let familyName = appleIDCredential.fullName?.familyName
            let givenName = appleIDCredential.fullName?.givenName
            let email = appleIDCredential.email
            let state = appleIDCredential.state
            
            let user = AppleUser(
                userIdentifier: userIdentifier,
                familyName: familyName,
                givenName: givenName,
                email: email
            )
            
            signInCompleted.accept(user)
        }
    }
    
    // 애플 로그인 실패
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Apple Sign In Error: \(error.localizedDescription)")
    }
}

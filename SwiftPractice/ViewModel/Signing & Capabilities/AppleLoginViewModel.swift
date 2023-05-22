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
                email: email,
                state: state
            )
            
            signInCompleted.accept(user)
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Apple Sign In Error: \(error.localizedDescription)")
    }
}

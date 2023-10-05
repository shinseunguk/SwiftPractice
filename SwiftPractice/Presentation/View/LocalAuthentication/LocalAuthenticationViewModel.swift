//
//  LocalAuthenticationViewModel.swift
//  SwiftPractice
//
//  Created by ukseung.dev on 2023/10/05.
//

import Foundation
import RxSwift
import RxCocoa
import LocalAuthentication

enum AuthType {
    case appCancel
    case userCancel
    case biometryNotAvailable
    case biometryNotEnrolled
    case biometryLockout
    case authenticationFailed
    case success

    var message: String {
        switch self {
        case .appCancel:
            return "앱에 의해 인증이 취소되었습니다"
        case .userCancel:
            return "사용자에 의해 인증이 취소되었습니다"
        case .biometryNotAvailable:
            return "이 기기에서는 Face ID / Touch ID를 사용할 수 없습니다"
        case .biometryNotEnrolled:
            return "사용자가 Face ID / Touch ID를 등록하지 않았습니다"
        case .biometryLockout:
            return "Face ID / TouchID가 너무 많은 실패 시도로 잠겼습니다"
        case .authenticationFailed:
            return "Face ID / TouchID 인증에 실패했습니다"
        case .success:
            return "Face ID / TouchID 인증 성공"
        }
    }
}


final class LocalAuthenticationViewModel {
    let authenticationSubject = PublishSubject<AuthType>()
    let context = LAContext()
    var error: NSError?
    
    func authenticateWithBiometrics() {
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Face ID / TouchID로 인증을 시도합니다") { success, error in
                if success {
                    // Face ID authentication succeeded
                    self.authenticationSubject.onNext(AuthType.success)
                } else {
                    // Face ID authentication failed
                    if let error = error as? LAError {
                        switch error.code {
                        case .appCancel:
                            self.authenticationSubject.onNext(AuthType.appCancel)
                        case .userCancel:
                            self.authenticationSubject.onNext(AuthType.userCancel)
                        case .biometryNotAvailable:
                            self.authenticationSubject.onNext(AuthType.biometryNotAvailable)
                        case .biometryNotEnrolled:
                            self.authenticationSubject.onNext(AuthType.biometryNotEnrolled)
                        case .biometryLockout:
                            self.authenticationSubject.onNext(AuthType.biometryLockout)
                        default:
                            print("Face ID authentication failed: \(error.localizedDescription)")
                        }
                    }
                }
            }
    }
}


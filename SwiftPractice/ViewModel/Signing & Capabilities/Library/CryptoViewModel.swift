//
//  CryptoViewModel.swift
//  SwiftPractice
//
//  Created by ukseung.dev on 2023/05/25.
//

import Foundation
import RxSwift
import RxCocoa
import CryptoSwift

final class CryptoViewModel {
    
    let inputText = BehaviorRelay<String>(value: "")
    let encryptedText = BehaviorRelay<String>(value: "")
    let decryptedText = BehaviorRelay<String>(value: "")
    
    let cryptoBool = BehaviorRelay<Bool>(value: false)
    
    private let encryptionKey = "SecretKey123"
    
    func encrypt() {
        guard let input = inputText.value.data(using: .utf8) else {
            return
        }
        
        do {
            let password = Array(encryptionKey.utf8)
            let salt = Array("salt".utf8)
            let derivedKey = try PKCS5.PBKDF2(password: password, salt: salt).calculate()
            
            let aes = try AES(key: derivedKey, blockMode: ECB(), padding: .pkcs7)
            let encrypted = try aes.encrypt(input.bytes)
            let encryptedData = Data(encrypted)
            let encryptedString = encryptedData.base64EncodedString()
            
            encryptedText.accept(encryptedString)
            cryptoBool.accept(true)
        } catch {
            print("Encryption error: \(error)")
        }
    }
    
    func decrypt() {
        guard let input = Data(base64Encoded: encryptedText.value) else {
            return
        }
        
        do {
            let password = Array(encryptionKey.utf8)
            let salt = Array("salt".utf8)
            let derivedKey = try PKCS5.PBKDF2(password: password, salt: salt).calculate()
            
            let aes = try AES(key: derivedKey, blockMode: ECB(), padding: .pkcs7)
            let decrypted = try aes.decrypt(input.bytes)
            let decryptedData = Data(decrypted)
            
            if let decryptedString = String(data: decryptedData, encoding: .utf8) {
                decryptedText.accept(decryptedString)
                cryptoBool.accept(false)
            }
        } catch {
            print("Decryption error: \(error)")
        }
    }
}

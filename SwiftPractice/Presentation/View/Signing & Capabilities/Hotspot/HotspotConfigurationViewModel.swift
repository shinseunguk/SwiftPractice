//
//  HotspotConfigurationViewModel.swift
//  SwiftPractice
//
//  Created by ukseung.dev on 2023/05/22.
//

import Foundation
import NetworkExtension
import RxSwift
import RxCocoa

final class HotspotConfigurationViewModel {
    
    let inCompleted = PublishRelay<String>()
    
    func connectToHotspot() {
        let hotspotConfig = NEHotspotConfiguration(ssid: "욱", passphrase: "1234567890", isWEP: false)
        hotspotConfig.joinOnce = true
        
        NEHotspotConfigurationManager.shared.apply(hotspotConfig) { error in
            if let error = error {
                print("핫스팟 연결 실패")
                self.inCompleted.accept("Failed to connect to Wi-Fi hotspot: \(error.localizedDescription)")
            } else {
                print("핫스팟 연결 성공")
                self.inCompleted.accept("Successfully connected to Wi-Fi hotspot")
            }
        }
    }
}

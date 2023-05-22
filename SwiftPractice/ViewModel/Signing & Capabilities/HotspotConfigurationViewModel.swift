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
    
    func getWiFiInformation() {
        NEHotspotHelper.register(options: nil, queue: DispatchQueue.main) { (command) in
            if let wifiList = command.networkList {
                for wifi in wifiList {
                    let ssid = wifi.ssid
                    let bssid = wifi.bssid
                    let signalStrength = wifi.signalStrength

                    print("SSID: \(ssid)")
                    print("BSSID: \(bssid)")
                    print("Signal Strength: \(signalStrength)")
                }
            }
        }
    }
    
    func connectToHotspot(ssid: String, password: String) {
        let hotspotConfig = NEHotspotConfiguration(ssid: ssid, passphrase: password, isWEP: false)
        hotspotConfig.joinOnce = true
        
        NEHotspotConfigurationManager.shared.apply(hotspotConfig) { error in
            if let error = error {
                print("Failed to connect to Wi-Fi hotspot: \(error.localizedDescription)")
            } else {
                print("Successfully connected to Wi-Fi hotspot")
            }
        }
    }
    
    func connectToHotspot() {
        let hotspotConfig = NEHotspotConfiguration(ssid: "욱", passphrase: "1234567890", isWEP: false)
        hotspotConfig.joinOnce = true
        
        NEHotspotConfigurationManager.shared.apply(hotspotConfig) { error in
            if let error = error {
                print("Failed to connect to Wi-Fi hotspot: \(error.localizedDescription)")
            } else {
                print("Successfully connected to Wi-Fi hotspot")
            }
        }
    }
}

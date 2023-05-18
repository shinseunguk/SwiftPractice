//
//  Extension+UIView.swift
//  SwiftPractice
//
//  Created by ukBook on 2023/05/18.
//

import Foundation
import UIKit

extension UIView {
    func applyGradient(colors: [UIColor], startPoint: CGPoint, endPoint: CGPoint) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        gradientLayer.frame = bounds
        
        // Remove any existing gradient layer
        layer.sublayers?.filter { $0 is CAGradientLayer }.forEach { $0.removeFromSuperlayer() }
        
        // Add new gradient layer
        layer.insertSublayer(gradientLayer, at: 0)
    }
}

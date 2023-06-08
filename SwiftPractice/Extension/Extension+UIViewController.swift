//
//  Extension+UIViewController.swift
//  SwiftPractice
//
//  Created by ukseung.dev on 2023/06/08.
//

import Foundation
import UIKit

extension UIViewController {
    func showAlert(_ title: String, _ message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertVC, animated: true, completion: nil)
    }
}

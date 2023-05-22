//
//  ExampleViewController.swift
//  SwiftPractice
//
//  Created by ukseung.dev on 2023/05/22.
//

import Foundation
import UIKit

final class ExampleViewController: UIViewController, UIViewControllerAttribute {
    
    var navTitle: String?
    
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
    }
    
    func setAttributes() {
        
    }
    
    func bindRx() {
        
    }
}

//
//  View0Cotnroller.swift
//  SwiftPractice
//
//  Created by ukBook on 2023/05/17.
//

import Foundation
import UIKit

class View0Cotnroller: UIViewController, ViewAttribute {
    
    var navTitle: String?
    
    lazy var testLabel = UILabel().then {
        $0.text = "123"
        $0.sizeToFit()
    }
    
    lazy var scrollView = UIScrollView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.layer.borderWidth = 1
        $0.isScrollEnabled = true
    }
    
    lazy var contentView = UIView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .blue
    }
    
    override func viewDidLoad() {
        
        setNavigtaionBar()
        setUI()
        setAttributes()
        bindRx()
    }
    
    func setNavigtaionBar() {
        guard let title = navTitle else { log("no navTitle"); return }
        self.navigationItem.title = title
    }
    
    func setUI() {
        self.navigationController?.navigationBar.isHidden = false
        
        self.view.backgroundColor = .white
        self.view.addSubview(scrollView)
        
        scrollView.addSubview(contentView)
        contentView.addSubview(testLabel)
    }
    
    func setAttributes() {
        scrollView.snp.makeConstraints {
            $0.left.right.top.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints {
            $0.top.left.right.bottom.equalTo(scrollView)
            $0.width.equalTo(scrollView.snp.width)
        }
        
        testLabel.snp.makeConstraints {
            $0.top.left.equalTo(30)
        }
    }
    
    func bindRx() {
        
    }
}

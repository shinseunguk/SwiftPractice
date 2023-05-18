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
    var lastContentOffsetY: CGFloat = 0.0
    
    lazy var testLabel = UILabel().then {
        $0.text = "123"
        $0.sizeToFit()
    }
    
    lazy var scrollView = UIScrollView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.layer.borderWidth = 1
        $0.isScrollEnabled = true
        $0.delegate = self
    }
    
    lazy var contentView = UIView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .systemBlue
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
            $0.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.top.bottom.width.equalToSuperview()
            $0.height.equalTo(2000)
        }
        
        testLabel.snp.makeConstraints {
            $0.top.left.equalToSuperview().offset(30)
        }
        
        scrollView.contentSize = contentView.bounds.size
    }
    
    func bindRx() {
        
    }
}

extension View0Cotnroller: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > lastContentOffsetY {
            // Scroll down, hide the navigation bar
            if navigationController?.isNavigationBarHidden == false {
                UIView.animate(withDuration: 0.3) {
                    self.navigationController?.setNavigationBarHidden(true, animated: true)
                }
            }
        } else if scrollView.contentOffset.y < lastContentOffsetY {
            // Scroll up, show the navigation bar
            if navigationController?.isNavigationBarHidden == true {
                UIView.animate(withDuration: 0.3) {
                    self.navigationController?.setNavigationBarHidden(false, animated: true)
                }
            }
        }

        lastContentOffsetY = scrollView.contentOffset.y
    }
    
}

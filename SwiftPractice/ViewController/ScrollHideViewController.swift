//
//  ScrollHideViewController.swift
//  SwiftPractice
//
//  Created by ukBook on 2023/05/17.
//

import Foundation
import UIKit

final class ScrollHideViewController: UIViewController, UIViewControllerAttribute {
    
    var navTitle: String?
    var lastContentOffset: CGFloat = 0.0
    
    lazy var testLabel = UILabel().then {
        
        guard let title = navTitle else {
            return
        }
        $0.text = "\(title)"
        $0.sizeToFit()
        $0.textAlignment = .center
        $0.textColor = .black
    }
    
    lazy var scrollView = UIScrollView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.isScrollEnabled = true
        $0.delegate = self
    }
    
    lazy var contentView = UIView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .systemBlue
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        setUI()
        setAttributes()
    }
    
    
    /// 네비게이션 바 init
    func setNavigationBar() {
        self.navigationItem.title = navTitle ?? ""
    }
    
    /// UI Set
    func setUI() {
        self.navigationController?.navigationBar.isHidden = false
        
        self.view.backgroundColor = .white
        self.view.addSubview(scrollView)
        
        scrollView.addSubview(contentView)
        contentView.addSubview(testLabel)
    }
    
    /// Attribute Set
    func setAttributes() {
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.top.bottom.width.equalToSuperview()
            $0.height.equalTo(2000)
        }
        
        testLabel.snp.makeConstraints {
            $0.left.equalTo(20)
            $0.right.equalTo(-20)
            $0.top.equalTo(550)
        }
        
        scrollView.contentSize = contentView.bounds.size
    }
    
    
    /// RxSwift (미사용)
    func bindRx() {
        
    }
}

extension ScrollHideViewController: UIScrollViewDelegate {
    
    /// 스크롤 뷰 올리고 내리는거에 따라 scrollView Hide ON/OFF
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        
        if offsetY > lastContentOffset && offsetY > 0 { // 스크롤을 아래로 내리는 중이고, offsetY가 0보다 클 때
            UIView.animate(withDuration: 0.3) {
                self.navigationController?.setNavigationBarHidden(true, animated: true)
            }
            
        } else if offsetY < lastContentOffset { // 스크롤을 위로 올리는 중
            UIView.animate(withDuration: 0.3) {
                self.navigationController?.setNavigationBarHidden(false, animated: true)
            }
        }
        
        lastContentOffset = offsetY
    }
    
}

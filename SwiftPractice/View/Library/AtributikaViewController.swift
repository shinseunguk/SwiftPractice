//
//  AtributikaViewController.swift
//  SwiftPractice
//
//  Created by ukseung.dev on 2023/05/25.
//

import Foundation
import Atributika

final class AtributikaViewController: UIViewController, UIViewControllerAttribute {
    
    var navTitle: String?
    
    lazy var testLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.sizeToFit()
        $0.textAlignment = .center
        $0.textColor = .black
    }
    
    // Define styles for tags
    let boldStyle = Style("b").font(.boldSystemFont(ofSize: 16))
    let linkStyle = Style("a").foregroundColor(.blue).underlineStyle(.single)
    let customTagStyle = Style("customTag").font(.italicSystemFont(ofSize: 14)).foregroundColor(.red)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        setUI()
        setAttributes()
        bindRx() // 미사용 함수
        
        styledTextWithAtributika()
    }
    
    func setNavigationBar() {
        self.navigationItem.title = navTitle ?? ""
    }
    
    func setUI() {
        self.view.backgroundColor = .white
        //        self.view.addSubview(attributedText)
        self.view.addSubview(testLabel)
    }
    
    func setAttributes() {
        testLabel.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(50)
            $0.centerX.equalToSuperview()
        }
    }
    
    /// 미사용 함수
    func bindRx() {
        
    }
    
    func styledTextWithAtributika() {
        let attributedText1 = """
            Hello, <b>World!</b>
            
            Visit our website: <a href="https://www.example.com">example.com</a>
            
            This is a <customTag>custom tag</customTag> example.
            """.style(tags: boldStyle, linkStyle, customTagStyle)
        testLabel.attributedText = attributedText1.attributedString
    }
}

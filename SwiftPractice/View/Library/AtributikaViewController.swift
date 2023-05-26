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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        setUI()
        setAttributes()
        
        styledTextWithAtributika()
    }
    
    func setNavigationBar() {
        self.navigationItem.title = navTitle ?? ""
    }
    
    func setUI() {
        self.view.backgroundColor = .white
        self.view.addSubview(testLabel)
    }
    
    func setAttributes() {
        testLabel.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(50)
            $0.centerX.equalToSuperview()
        }
    }
    
    func styledTextWithAtributika() {
        // Define styles for tags
        let boldStyle = Style("b").font(.boldSystemFont(ofSize: 16))
        let linkStyle = Style("a").foregroundColor(.blue).underlineStyle(.single)
        let customTagStyle = Style("customTag").font(.italicSystemFont(ofSize: 14)).foregroundColor(.red)
        
        // 여러줄에 걸쳐 문자열(HTML코드)을 작성
        let attributedText = """
            Hello, <b>World!</b>
            
            Visit our website: <a href="https://www.example.com">example.com</a>
            
            This is a <customTag>custom tag</customTag> example.
            """.style(tags: boldStyle, linkStyle, customTagStyle)
        testLabel.attributedText = attributedText.attributedString
    }
}

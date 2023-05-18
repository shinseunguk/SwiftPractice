//
//  IndexTableViewCell.swift
//  SwiftPractice
//
//  Created by ukBook on 2023/05/12.
//

import UIKit

class IndexTableViewCell: UITableViewCell, ViewAttribute {
    
    lazy var title = UILabel().then {
        $0.sizeToFit()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUI()
        setAttributes()
        bindRx()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI() {
        self.addSubview(title)
    }
    
    func setAttributes() {
        title.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(20)
        }
    }
    
    func bindRx() {
        
    }

}

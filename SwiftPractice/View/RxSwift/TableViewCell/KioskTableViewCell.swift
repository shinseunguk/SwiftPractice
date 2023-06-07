//
//  KioskTableViewCell.swift
//  SwiftPractice
//
//  Created by ukBook on 2023/05/28.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

final class KioskTableViewCell: UITableViewCell, ViewAttribute {
    private let cellDisposeBag = DisposeBag()
    
    var disposeBag = DisposeBag()
    let onCountChanged : (Int) -> (Void)
    
    let onData: AnyObserver<ViewMenu>
    let onChanged: Observable<Int>
    
    let plusButton = UIButton().then {
        $0.setImage(UIImage(systemName: "plus"), for: .normal)
        $0.tintColor = .darkGray
    }
    
    let minusButton = UIButton().then {
        $0.setImage(UIImage(systemName: "minus"), for: .normal)
        $0.tintColor = .darkGray
    }
    
    let titleLabel = UILabel().then {
        $0.sizeToFit()
        $0.font = .boldSystemFont(ofSize: 16)
    }
    
    let countLabel = UILabel().then {
        $0.textColor = .systemBlue
        $0.font = .boldSystemFont(ofSize: 15)
        $0.textAlignment = .left
        $0.sizeToFit()
    }
    
    let priceLabel = UILabel().then {
        $0.sizeToFit()
        $0.font = .systemFont(ofSize: 16)
        $0.textColor = .lightGray
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        let data = PublishSubject<ViewMenu>()
        let changing = PublishSubject<Int>()
        onCountChanged = { changing.onNext($0) }
        onChanged = changing
        
        onData = data.asObserver()
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        data.observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] menu in
                self?.titleLabel.text = menu.name
                self?.priceLabel.text = "\(menu.price)"
                self?.countLabel.text = "\(menu.count)"
            })
            .disposed(by: cellDisposeBag)
        
        setUI()
        setAttributes()
        bindRx()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.selectionStyle = .none
        disposeBag = DisposeBag()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI() {
        self.contentView.addSubview(plusButton)
        self.contentView.addSubview(minusButton)
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(countLabel)
        self.contentView.addSubview(priceLabel)
    }
    
    func setAttributes() {
        plusButton.snp.makeConstraints {
            $0.width.height.equalTo(30)
            $0.left.equalTo(20)
            $0.centerY.equalToSuperview()
        }
        
        minusButton.snp.makeConstraints {
            $0.width.height.equalTo(30)
            $0.left.equalTo(plusButton.snp.right).offset(10)
            $0.centerY.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.left.equalTo(minusButton.snp.right).offset(30)
            $0.centerY.equalTo(plusButton.snp.centerY)
        }
        
        countLabel.snp.makeConstraints {
            $0.left.equalTo(titleLabel.snp.right).offset(10)
            $0.centerY.equalTo(plusButton.snp.centerY)
        }
        
        priceLabel.snp.makeConstraints {
            $0.right.equalTo(-30)
            $0.centerY.equalTo(plusButton.snp.centerY)
        }
    }
    
    func bindRx() {
        plusButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.onCountChanged(1)
            })
            .disposed(by: cellDisposeBag)

        minusButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.onCountChanged(-1)
            })
            .disposed(by: cellDisposeBag)
    }
}

//
//  Kiosk2ViewModel.swift
//  SwiftPractice
//
//  Created by ukseung.dev on 2023/06/08.
//

import Foundation
import RxSwift
import RxCocoa

final class Kiosk2ViewModel {
    let disposeBag = DisposeBag()
    
    let fetchMenu = PublishSubject<[ViewMenu]>()
    let allMenus = BehaviorRelay<[ViewMenu]>(value: [])
    
    let itemsPrice = BehaviorRelay<String>(value: "")
    let vatPrice = BehaviorRelay<String>(value: "")
    let totalPrice = BehaviorRelay<String>(value: "")
    
    init() {
        fetchMenu
            .subscribe(onNext: { [weak self] viewMenu in
                self?.allMenus.accept(viewMenu)
            })
            .disposed(by: disposeBag)
        
        fetchMenu
            .map { $0.map { $0.count * $0.price }.reduce(0, +) }
            .map { $0.currencyKR() }
            .subscribe(onNext: { [weak self] in
                self?.itemsPrice.accept($0)
            })
            .disposed(by: disposeBag)
        
        fetchMenu
            .map { ($0.map { $0.count * $0.price }.reduce(0, +)) / 10 }
            .map { $0.currencyKR() }
            .subscribe(onNext: { [weak self] in
                self?.vatPrice.accept($0)
            })
            .disposed(by: disposeBag)
        
        fetchMenu
            .map { $0.map { $0.count * $0.price }.reduce(0, +) + ($0.map { $0.count * $0.price }.reduce(0, +)) / 10 }
            .map { $0.currencyKR() }
            .subscribe(onNext: { [weak self] in
                self?.totalPrice.accept($0)
            })
            .disposed(by: disposeBag)
    }
}

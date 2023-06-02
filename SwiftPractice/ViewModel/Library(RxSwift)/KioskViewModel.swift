//
//  KioskViewModel.swift
//  SwiftPractice
//
//  Created by ukseung.dev on 2023/05/26.
//

import Foundation
import RxCocoa
import RxSwift

final class KioskViewModel {
    let kioskApiService = KioskAPIService()
    let disposeBag = DisposeBag()
    
    let fetchMenus : AnyObserver<Void>
    let totalSelectedCountText = BehaviorSubject<Int>(value: 0)
    let totalPriceText = BehaviorSubject<Int>(value: 0)
    let allMenus = BehaviorSubject<[ViewMenu]>(value: [])
    
    let incleasing = PublishSubject<(menu: ViewMenu, inc: Int)>()
    
    
    init(api: KioskAPIService = KioskAPIService()) {
        let fetching = PublishSubject<Void>()
        
        fetchMenus = fetching.asObserver()
        
        fetching
            .flatMap(api.getUsers)
            .map { $0.map { ViewMenu($0) }}
            .subscribe(onNext: {
                self.allMenus.onNext($0)
            },onError: {
                tLog("onError \($0)")
            },onCompleted: {
                tLog("onCompleted")
            })
            .disposed(by: disposeBag)
        
        allMenus
            .map { $0.map{ $0.count }.reduce(0, +) }
            .subscribe(onNext: { [weak self] in
                self?.totalSelectedCountText.onNext($0)
            }, onError: {
                print("onError \($0)")
            }, onCompleted: {
                print("onCompleted")
            })
            .disposed(by: disposeBag)
        
        allMenus
            .map { $0.map { $0.count * $0.price }.reduce(0, +) }
            .subscribe(onNext: { [weak self] in
                self?.totalPriceText.onNext($0)
            }, onError: {
                print("onError \($0)")
            }, onCompleted: {
                print("onCompleted")
            })
            .disposed(by: disposeBag)
        
        incleasing.map { $0.menu.countUpdated(max(0, $0.menu.count + $0.inc)) }
            .withLatestFrom(allMenus) { (updated, originals) -> [ViewMenu] in
                originals.map {
                    guard $0.name == updated.name else { return $0 }
                    return updated
                }
            }
            .subscribe(onNext: allMenus.onNext)
            .disposed(by: disposeBag)
    }
    
    
    func clearAction() {
        allMenus
            .map { $0.map { $0.countUpdated(0) } }
            .subscribe(onNext: { [weak self] in
                
            })
            .disposed(by: disposeBag)
        
    }
}

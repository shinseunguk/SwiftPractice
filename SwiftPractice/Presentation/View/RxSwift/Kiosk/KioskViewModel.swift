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
    let clearMenus : AnyObserver<Void>
    let orderMenus : AnyObserver<Void>
    
    
    let errorMessage: Observable<NSError>
    let totalSelectedCountText = BehaviorSubject<Int>(value: 0)
    let totalPriceText = BehaviorSubject<Int>(value: 0)
    let allMenus = BehaviorSubject<[ViewMenu]>(value: [])
    let showOrderPage: Observable<[ViewMenu]>
    
    let incleasing = PublishSubject<(menu: ViewMenu, inc: Int)>()
    
    
    init(api: KioskAPIService = KioskAPIService()) {
        let fetching = PublishSubject<Void>()
        let clearing = PublishSubject<Void>()
        let ordering = PublishSubject<Void>()
        
        let error = PublishSubject<Error>()
        
        errorMessage = error.map { $0 as NSError }
        
        fetchMenus = fetching.asObserver()
        fetching
            .flatMap(api.getUsers)
            .map { $0.map { ViewMenu($0) }}
            .subscribe(onNext: allMenus.onNext)
            .disposed(by: disposeBag)
        
        clearMenus = clearing.asObserver()
        clearing.withLatestFrom(allMenus)
            .map { $0.map { $0.countUpdated(0) } }
            .subscribe(onNext: allMenus.onNext)
            .disposed(by: disposeBag)
        
        orderMenus = ordering.asObserver()
        
        showOrderPage = ordering.withLatestFrom(allMenus)
            .map { $0.filter { $0.count > 0 } }
            .do(onNext: { items in
                if items.count == 0 {
                    let err = NSError(domain: "No Orders", code: -1, userInfo: nil)
                    error.onNext(err)
                }
            })
            .filter { $0.count > 0 }
        
        
        allMenus
            .map { $0.map{ $0.count }.reduce(0, +) }
            .subscribe(onNext: totalSelectedCountText.onNext)
            .disposed(by: disposeBag)
        
        allMenus
            .map { $0.map { $0.count * $0.price }.reduce(0, +) }
            .subscribe(onNext: totalPriceText.onNext)
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
}

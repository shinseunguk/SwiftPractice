//
//  SkeletonViewModel.swift
//  SwiftPractice
//
//  Created by ukseung.dev on 2023/06/19.
//

import Foundation
import RxSwift
import RxCocoa

protocol SkeletonViewModelType {
    var fetchMenus: AnyObserver<Void> { get }
    var clearSelections: AnyObserver<Void> { get }
    var makeOrder: AnyObserver<Void> { get }
    var increaseMenuCount: AnyObserver<(menu: ViewMenu, inc: Int)> { get }
    
    var allMenus: Observable<[ViewMenu]> { get }
    var activated: Observable<Bool> { get }
    var errorMessage: Observable<NSError> { get }
    //    var allMenus: Observable<[ViewMenu]> { get }
    //    var totalSelectedCountText: Observable<String> { get }
    //    var totalPriceText: Observable<String> { get }
    //    var showOrderPage: Observable<[ViewMenu]> { get }
}

final class SkeletonViewModel: SkeletonViewModelType {
    let disposeBag = DisposeBag()
    
    // Input
    var fetchMenus: AnyObserver<Void>
    var clearSelections: AnyObserver<Void>
    var makeOrder: AnyObserver<Void>
    var increaseMenuCount: AnyObserver<(menu: ViewMenu, inc: Int)>
    
    // Output
    var activated: Observable<Bool>
    var errorMessage: Observable<NSError>
    var allMenus: Observable<[ViewMenu]>
    //    var totalSelectedCountText: Observable<String>
    //    var totalPriceText: Observable<String>
    //    var showOrderPage: Observable<[ViewMenu]>
    
    
    init(api:KioskAPIService = KioskAPIService()) {
        let fetching = PublishSubject<Void>()
        let clearing = PublishSubject<Void>()
        let ordering = PublishSubject<Void>()
        let increasing = PublishSubject<(menu: ViewMenu, inc: Int)>()
        
        let menus = BehaviorSubject<[ViewMenu]>(value: [])
        let activating = BehaviorSubject<Bool>(value: false)
        let error = PublishSubject<Error>()
        
        fetchMenus = fetching.asObserver()
        
        fetching
            .do(onNext: { _ in activating.onNext(true) })
            .flatMap(api.getUsers)
            .do(onNext: { dump($0) })
            .map { $0.map { ViewMenu($0) }}
            .do(onNext: { _ in activating.onNext(false) })
            .do(onError: { err in error.onNext(err) })
            .subscribe(onNext: menus.onNext)
            .disposed(by: disposeBag)
                
        activated = activating.distinctUntilChanged()
        errorMessage = error.map { $0 as NSError }
        allMenus = menus
        
                
        clearSelections = clearing.asObserver()
        makeOrder = ordering.asObserver()
        increaseMenuCount = increasing.asObserver()
    }
}

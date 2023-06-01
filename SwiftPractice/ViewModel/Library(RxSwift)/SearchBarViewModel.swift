//
//  SearchBarViewModel.swift
//  SwiftPractice
//
//  Created by ukseung.dev on 2023/06/01.
//

import Foundation
import RxSwift
import RxCocoa

final class SearchBarViewModel {
    let disposeBag = DisposeBag()
    var fetchMenus: AnyObserver<Void>
    var allMenus: Observable<[MenuItem]>
    let changeMenus = BehaviorSubject<[MenuItem]>(value: [])
    let menus = BehaviorSubject<[MenuItem]>(value: [])
    
    // KioskAPIService => 서버통신후 값 처리를 위한 더미데이터
    init(api: KioskAPIService = KioskAPIService()) {
        let fetching = PublishSubject<Void>()
        
        fetchMenus = fetching.asObserver()
        
        fetching
            .flatMap(api.getUsers)
            .do(onNext: { dump($0) })
            .subscribe(onNext: menus.onNext)
            .disposed(by: disposeBag)
        
        allMenus = menus
    }
    
    func filterData(searchText: String) {
        
        if searchText.isEmpty {
            tLog("")
        } else {
            tLog(searchText)
        }
    }
    
}

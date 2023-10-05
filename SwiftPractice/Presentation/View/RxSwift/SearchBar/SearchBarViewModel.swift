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
    var allMenus = PublishSubject<[MenuItem]>()
    let changeMenus = BehaviorSubject<[MenuItem]>(value: [])
    let menus = BehaviorSubject<[MenuItem]>(value: [])
    
    let isLoading = BehaviorRelay(value: true)
    
    // KioskAPIService => 서버통신후 값 처리를 위한 더미데이터
    init(api: KioskAPIService = KioskAPIService()) {
        let fetching = PublishSubject<Void>()
        
        fetchMenus = fetching.asObserver()
        
        fetching
            .flatMap(api.getUsers)
            .subscribe(onNext: {
                self.menus.onNext($0)
                self.allMenus.onNext($0)
                self.isLoading.accept(false)
            })
            .disposed(by: disposeBag)
    }
    
    func filterData(searchText: String) {
        if searchText.isEmpty {
            menus
                .subscribe(onNext: { [weak self] nonFilteredMenus in
                    self?.allMenus.onNext(nonFilteredMenus)
                })
                .disposed(by: disposeBag)
        } else {
            menus
                .map { menuItems -> [MenuItem] in
                    return menuItems.filter { $0.name.contains(searchText) }
                }
                .subscribe(onNext: { [weak self] filteredMenus in
                    self?.allMenus.onNext(filteredMenus)
                })
                .disposed(by: disposeBag)
        }
    }
}

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
    
    let menu = PublishSubject<[Menu]>()
    let isLoading = BehaviorSubject<Bool>(value: false)
    
    let totalPrice = PublishRelay<Int>()
    let totalCount = BehaviorRelay<Int>(value: 0)
    
    func fetchUsers() {
        isLoading.onNext(true)
        kioskApiService.getUsers()
            .subscribe(
                onNext: { [weak self] value in
                    self?.menu.onNext(value)
                    self?.isLoading.onNext(false)
                },
                onError: { [weak self] error in
                    // 에러 처리
                    self?.isLoading.onNext(false)
                }
            )
            .disposed(by: disposeBag)
    }
    
    func increaseCount(arrayIndex: Int) {
        //        let currentCount = totalCount.value
        //        totalCount.accept(currentCount + 1)
    }
    
    func decreaseCount(arrayIndex: Int) {
        //        let currentCount = totalCount.value
        //        if currentCount > 0 {
        //            totalCount.accept(currentCount - 1)
        //        }
    }
}

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
    
    let totalPrice = PublishRelay<Int>()
    let totalCount = BehaviorRelay<Int>(value: 0)
    
    var price : [Int]?
    var count : [BehaviorRelay<Int>] = [
        BehaviorRelay<Int>(value: 1),
        BehaviorRelay<Int>(value: 2),
        BehaviorRelay<Int>(value: 3),
        BehaviorRelay<Int>(value: 0),
        BehaviorRelay<Int>(value: 0),
        BehaviorRelay<Int>(value: 0),
        BehaviorRelay<Int>(value: 0),
        BehaviorRelay<Int>(value: 0),
        BehaviorRelay<Int>(value: 0),
        BehaviorRelay<Int>(value: 0),
        BehaviorRelay<Int>(value: 0),
        BehaviorRelay<Int>(value: 0),
        BehaviorRelay<Int>(value: 0),
        BehaviorRelay<Int>(value: 0),
        BehaviorRelay<Int>(value: 0)
    ]
    
    func increaseCount() {
        let currentCount = totalCount.value
        totalCount.accept(currentCount + 1)
    }

    func decreaseCount() {
        let currentCount = totalCount.value
        if currentCount > 0 {
            totalCount.accept(currentCount - 1)
        }
    }
}

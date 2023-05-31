//
//  ViewMenu.swift
//  SwiftPractice
//
//  Created by ukseung.dev on 2023/05/31.
//

import Foundation

struct ViewMenu {
    let name : String
    let price : Int
    let count : Int
    
    init(_ item: MenuItem) {
        name = item.name
        price = item.price
        count = 0
    }

    init(name: String, price: Int, count: Int) {
        self.name = name
        self.price = price
        self.count = count
    }

    func countUpdated(_ count: Int) -> ViewMenu {
        return ViewMenu(name: name, price: price, count: count)
    }

    func asMenuItem() -> MenuItem {
        return MenuItem(name: name, price: price)
    }
}

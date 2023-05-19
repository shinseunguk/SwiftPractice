//
//  DynamicHeightTableView.swift
//  SwiftPractice
//
//  Created by ukseung.dev on 2023/05/19.
//

import Foundation
import UIKit

final class DynamicHeightTableView: UITableView {
    override var intrinsicContentSize: CGSize {
        return contentSize
    }
}

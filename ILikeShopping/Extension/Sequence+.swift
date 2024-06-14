//
//  Sequence+.swift
//  ILikeShopping
//
//  Created by 김성민 on 6/14/24.
//

import Foundation

// 순서 보장 + 중복 제거
extension Sequence where Element: Hashable {
    func uniqued() -> [Element] {
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
    }
}

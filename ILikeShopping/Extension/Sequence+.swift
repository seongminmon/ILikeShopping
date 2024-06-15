//
//  Sequence+.swift
//  ILikeShopping
//
//  Created by 김성민 on 6/14/24.
//

import Foundation

extension Sequence where Element: Hashable {
    
    // 중복 제거 + 순서 보장
    func uniqued() -> [Element] {
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
    }
}

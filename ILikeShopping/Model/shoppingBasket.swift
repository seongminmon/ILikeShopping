//
//  shoppingBasket.swift
//  ILikeShopping
//
//  Created by 김성민 on 7/7/24.
//

import Foundation
import RealmSwift

class shoppingBasket: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var date: Date
    
    // 셀에 표시
    @Persisted var image: String
    @Persisted var mallName: String
    @Persisted var title: String
    @Persisted var lprice: String
    // 웹뷰
    @Persisted var link: String
    // 좋아요 관리
    @Persisted var productId: String
    
    convenience init(image: String, mallName: String, title: String, lprice: String, link: String, productId: String) {
        self.init()
        self.image = image
        self.mallName = mallName
        self.title = title
        self.lprice = lprice
        self.link = link
        self.productId = productId
    }
}

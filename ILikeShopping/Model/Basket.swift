//
//  Basket.swift
//  ILikeShopping
//
//  Created by 김성민 on 7/7/24.
//

import Foundation
import RealmSwift

// 가격대별로 폴더링 (10만원 이하, 10~100만원, 100만원 초과)
class Folder: Object {
    @Persisted var price: Int
    @Persisted var baskets: List<Basket>
    
    @Persisted var date: Date
    @Persisted(primaryKey: true) var id: ObjectId
}

class Basket: Object {
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
    
    // 역관계를 위한 컬럼
//    @Persisted(originProperty: "baskets") var main: LinkingObjects<Folder>
    
    var imageUrl: URL? {
        return URL(string: image)
    }
    
    var encodedString: String {
        return String(htmlEncodedString: title) ?? title
    }
    
    var price: String {
        return "\(Int(lprice)?.formatted() ?? "n/a")원"
    }
    
    var linkUrl: URL? {
        return URL(string: link)
    }
    
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

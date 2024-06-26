//
//  ShoppingResponse.swift
//  ILikeShopping
//
//  Created by 김성민 on 6/14/24.
//

import UIKit

struct ShoppingResponse: Decodable {
    let total: Int
    let start: Int
    let display: Int
    var items: [Shopping]
    
    var totalCountText: String {
        return "\(total.formatted())개의 검색 결과"
    }
}

struct Shopping: Codable {
    // 셀에 표시
    let image: String
    let mallName: String
    let title: String
    let lprice: String
    // 웹뷰
    let link: String
    // 좋아요 관리
    let productId: String
    
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
    
//    let hprice: String
//    let productType: String
//    let brand: String
//    let maker: String
//    let category1: String
//    let category2: String
//    let category3: String
//    let category4: String
}

//
//  ShoppingResponse.swift
//  ILikeShopping
//
//  Created by 김성민 on 6/14/24.
//

import Foundation

struct ShoppingResponse: Codable {
    let total: Int
    let start: Int
    let display: Int
    let items: [Shopping]
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
    
//    let hprice: String
//    let productType: String
//    let brand: String
//    let maker: String
//    let category1: String
//    let category2: String
//    let category3: String
//    let category4: String
}

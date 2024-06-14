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
    let title: String   // 2줄까지 표시
    let lprice: String
    // 웹뷰 띄울 때 필요
    let link: String
    // 고유한 값이므로 좋아요 관리
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

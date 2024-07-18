//
//  DetailViewModel.swift
//  ILikeShopping
//
//  Created by 김성민 on 7/11/24.
//

import Foundation

final class DetailViewModel {
    
    let repository = RealmRepository()
    
    // MARK: - Input
    // 뒤로 가기 (네비게이션)
    // 좋아요 버튼 누르기
    var inputLikeButtonTapped: Observable<Shopping?> = Observable(nil)
    
    // MARK: - Output
    var outputIsBasket: Observable<Bool?> = Observable(nil)
    
    init() {
        inputLikeButtonTapped.bind { [weak self] data in
            guard let self, let data else { return }
            if repository.isBasket(data.productId) {
                // Realm 삭제
                repository.deleteItem(data.productId)
            } else {
                // Realm에 추가
                let item = Basket(image: data.image, mallName: data.mallName, title: data.title, lprice: data.lprice, link: data.link, productId: data.productId)
                repository.addItem(item)
            }
            outputIsBasket.value = repository.isBasket(data.productId)
        }
    }
}

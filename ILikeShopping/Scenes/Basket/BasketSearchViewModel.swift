//
//  BasketSearchViewModel.swift
//  ILikeShopping
//
//  Created by 김성민 on 7/12/24.
//

import Foundation

final class BasketSearchViewModel {
    
    private let repository = RealmRepository()
    
    // MARK: - Input
    var inputUpdateSearchResults: Observable<String?> = Observable(nil)
    
    // MARK: - Output
    var outputList: Observable<[Basket]> = Observable([])
    
    init() {
        // 모델에서 초기값 가져오기
        outputList.value = repository.fetchAll()
        transform()
    }
    
    private func transform() {
        inputUpdateSearchResults.bind { [weak self] value in
            guard let self else { return }
            filterData(value)
        }
    }
    
    private func filterData(_ text: String?) {
        if let text, !text.isEmpty {
            // 검색어가 있으면 검색
            outputList.value = repository.fetchSearched(text)
        } else {
            // 검색어가 없으면 전체 불러오기
            outputList.value = repository.fetchAll()
        }
    }
}

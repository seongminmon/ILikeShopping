//
//  BasketSearchViewModel.swift
//  ILikeShopping
//
//  Created by 김성민 on 7/12/24.
//

import Foundation

final class BasketSearchViewModel {
    
    private let repository = RealmRepository()
    var list: [Basket] = []
    
    // MARK: - Input
    var inputUpdateSearchResults: Observable<String?> = Observable(nil)
    var inputSwipeToDelete: Observable<IndexPath?> = Observable(nil)
    
    // MARK: - Output
    var outputUpdateSearchResults: Observable<Void?> = Observable(nil)
    var outputSwipeToDelete: Observable<IndexPath?> = Observable(nil)
    
    init() {
        transform()
    }
    
    private func transform() {
        // 모델에서 초기값 가져오기
        list = repository.fetchAll()
        
        inputUpdateSearchResults.bind { [weak self] value in
            guard let self else { return }
            filterData(value)
        }
        
        inputSwipeToDelete.bind { [weak self] indexPath in
            guard let self, let indexPath else { return }
            deleteItem(indexPath)
        }
    }
    
    private func filterData(_ text: String?) {
        if let text, !text.isEmpty {
            // 검색어가 있으면 검색 (리스트 교체)
            list = repository.fetchSearched(text)
        } else {
            // 검색어가 없으면 전체 불러오기
            list = repository.fetchAll()
        }
        outputUpdateSearchResults.value = ()
    }
    
    private func deleteItem(_ indexPath: IndexPath) {
        let item = list[indexPath.row]
        // list 삭제
        list.remove(at: indexPath.row)
        // realm에서 삭제 (자식)
        repository.deleteItem(item.productId)
        outputSwipeToDelete.value = indexPath
    }
}

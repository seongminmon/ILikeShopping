//
//  MainViewModel.swift
//  ILikeShopping
//
//  Created by 김성민 on 7/10/24.
//

import Foundation

final class MainViewModel {
    
    private let ud = UserDefaultsManager.shared
    let naviTitle = "\(UserDefaultsManager.shared.nickname)'s ILikeShopping"
    
    // MARK: - Input
    // 서치 버튼
    var inputSearchButtonClicked: Observable<String?> = Observable(nil)
    // 셀 선택
    var inputCellSelected: Observable<Int?> = Observable(nil)
    // 삭제 버튼
    var inputDeleteButtonTapped: Observable<Int?> = Observable(nil)
    // 모두 삭제 버튼
    var inputDeleteAllButtonTapped: Observable<Void?> = Observable(nil)
    
    // MARK: - Output
    var outputList: Observable<[String]> = Observable(UserDefaultsManager.shared.searchWordList)
    
    init() {
        transform()
    }
    
    private func transform() {
        inputSearchButtonClicked.bind { [weak self] value in
            guard let self else { return }
            searchButtonClicked(value)
        }
        
        inputCellSelected.bind { [weak self] value in
            guard let self else { return }
            cellSelected(value)
        }
        
        inputDeleteButtonTapped.bind { [weak self] value in
            guard let self else { return }
            deleteItem(value)
        }
        
        inputDeleteAllButtonTapped.bind { [weak self] _ in
            guard let self else { return }
            deleteAll()
        }
    }
        
    private func searchButtonClicked(_ query: String?) {
        guard let query = query, query != "" else { return }
        ud.searchWordList.insert(query, at: 0)
        outputList.value = ud.searchWordList
    }
    
    private func cellSelected(_ index: Int?) {
        guard let index = index else { return }
        
        let query = ud.searchWordList[index]
        guard query != "" else { return }
        ud.searchWordList.remove(at: index)
        ud.searchWordList.insert(query, at: 0)
        outputList.value = ud.searchWordList
    }
    
    private func deleteItem(_ index: Int?) {
        guard let index = index else { return }
        ud.searchWordList.remove(at: index)
        outputList.value = ud.searchWordList
    }
    
    private func deleteAll() {
        guard inputDeleteAllButtonTapped.value != nil else { return }
        ud.searchWordList.removeAll()
        outputList.value = ud.searchWordList
    }
}

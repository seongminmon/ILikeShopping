//
//  BasketViewModel.swift
//  ILikeShopping
//
//  Created by 김성민 on 7/12/24.
//

import Foundation

final class BasketViewModel {
    
    private let repository = RealmRepository()
    private var option: FolderOption = .total
    private var folder: Folder?
    
    let naviTitle = "\(UserDefaultsManager.shared.nickname)'s Shopping List"
    
    // MARK: - Input
    // viewWillAppear
    var inputViewWillAppearTrigger: Observable<Void?> = Observable(nil)
    // 폴더버튼 * 4 탭 -> 폴더 변경
    var inputFolderButtonTapped: Observable<Int?> = Observable(nil)
    // 셀 버튼 탭 -> 렘삭제 + 리스트 삭제 + 사라짐
    var inputCellButtonTapped: Observable<Int?> = Observable(nil)
    
    // MARK: - Output
    // totalCountLabel - text
    var outputCountLabelText: Observable<String?> = Observable(nil)
    // collectionView - list
    var outputList: Observable<[Basket]> = Observable([])
    
    init() {
        transform()
    }
    
    private func transform() {
        inputViewWillAppearTrigger.bind { [weak self] _ in
            guard let self else { return }
            configureList()
        }
        
        inputFolderButtonTapped.bind { [weak self] tag in
            guard let self, let tag else { return }
            changeFolder(tag: tag)
        }
        
        inputCellButtonTapped.bind { [weak self] tag in
            guard let self, let tag else { return }
            deleteItem(tag: tag)
        }
    }
    
    private func configureList() {
        // 1. folder 변경
        folder = repository.fetchFilteredFolder(option)
        // 2. 리스트 변경
        // list는 폴더에 담겨있는 baskets 중 하나이거나 전체 basket(folder = nil일 때)
        if let folder = folder {
            outputList.value = Array(folder.baskets)
        } else {
            outputList.value = repository.fetchAll()
        }
        outputCountLabelText.value = "\(outputList.value.count.formatted())개의 쇼핑 리스트"
    }
    
    private func changeFolder(tag: Int) {
        // 1. option 변경
        option = FolderOption.allCases[tag]
        configureList()
    }
    
    private func deleteItem(tag: Int) {
        let data = outputList.value[tag]
        // Realm 삭제
        repository.deleteItem(data.productId)
        // list 삭제
        outputList.value.remove(at: tag)
        
        outputCountLabelText.value = "\(outputList.value.count.formatted())개의 쇼핑 리스트"
    }
}

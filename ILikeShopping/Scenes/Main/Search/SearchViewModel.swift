//
//  SearchViewModel.swift
//  ILikeShopping
//
//  Created by 김성민 on 7/10/24.
//

import Foundation

// TODO: - struct로 Input, Output 바꿔보기
//protocol ViewModelProtocol {
//    associatedtype Input
//    associatedtype Output
//    
//    func transform(_ input: Input) -> Output
//}

final class SearchViewModel {
    
//    struct Input {
//        var networkTrigger: Observable<Void?> = Observable(nil)
//        var pagenationTrigger: Observable<Int?> = Observable(nil)
//        var cellForItemAt: Observable<String?> = Observable(nil)
//        var cellLikeButtonClicked: Observable<Shopping?> = Observable(nil)
//    }
//
//    struct Output {
//        var list: Observable<ShoppingResponse?> = Observable(nil)
//        var scrollToTop: Observable<Void?> = Observable(nil)
//        var dailureAlert: Observable<String?> = Observable(nil)
//        var isBasket: Observable<Bool?> = Observable(nil)
//    }
    
    private let repository = RealmRepository()
    
    var query: String?  // 이전 화면에서 전달
    
    var sortOption: SortOption = .sim
    private var start = 1       // 페이지네이션 위한 변수
    
    // MARK: - Input
    // 네트워크 통신 처음인 경우: viewDidLoad 시점, 정렬 버튼 눌렀을 때
    var inputNetworkTrigger: Observable<Void?> = Observable(nil)
    // 네트워크 통신 페이지네이션인 경우: 스크롤 내렸을 때
    var inputPagenationTrigger: Observable<Int?> = Observable(nil)
    // 셀 그리기
    var inputCellForItemAt: Observable<String?> = Observable(nil)
    // 셀의 좋아요 버튼 누르기
    var inputCellLikeButtonClicked: Observable<Shopping?> = Observable(nil)
    
    // MARK: - Output
    // 네트워크 결과 받은 배열
    var outputList: Observable<ShoppingResponse?> = Observable(nil)
    var outputScrollToTop: Observable<Void?> = Observable(nil)
    var outputFailureAlert: Observable<String?> = Observable(nil)
    var outputIsBasket: Observable<Bool?> = Observable(nil)
    
    init() {
        transform()
    }
    
    private func transform() {
        inputNetworkTrigger.bind { [weak self] value in
            guard let self, value != nil else { return }
            
            // start 초기화 후 네트워크 요청
            start = 1
            callRequest()
        }
        
        inputPagenationTrigger.bind { [weak self] index in
            guard let self, let index,
                  let list = outputList.value else { return }
            
            if index == list.items.count - 8 &&
                list.items.count < list.total &&
                start <= 1000 {
                // start 증가 후 네트워크 요청
                start += NetworkRequest.display
                callRequest()
            }
        }
        
        inputCellForItemAt.bind { [weak self] value in
            guard let self, let value else { return }
            outputIsBasket.value = repository.isBasket(value)
        }
        
        inputCellLikeButtonClicked.bind { [weak self] data in
            guard let self, let data else { return }
            toggleItem(data)
        }
    }
    
    private func toggleItem(_ data: Shopping) {
        if repository.isBasket(data.productId) {
            // Realm 삭제
            repository.deleteItem(data.productId)
        } else {
            // Realm 추가
            let item = Basket(image: data.image, mallName: data.mallName, title: data.title, lprice: data.lprice, link: data.link, productId: data.productId)
            repository.addItem(item)
        }
        outputIsBasket.value = repository.isBasket(data.productId)
    }
    
    // MARK: - 네트워크
    
    private func callRequest() {
        print(#function)
        guard let query = query else { return }
        
        NetworkManager.shared.request(
            api: .search(query: query, start: start, sortOption: sortOption),
            model: ShoppingResponse.self
        ) { result in
            switch result {
            case .success(let data):
                self.successAction(data: data)
            case .failure(let error):
                self.failureAction(message: error.rawValue)
            }
        }
    }
    
    private func successAction(data: ShoppingResponse) {
        if start == 1 {
            // 첫 검색이라면 데이터 교체
            outputList.value = data
        } else {
            // 페이지네이션이라면 데이터 추가
            outputList.value?.items.append(contentsOf: data.items)
        }
        
        if start == 1 && data.total > 0 {
            // 첫 검색일 때 스크롤 맨 위로 올려주기 (reloadData 이후)
            outputScrollToTop.value = ()
        }
    }
    
    private func failureAction(message: String) {
        outputFailureAlert.value = message
    }
}

//
//  SearchViewController.swift
//  ILikeShopping
//
//  Created by 김성민 on 6/14/24.
//

import UIKit
import Alamofire
import Kingfisher
import SnapKit

enum SortOption: String {
    case sim
    case date
    case asc
    case dsc
}

class SearchViewController: UIViewController {

    // TODO: - 네트워크, 페이지네이션, 테이블뷰에 데이터 전달...
    // TODO: - 좋아요 저장 -> ud
    
    var query: String?  // 이전 화면에서 전달
    var shoppingData: ShoppingResponse? // 네트워크
    
    let display = 30    // 30으로 고정
    var start = 1       // 페이지네이션 위한 변수
    var sortOption: SortOption = .sim // 기본값 정확도 순
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureHierarchy()
        configureLayout()
        configureUI()
        
        callRequest(query: "매트리스")
    }
    
    func configureNavigationBar() {
        
    }
    
    func configureHierarchy() {
        
    }
    
    func configureLayout() {
        
    }
    
    func configureUI() {
        
    }
    
    func callRequest(query: String) {
        let url = APIURL.shoppingURL
        let param: Parameters = [
            "query" : query,
            "display" : display,
            "start" : start,
            "sort" : sortOption,
        ]
        let headers: HTTPHeaders = [
            "X-Naver-Client-Id" : APIKey.clientID,
            "X-Naver-Client-Secret" : APIKey.clientSecret,
        ]
        
        AF.request(
            url,
            method: .get,
            parameters: param,
            headers: headers
        ).responseDecodable(of: ShoppingResponse.self) { response in
            switch response.result {
            case .success(let value):
                dump(value)
                self.shoppingData = value
            case .failure(let error):
                print(error)
            }
        }
    }
    
}

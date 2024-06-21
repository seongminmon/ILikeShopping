//
//  NetworkManager.swift
//  ILikeShopping
//
//  Created by 김성민 on 6/21/24.
//

import Foundation
import Alamofire

class NetworkManager {
    
    // 싱글톤으로 생성
    static let shared = NetworkManager()
    private init() {}
    
    let display = 30 // 30으로 고정
    
    func callRequest(
        query: String,
        start: Int,
        sortOption: SortOption,
        completionHandler: @escaping (Result<ShoppingResponse, Error>) -> ()
    ) {
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
                print("SUCCESS")
                completionHandler(.success(value))
                
            case .failure(let error):
                print(error)
                completionHandler(.failure(error))
            }
        }
    }
    
}

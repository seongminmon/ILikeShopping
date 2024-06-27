//
//  NetworkRequest.swift
//  ILikeShopping
//
//  Created by 김성민 on 6/27/24.
//

import Foundation
import Alamofire

enum NetworkRequest {
    case search(query: String, start: Int, sortOption: SortOption)
    
    static let display = 30 // 30으로 고정
    
    var baseURL: String {
        return "https://openapi.naver.com/v1/"
    }
    
    var endpoint: URL {
        switch self {
        case .search:
            return URL(string: baseURL + "search/shop.json")!
        }
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var parameters: Parameters {
        switch self {
        case .search(let query, let start, let sortOption):
            return [
                "query" : query,
                "display" : NetworkRequest.display,
                "start" : start,
                "sort" : sortOption,
            ]
        }
    }
    
    var encoding: URLEncoding {
        return URLEncoding(destination: .queryString)
    }
    
    var headers: HTTPHeaders {
        switch self {
        case .search(let query, let start, let sortOption):
            return [
                "X-Naver-Client-Id" : APIKey.clientID,
                "X-Naver-Client-Secret" : APIKey.clientSecret,
            ]
        }
    }
    
}

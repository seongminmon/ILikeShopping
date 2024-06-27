//
//  NetworkManager.swift
//  ILikeShopping
//
//  Created by 김성민 on 6/21/24.
//

import Foundation
import Alamofire
import Network

// TODO: - 상태코드에 따라 열거형으로 오류 처리하기
// TODO: - NWPathMonitor로 네트워크 감지하기
class NetworkManager {
    
    // 싱글톤으로 생성
    static let shared = NetworkManager()
    private init() {}
    
    func callRequest(
        api: NetworkRequest,
        completionHandler: @escaping (Result<ShoppingResponse, Error>) -> ()
    ) {
        AF.request(api.endpoint,
                   method: api.method,
                   parameters: api.parameters,
                   encoding: api.encoding,
                   headers: api.headers)
        .validate(statusCode: 200..<500)
        .responseDecodable(of: ShoppingResponse.self) { response in
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

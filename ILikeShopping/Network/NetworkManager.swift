//
//  NetworkManager.swift
//  ILikeShopping
//
//  Created by 김성민 on 6/21/24.
//

import Foundation
import Alamofire
// TODO: - NWPathMonitor로 네트워크 감지하기
import Network

//struct ErrorResponse: Decodable {
//    let errorMessage: String
//    let errorCode: String
//}

// 열거형으로 Error Handling
enum APIError: String, Error {
    case failedRequest = "요청에 실패 하였습니다."
    case noData = "데이터가 없습니다."
    case invalidResponse = "응답이 없습니다."
    case failedResponse = "응답을 받을 수 없습니다."
    case invalidData = "검색어와 일치하는 상품이 없습니다."
}

class NetworkManager {
    
    // 싱글톤으로 생성
    static let shared = NetworkManager()
    private init() {}
    
//    func callRequest(
//        api: NetworkRequest,
//        completionHandler: @escaping (Result<ShoppingResponse, APIError>) -> Void
//    ) {
//        AF.request(api.endpoint,
//                   method: api.method,
//                   parameters: api.parameters,
//                   encoding: api.encoding,
//                   headers: api.headers)
//        .validate(statusCode: 200..<500)
//        .responseDecodable(of: ShoppingResponse.self) { response in
//            switch response.result {
//            case .success(let value):
//                print("SUCCESS")
//                completionHandler(.success(value))
//                
//            case .failure(let error):
//                print(error)
//                completionHandler(.failure(.failedRequest))
//            }
//        }
//    }
    
    // URLSession
    func callRequest(
        api: NetworkRequest,
        completionHandler: @escaping (
            Result<ShoppingResponse, APIError>) -> Void
    ) {
        // 1. URLComponent
        var component = URLComponents(url: api.endpoint, resolvingAgainstBaseURL: false)!
        component.queryItems = api.parameters.map { (key, value) in
            URLQueryItem(name: key, value: "\(value)")
        }
        
        // 2. URLRequest
        var request = URLRequest(url: component.url!, timeoutInterval: 5)
        request.headers = api.headers
        
        // 3. dataTask
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                guard error == nil else {
                    print("Failed Request")
                    completionHandler(.failure(.failedRequest))
                    return
                }
                
                guard let data = data else {
                    print("No Data")
                    completionHandler(.failure(.noData))
                    return
                }
                
                guard let response = response as? HTTPURLResponse else {
                    print("Invalid Response")
                    completionHandler(.failure(.invalidResponse))
                    return
                }
                
                guard response.statusCode == 200 else {
                    print("Failed Response")
                    completionHandler(.failure(.failedResponse))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(ShoppingResponse.self, from: data)
                    print("SUCCESS")
                    completionHandler(.success(result))
                } catch {
                    print("Invalid Data")
                    completionHandler(.failure(.invalidData))
                }
            }
        }
        .resume()   // 4. resume()
    }
    
}

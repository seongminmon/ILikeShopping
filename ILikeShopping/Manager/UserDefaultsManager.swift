//
//  UserDefaultsManager.swift
//  ILikeShopping
//
//  Created by 김성민 on 6/13/24.
//

import UIKit

class UserDefaultsManager {
    
    private init() {}
    static let shared = UserDefaultsManager()
    
    let ud = UserDefaults.standard
    
    func removeAll() {
        Key.allCases.forEach { ud.removeObject(forKey: $0.rawValue) }
    }
    
    enum Key: String, CaseIterable {
        case nickname
        case profileImageIndex
        case signUpDate
        
        case searchWordList
        case starList
    }
    
    // MARK: - SignIn
    
    var nickname: String {
        get {
//            print("닉네임 불러오기")
            return ud.string(forKey: Key.nickname.rawValue) ?? ""
        }
        set {
//            print("닉네임 저장")
            ud.set(newValue, forKey: Key.nickname.rawValue)
        }
    }
    
    var profileImageIndex: Int {
        get {
//            print("프로필 이미지 인덱스 불러오기")
            return ud.integer(forKey: Key.profileImageIndex.rawValue)
        }
        set {
//            print("프로필 이미지 인덱스 저장")
            ud.set(newValue, forKey: Key.profileImageIndex.rawValue)
        }
    }
    
    var signUpDate: Date? {
        get {
            let storedDate = ud.object(forKey: Key.signUpDate.rawValue) as? Date
//            print("가입날짜 불러오기: \(String(describing: storedDate))")
            return storedDate
        }
        set {
//            print("가입 날짜 저장")
            ud.set(newValue, forKey: Key.signUpDate.rawValue)
        }
    }
    
    var profileImage: UIImage {
        return MyImage.profileImageList[profileImageIndex]
    }
    
    var signUpDateString: String? {
        guard let signUpDate else { return nil }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy. MM. dd"
        let str = formatter.string(from: signUpDate)
        return "\(str) 가입"
    }
    
    var isSignIn: Bool {
        return signUpDate != nil
    }
    
    // MARK: - Shopping
    
    var searchWordList: [String] {
        get {
            let storedSearchWordList = ud.object(forKey: Key.searchWordList.rawValue) as? [String]
//            print("검색어리스트 불러오기: \(storedSearchWordList ?? [])")
            return storedSearchWordList ?? []
        }
        set {
//            print("검색어리스트 저장")
            // 중복 데이터 제거 (순서 보장)
            ud.set(newValue.uniqued(), forKey: Key.searchWordList.rawValue)
        }
    }
    
    // 좋아요를 누를 수 있는 화면
    // 1. 검색 결과 화면
    // 2. 상세페이지 웹뷰 화면
    
    // 좋아요 표시가 되는 화면
    // 1. 검색 결과 화면 셀
    // 2. 상세페이지 화면 네비게이션 아이템
    // 3. 설정 화면 셀
    
    // productId 저장하여 관리
    var starList: [String] {
        get {
            let storedStarList = ud.object(forKey: Key.starList.rawValue) as? [String]
//            print("즐겨찾기 리스트 불러오기: \(storedStarList ?? [])")
            return storedStarList ?? []
        }
        set {
//            print("즐겨찾기 리스트 저장")
            ud.set(newValue.uniqued(), forKey: Key.starList.rawValue)
        }
    }
    
}

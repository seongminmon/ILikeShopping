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
    
    let userDefaults = UserDefaults.standard
    
    enum Key: String {
        case nickname
        case profileImageIndex
        case signUpDate
        case shoppingList
    }
    
    var nickname: String {
        get {
            print("닉네임 불러오기")
            return userDefaults.string(forKey: Key.nickname.rawValue) ?? "OOO"
        }
        set {
            print("닉네임 저장")
            userDefaults.set(newValue, forKey: Key.nickname.rawValue)
        }
    }
    
    var profileImageIndex: Int {
        get {
            print("프로필 이미지 인덱스 불러오기")
            return userDefaults.integer(forKey: Key.profileImageIndex.rawValue)
        }
        set {
            print("프로필 이미지 인덱스 저장")
            userDefaults.set(newValue, forKey: Key.profileImageIndex.rawValue)
        }
    }
    
    var signUpDate: Date? {
        get {
            let storedDate = userDefaults.object(forKey: Key.signUpDate.rawValue) as? Date
            print("가입날짜 불러오기: \(String(describing: storedDate))")
            return storedDate
        }
        set {
            print("가입 날짜 저장")
            userDefaults.set(newValue, forKey: Key.signUpDate.rawValue)
        }
    }
    
    var shoppingList: [Int] {
        get {
            let storedShoppingList = userDefaults.object(forKey: Key.shoppingList.rawValue) as? [Int]
            print("쇼핑리스트 불러오기: \(storedShoppingList ?? [])")
            return storedShoppingList ?? []
        }
        set {
            print("쇼핑리스트 저장")
            userDefaults.set(newValue, forKey: Key.shoppingList.rawValue)
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
}

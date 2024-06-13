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
            return userDefaults.string(forKey: Key.nickname.rawValue) ?? "OOO"
        }
        set {
            userDefaults.set(newValue, forKey: Key.nickname.rawValue)
        }
    }
    
    var profileImageIndex: Int {
        get {
            return userDefaults.integer(forKey: Key.profileImageIndex.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Key.profileImageIndex.rawValue)
        }
    }
    
    var signUpDate: Date {
        get {
            let storedDate = userDefaults.object(forKey: Key.signUpDate.rawValue) as? Date
            print(storedDate ?? "저장된 데이트 없음")
            return storedDate ?? Date()
        }
        set {
            userDefaults.set(newValue, forKey: Key.signUpDate.rawValue)
        }
    }
    
    var shoppingList: [Int] {
        get {
            let storedShoppingList = userDefaults.object(forKey: Key.shoppingList.rawValue) as? [Int]
            print(storedShoppingList ?? "저장된 쇼핑리스트 없음")
            return storedShoppingList ?? []
        }
        set {
            userDefaults.set(newValue, forKey: Key.shoppingList.rawValue)
        }
    }
    
    var profileImage: UIImage {
        return MyImage.profileImageList[profileImageIndex]
    }
    
    var signUpDateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy. MM. dd"
        let str = formatter.string(from: signUpDate)
        return "\(str) 가입"
    }
}

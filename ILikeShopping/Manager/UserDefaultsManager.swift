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
        Key.allCases.forEach {
            ud.removeObject(forKey: $0.rawValue)
        }
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
            return ud.string(forKey: Key.nickname.rawValue) ?? ""
        }
        set {
            ud.set(newValue, forKey: Key.nickname.rawValue)
        }
    }
    
    var profileImageIndex: Int {
        get {
            return ud.integer(forKey: Key.profileImageIndex.rawValue)
        }
        set {
            ud.set(newValue, forKey: Key.profileImageIndex.rawValue)
        }
    }
    
    var signUpDate: Date? {
        get {
            let storedDate = ud.object(forKey: Key.signUpDate.rawValue) as? Date
            return storedDate
        }
        set {
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
            return storedSearchWordList ?? []
        }
        set {
            ud.set(newValue.uniqued(), forKey: Key.searchWordList.rawValue)
        }
    }
    
    // productId 저장하여 관리
    var starList: [String] {
        get {
            let storedStarList = ud.object(forKey: Key.starList.rawValue) as? [String]
            return storedStarList ?? []
        }
        set {
            ud.set(newValue.uniqued(), forKey: Key.starList.rawValue)
        }
    }
    
}

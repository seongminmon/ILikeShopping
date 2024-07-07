//
//  UserDefaultsManager.swift
//  ILikeShopping
//
//  Created by 김성민 on 6/13/24.
//

import UIKit

final class UserDefaultsManager {
    
    private init() {}
    static let shared = UserDefaultsManager()
    
    let ud = UserDefaults.standard
    
    // UserDefaults 전체 삭제
    func removeAll() {
        ud.dictionaryRepresentation().keys.forEach {
            ud.removeObject(forKey: $0)
        }
    }
    
    enum Key: String, CaseIterable {
        case nickname
        case profileImageIndex
        case signUpDate
        
        case searchWordList
        case starIdList
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
    var starIdList: [String] {
        get {
            let storedStarIdList = ud.object(forKey: Key.starIdList.rawValue) as? [String]
            return storedStarIdList ?? []
        }
        set {
            ud.set(newValue.uniqued(), forKey: Key.starIdList.rawValue)
        }
    }
}

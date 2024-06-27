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
    
    // UserDefaults 전체 삭제
    func removeAll() {
        Key.allCases.forEach {
            ud.removeObject(forKey: $0.rawValue)
        }
        
        // (다른 방법)
//        ud.dictionaryRepresentation().keys.forEach {
//            ud.removeObject(forKey: $0)
//        }
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
    
    // TODO: - 적절한 위치로 옮기기
    
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
    var starIdList: [String] {
        get {
            let storedStarIdList = ud.object(forKey: Key.starIdList.rawValue) as? [String]
            return storedStarIdList ?? []
        }
        set {
            ud.set(newValue.uniqued(), forKey: Key.starIdList.rawValue)
        }
    }
    
    var starList: [Shopping] {
        get {
            guard let data = ud.object(forKey: Key.starList.rawValue) as? Data,
                  let value = try? JSONDecoder().decode([Shopping].self, from: data) else {
                return []
            }
            return value
        }
        set {
            let data = try? JSONEncoder().encode(newValue)
            ud.set(data, forKey: Key.starList.rawValue)
        }
    }
    
}

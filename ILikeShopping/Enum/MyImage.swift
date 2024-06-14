//
//  MyImage.swift
//  ILikeShopping
//
//  Created by 김성민 on 6/13/24.
//

import UIKit

enum MyImage {

    static let profileImageList: [UIImage] = [
        UIImage(named: "profile_0")!,
        UIImage(named: "profile_1")!,
        UIImage(named: "profile_2")!,
        UIImage(named: "profile_3")!,
        UIImage(named: "profile_4")!,
        UIImage(named: "profile_5")!,
        UIImage(named: "profile_6")!,
        UIImage(named: "profile_7")!,
        UIImage(named: "profile_8")!,
        UIImage(named: "profile_9")!,
        UIImage(named: "profile_10")!,
        UIImage(named: "profile_11")!,
    ]
    
//    static let profileImageNameList: [String] = [
//        "profile_0",
//        "profile_1",
//        "profile_2",
//        "profile_3",
//        "profile_4",
//        "profile_5",
//        "profile_6",
//        "profile_7",
//        "profile_8",
//        "profile_9",
//        "profile_10",
//        "profile_11",
//    ]
    
//    static var profileImageList: [UIImage] {
//        return MyImage.profileImageNameList.map { UIImage(named: $0)! }
//    }
    
    static let magnifyingglass = UIImage(systemName: "magnifyingglass")!
    static let person = UIImage(systemName: "person")!
    static let right = UIImage(systemName: "chevron.right")!
    static let clock = UIImage(systemName: "clock")!
    static let xmark = UIImage(systemName: "xmark")!
    static let camera = UIImage(systemName: "camera.fill")!
}

//
//  MyImage.swift
//  ILikeShopping
//
//  Created by 김성민 on 6/13/24.
//

import UIKit

enum MyImage {
    static let profileImageList: [UIImage] = [
        
        UIImage.bindingImage("profile_0"),
        UIImage(named: "profile_1") ?? UIImage(),
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
    
    static let launch = UIImage(named: "launch")
    static let empty = UIImage(named: "empty")
    static let unselected = UIImage(named: "like_unselected")!.withRenderingMode(.alwaysOriginal)
    static let selected = UIImage(named: "like_selected")!.withRenderingMode(.alwaysOriginal)
    
    static let magnifyingglass = UIImage(systemName: "magnifyingglass")!
    static let person = UIImage(systemName: "person")!
    static let right = UIImage(systemName: "chevron.right")!
    static let clock = UIImage(systemName: "clock")!
    static let xmark = UIImage(systemName: "xmark")!
    static let camera = UIImage(systemName: "camera.fill")!
}

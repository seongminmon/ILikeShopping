//
//  BaseTabBarController.swift
//  ILikeShopping
//
//  Created by 김성민 on 6/14/24.
//

import UIKit

class BaseTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.tintColor = MyColor.orange
        tabBar.unselectedItemTintColor = MyColor.gray
        
        let main = MainViewController()
        let nav1 = BaseNavigationController(rootViewController: main)
        nav1.tabBarItem = UITabBarItem(title: "검색", image: MyImage.magnifyingglass, tag: 0)
        
        let star = StarViewConroller()
        let nav2 = BaseNavigationController(rootViewController: star)
        nav2.tabBarItem = UITabBarItem(title: "장바구니", image: MyImage.unselected, tag: 1)
        
        let setting = SettingViewController()
        let nav3 = BaseNavigationController(rootViewController: setting)
        nav3.tabBarItem = UITabBarItem(title: "설정", image: MyImage.person, tag: 2)
        
        setViewControllers([nav1, nav2, nav3], animated: true)
    }
}

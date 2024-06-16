//
//  TabBarController.swift
//  ILikeShopping
//
//  Created by 김성민 on 6/14/24.
//

import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.tintColor = MyColor.orange
        tabBar.unselectedItemTintColor = MyColor.gray
        
        let main = MainViewController()
        let nav1 = BaseNavigationController(rootViewController: main)
        nav1.tabBarItem = UITabBarItem(title: "검색", image: MyImage.magnifyingglass, tag: 0)
        
        let setting = SettingViewController()
        let nav2 = BaseNavigationController(rootViewController: setting)
        nav2.tabBarItem = UITabBarItem(title: "설정", image: MyImage.person, tag: 1)
        
        setViewControllers([nav1, nav2], animated: true)
    }
    
}

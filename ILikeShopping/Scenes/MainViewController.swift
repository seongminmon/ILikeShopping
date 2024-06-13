//
//  MainViewController.swift
//  ILikeShopping
//
//  Created by 김성민 on 6/13/24.
//

import UIKit

class MainViewController: UIViewController {

    let ud = UserDefaultsManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureHierarchy()
        configureLayout()
        configureUI()
    }
    
    func configureNavigationBar() {
        navigationItem.title = "\(ud.nickname)'s Shopping List"
    }
    
    func configureHierarchy() {
        
    }
    
    func configureLayout() {
        
    }
    
    func configureUI() {
        
    }

}

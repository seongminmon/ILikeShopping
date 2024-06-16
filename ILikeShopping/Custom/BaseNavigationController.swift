//
//  BaseNavigationController.swift
//  ILikeShopping
//
//  Created by 김성민 on 6/16/24.
//

import UIKit

class BaseNavigationController: UINavigationController {
    // MARK: -
    // 1. tintColor 설정
    // 2. backButtonDisplayMode = .minimal로 설정하기
    // 3. 특정 ViewControllers에서 pop 제스처 막기
    
    private var duringTransition = false
    private var disabledPopViewControllers = [DetailViewController.self]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.tintColor = MyColor.black
        interactivePopGestureRecognizer?.delegate = self
        delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationBar.topItem?.backButtonDisplayMode = .minimal
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        duringTransition = true
        super.pushViewController(viewController, animated: animated)
    }
}

extension BaseNavigationController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        duringTransition = false
    }
}

extension BaseNavigationController: UIGestureRecognizerDelegate {
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard gestureRecognizer == interactivePopGestureRecognizer,
              let topVC = topViewController else {
            return true
        }
        return viewControllers.count > 1 && duringTransition == false && isPopGestureEnable(topVC)
    }
    
    private func isPopGestureEnable(_ topVC: UIViewController) -> Bool {
        for vc in disabledPopViewControllers {
            if String(describing: type(of: topVC)) == String(describing: vc) {
                return false
            }
        }
        return true
    }
}

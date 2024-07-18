//
//  BaseViewController.swift
//  ILikeShopping
//
//  Created by 김성민 on 6/21/24.
//

import UIKit

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backButtonDisplayMode = .minimal
        view.backgroundColor = MyColor.white
        configureNavigationBar()
        addSubviews()
        configureLayout()
        configureView()
    }
    
    func configureNavigationBar() {}
    func addSubviews() {}
    func configureLayout() {}
    func configureView() {}
    
    func showAlert(
        title: String,
        message: String,
        actionTitle: String,
        completionHandler: @escaping (UIAlertAction) -> Void
    ) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        let confirm = UIAlertAction(title: actionTitle, style: .default, handler: completionHandler)
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(confirm)
        alert.addAction(cancel)
        present(alert, animated: true)
    }
    
    // 확인 버튼만 있는 alert
    func showSimpleAlert(
        title: String,
        completionHandler: @escaping (UIAlertAction) -> Void
    ) {
        let alert = UIAlertController(
            title: title,
            message: nil,
            preferredStyle: .alert
        )
        let confirm = UIAlertAction(title: "확인", style: .default, handler: completionHandler)
        alert.addAction(confirm)
        present(alert, animated: true)
    }
    
    func navigate(vc: UIViewController) {
        navigationController?.pushViewController(vc, animated: true)
    }
}

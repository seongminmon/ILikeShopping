//
//  BaseViewController.swift
//  ILikeShopping
//
//  Created by 김성민 on 6/21/24.
//

import UIKit

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        navigationItem.backButtonDisplayMode = .minimal
    }
    
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
    
}

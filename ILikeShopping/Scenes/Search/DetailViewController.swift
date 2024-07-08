//
//  DetailViewController.swift
//  ILikeShopping
//
//  Created by 김성민 on 6/14/24.
//

import UIKit
import WebKit
import SnapKit

final class DetailViewController: BaseViewController {
    
    let webView = WKWebView()
    let indicator = UIActivityIndicatorView()
    
    let ud = UserDefaultsManager.shared
    var data: Shopping?
    let repository = RealmRepository()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureNavigationBar() {
        guard let data else { return }
        navigationItem.title = data.encodedString
        let buttonImage = repository.isBasket(data.productId) ? MyImage.selected : MyImage.unselected
        let likeButton = UIBarButtonItem(image: buttonImage, style: .plain, target: self, action: #selector(likeButtonTapped))
        navigationItem.rightBarButtonItem = likeButton
    }
    
    @objc func likeButtonTapped(sender: UIBarButtonItem) {
        // 좋아요 토글
        guard let data else { return }
        
        if repository.isBasket(data.productId) {
            // Realm 삭제
            repository.deleteItem(data.productId)
            // 뷰 업데이트
            sender.image = MyImage.unselected
        } else {
            // Realm에 추가
            let item = Basket(image: data.image, mallName: data.mallName, title: data.title, lprice: data.lprice, link: data.link, productId: data.productId)
            repository.addItem(item)
            // 뷰 업데이트
            sender.image = MyImage.selected
        }
    }
    
    override func addSubviews() {
        view.addSubview(webView)
        view.addSubview(indicator)
    }
    
    override func configureLayout() {
        webView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        indicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(40)
        }
    }
    
    override func configureView() {
        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        
        if let url = data?.linkUrl {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
}

extension DetailViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        indicator.isHidden = false
        indicator.startAnimating()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        indicator.stopAnimating()
        indicator.isHidden = true
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: any Error) {
        indicator.stopAnimating()
        indicator.isHidden = true
        showAlert(title: "에러", message: error.localizedDescription, actionTitle: "확인") { _ in
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: any Error) {
        showAlert(title: "에러", message: error.localizedDescription, actionTitle: "확인") { _ in 
            self.navigationController?.popViewController(animated: true)
        }
    }
}

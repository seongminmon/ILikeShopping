//
//  DetailViewController.swift
//  ILikeShopping
//
//  Created by 김성민 on 6/14/24.
//

import UIKit
import WebKit
import SnapKit

class DetailViewController: BaseViewController {
    
    let webView = WKWebView()
    let indicator = UIActivityIndicatorView()
    
    let ud = UserDefaultsManager.shared
    var data: Shopping?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureHierarchy()
        configureLayout()
        configureUI()
    }
    
    func configureNavigationBar() {
        guard let data else { return }
        navigationItem.title = data.encodedString
        let buttonImage = ud.starList.contains(data.productId) ? MyImage.selected : MyImage.unselected
        let likeButton = UIBarButtonItem(image: buttonImage, style: .plain, target: self, action: #selector(likeButtonTapped))
        navigationItem.rightBarButtonItem = likeButton
    }
    
    @objc func likeButtonTapped(sender: UIBarButtonItem) {
        // 좋아요 토글
        guard let data else { return }
        if let index = ud.starList.firstIndex(of: data.productId) {
            ud.starList.remove(at: index)
            sender.image = MyImage.unselected
        } else {
            ud.starList.append(data.productId)
            sender.image = MyImage.selected
        }
    }
    
    func configureHierarchy() {
        view.addSubview(webView)
        view.addSubview(indicator)
    }
    
    func configureLayout() {
        webView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        indicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(40)
        }
    }
    
    func configureUI() {
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
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: any Error) {
        let alert = UIAlertController(
            title: "에러",
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        let cancel = UIAlertAction(title: "확인", style: .cancel) { _ in
            self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(cancel)
        present(alert, animated: true)
    }
}

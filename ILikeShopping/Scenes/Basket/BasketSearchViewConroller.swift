//
//  BasketSearchViewConroller.swift
//  ILikeShopping
//
//  Created by 김성민 on 7/8/24.
//

import UIKit
import Kingfisher
import SnapKit

final class BasketSearchViewConroller: BaseViewController {
    
    let tableView = UITableView()
    
    override func configureNavigationBar() {
        navigationItem.title = "장바구니 검색"
        
        // searchController 설정
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "상품을 검색해보세요."
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    override func addSubviews() {
        view.addSubview(tableView)
    }
    
    override func configureLayout() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func configureView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 50
        tableView.register(BasketSearchTableViewCell.self, forCellReuseIdentifier: BasketSearchTableViewCell.identifier)
    }
}

extension BasketSearchViewConroller: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: BasketSearchTableViewCell.identifier,
            for: indexPath
        ) as? BasketSearchTableViewCell else {
            return UITableViewCell()
        }
        
        
        return cell
    }
}

extension BasketSearchViewConroller: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        print(#function, searchController.searchBar.text)
        
        if let text = searchController.searchBar.text, !text.isEmpty {
            //
        } else {
            //
        }
        tableView.reloadData()
    }
}

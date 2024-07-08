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
    
    let repository = RealmRepository()
    var searchedList: [Basket] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 초기값은 전체 장바구니
        searchedList = repository.fetchAll()
    }
    
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
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(BasketSearchTableViewCell.self, forCellReuseIdentifier: BasketSearchTableViewCell.identifier)
    }
}

extension BasketSearchViewConroller: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchedList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: BasketSearchTableViewCell.identifier,
            for: indexPath
        ) as? BasketSearchTableViewCell else {
            return UITableViewCell()
        }
        
        let data = searchedList[indexPath.row]
        cell.configureCell(data)
        return cell
    }
    
    // 스와이프로 삭제하기
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let item = searchedList[indexPath.row]
            // searchedList 삭제
            searchedList.remove(at: indexPath.row)
            // realm에서 삭제 (자식)
            repository.deleteItem(item.productId)
            // 뷰 업데이트
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

extension BasketSearchViewConroller: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        print(#function, searchController.searchBar.text!)
        
        if let text = searchController.searchBar.text, !text.isEmpty {
            // 검색어가 있으면 검색
            searchedList = repository.fetchSearched(text)
        } else {
            // 검색어가 없으면 전체 불러오기
            searchedList = repository.fetchAll()
        }
        tableView.reloadData()
    }
}

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
    
    let viewModel = BasketSearchViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindData()
    }
    
    func bindData() {
        viewModel.outputUpdateSearchResults.bind {
            [weak self] value in
            guard let self, value != nil else { return }
            tableView.reloadData()
        }
        
        viewModel.outputSwipeToDelete.bind {
            [weak self] value in
            guard let self, let value else { return }
            tableView.deleteRows(at: [value], with: .fade)
        }
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
        return viewModel.list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: BasketSearchTableViewCell.identifier,
            for: indexPath
        ) as? BasketSearchTableViewCell else {
            return UITableViewCell()
        }
        let data = viewModel.list[indexPath.row]
        cell.configureCell(data)
        return cell
    }
    
    // 스와이프로 삭제하기
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.inputSwipeToDelete.value = indexPath
        }
    }
}

extension BasketSearchViewConroller: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        print(#function, searchController.searchBar.text!)
        viewModel.inputUpdateSearchResults.value = searchController.searchBar.text
    }
}

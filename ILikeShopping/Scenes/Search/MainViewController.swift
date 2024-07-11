//
//  MainViewController.swift
//  ILikeShopping
//
//  Created by 김성민 on 6/13/24.
//

import UIKit
import SnapKit

final class MainViewController: BaseViewController {
    
    let searchBar = UISearchBar()
    
    let emptyImageView = UIImageView()
    let emptyLabel = UILabel()
    
    let recentLabel = UILabel()
    let deleteAllButton = UIButton()
    let tableView = UITableView()
    
    let viewModel = MainViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        bindData()
    }
    
    func bindData() {
        viewModel.outputList.bind { _ in
            self.tableView.reloadData()
            self.toggleHideView()
        }
    }
    
    override func configureNavigationBar() {
        navigationItem.title = viewModel.naviTitle
    }
    
    override func addSubviews() {
        view.addSubview(searchBar)
        
        view.addSubview(emptyImageView)
        view.addSubview(emptyLabel)
        
        view.addSubview(recentLabel)
        view.addSubview(deleteAllButton)
        view.addSubview(tableView)
    }
    
    override func configureLayout() {
        searchBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(60)
        }
        
        emptyImageView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(emptyImageView.snp.width)
        }
        
        emptyLabel.snp.makeConstraints { make in
            make.top.equalTo(emptyImageView.snp.bottom)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(30)
        }
        
        recentLabel.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(8)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.trailing.equalTo(deleteAllButton.snp.leading)
            make.height.equalTo(30)
        }
        
        deleteAllButton.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(8)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.width.equalTo(80)
            make.height.equalTo(30)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(recentLabel.snp.bottom).offset(8)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func configureView() {
        searchBar.placeholder = "브랜드, 상품 등을 입력하세요."
        searchBar.delegate = self
        
        emptyImageView.image = MyImage.empty
        emptyImageView.contentMode = .scaleAspectFit
        
        emptyLabel.text = "최근 검색어가 없어요"
        emptyLabel.font = MyFont.bold16
        emptyLabel.textColor = MyColor.black
        emptyLabel.textAlignment = .center
        
        recentLabel.text = "최근 검색"
        recentLabel.font = MyFont.bold15
        
        deleteAllButton.setTitle("전체 삭제", for: .normal)
        deleteAllButton.titleLabel?.font = MyFont.regular14
        deleteAllButton.setTitleColor(MyColor.orange, for: .normal)
        deleteAllButton.addTarget(self, action: #selector(deleteAllButtonTapped), for: .touchUpInside)
    }
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 44
        tableView.register(SearchWordTableViewCell.self, forCellReuseIdentifier: SearchWordTableViewCell.identifier)
    }
    
    func toggleHideView() {
        if viewModel.outputList.value.isEmpty {
            emptyImageView.isHidden = false
            emptyLabel.isHidden = false
            recentLabel.isHidden = true
            deleteAllButton.isHidden = true
            tableView.isHidden = true
        } else {
            emptyImageView.isHidden = true
            emptyLabel.isHidden = true
            recentLabel.isHidden = false
            deleteAllButton.isHidden = false
            tableView.isHidden = false
        }
    }
    
    @objc func deleteAllButtonTapped() {
        viewModel.inputDeleteAllButtonTapped.value = ()
    }
    
    func search(_ query: String) {
        // 검색 화면으로 이동, 데이터 전달
        let vm = SearchViewModel()
        vm.query = query
        let vc = SearchViewController()
        vc.viewModel = vm
        navigate(vc: vc)
    }
    
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.outputList.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: SearchWordTableViewCell.identifier,
            for: indexPath
        ) as? SearchWordTableViewCell else {
            return UITableViewCell()
        }
        let data = viewModel.outputList.value[indexPath.row]
        cell.configureCell(text: data)
        cell.deleteButton.tag = indexPath.row
        cell.deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        return cell
    }
    
    @objc func deleteButtonTapped(sender: UIButton) {
        viewModel.inputDeleteButtonTapped.value = sender.tag
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        search(viewModel.outputList.value[indexPath.row])
        viewModel.inputCellSelected.value = indexPath.row
    }
}

extension MainViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewModel.inputSearchButtonClicked.value = searchBar.text
        search(searchBar.text ?? "")
    }
}

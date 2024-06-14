//
//  MainViewController.swift
//  ILikeShopping
//
//  Created by 김성민 on 6/13/24.
//

import UIKit
import Alamofire
import Kingfisher
import SnapKit

class MainViewController: UIViewController {
    
    let searchBar = UISearchBar()
    // 최근 검색어 없는 경우
    let emptyImageView = UIImageView()
    let emptyLabel = UILabel()
    // 최근 검색어 있는 경우
    let tableView = UITableView()
    
    let ud = UserDefaultsManager.shared
    var isEmpty: Bool = false
    
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
        view.addSubview(searchBar)
        if isEmpty {
            view.addSubview(emptyImageView)
            view.addSubview(emptyLabel)
        } else {
            view.addSubview(tableView)
        }
    }
    
    func configureLayout() {
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(8)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(44)
        }
        
        if isEmpty {
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
        } else {
            tableView.snp.makeConstraints { make in
                make.top.equalTo(searchBar.snp.bottom).offset(8)
                make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
            }
        }
    }
    
    func configureUI() {
        searchBar.placeholder = "브랜드, 상품 등을 입력하세요."
        
        if isEmpty {
            emptyImageView.image = UIImage(named: "empty")
            emptyImageView.contentMode = .scaleAspectFit
            
            emptyLabel.text = "최근 검색어가 없어요"
            emptyLabel.font = Font.bold16
            emptyLabel.textColor = MyColor.black
            emptyLabel.textAlignment = .center
        } else {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.rowHeight = 44
            tableView.register(SearchWordTableViewCell.self, forCellReuseIdentifier: SearchWordTableViewCell.identifier)
        }
    }
    
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchWordTableViewCell.identifier, for: indexPath) as! SearchWordTableViewCell
        cell.backgroundColor = .brown
        return cell
    }
}

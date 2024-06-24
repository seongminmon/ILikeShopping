//
//  SearchViewController.swift
//  ILikeShopping
//
//  Created by 김성민 on 6/14/24.
//

import UIKit
import SnapKit

enum SortOption: String, CaseIterable {
    case sim
    case date
    case dsc
    case asc
    
    var buttonTitle: String {
        switch self {
        case .sim: "정확도"
        case .date: "날짜순"
        case .dsc: "가격높은순"
        case .asc: "가격낮은순"
        }
    }
}

class SearchViewController: BaseViewController {

    let totalCountLabel = UILabel()
    let simButton = SortButton(option: .sim)
    let dateButton = SortButton(option: .date)
    let dscButton = SortButton(option: .dsc)
    let ascButton = SortButton(option: .asc)
    lazy var buttons = [simButton, dateButton, dscButton, ascButton]
    lazy var buttonStackView = UIStackView(arrangedSubviews: [simButton, dateButton, dscButton, ascButton, UIView()])
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
    
    let ud = UserDefaultsManager.shared
    let networkManager = NetworkManager.shared
    
    var query: String?  // 이전 화면에서 전달
    var shoppingData: ShoppingResponse? // 네트워크
    
    var start = 1       // 페이지네이션 위한 변수
    var sortOption: SortOption = .sim
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        networkManager.callRequest(
            query: query ?? "",
            start: start,
            sortOption: sortOption
        ) { result in
            switch result {
            case .success(let value):
                self.setSuccessData(value: value)
            case .failure(let error):
                self.failureAction(message: error.localizedDescription)
            }
        }
        
        configureNavigationBar()
        configureHierarchy()
        configureLayout()
        configureUI()
        configureCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 좋아요 동기화
        collectionView.reloadData()
    }
    
    func configureNavigationBar() {
        navigationItem.title = query
    }
    
    func configureHierarchy() {
        view.addSubview(totalCountLabel)
        view.addSubview(buttonStackView)
        view.addSubview(collectionView)
    }
    
    func configureLayout() {
        totalCountLabel.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(30)
        }
        
        simButton.snp.makeConstraints { make in
            make.width.equalTo(60)
        }
        
        dateButton.snp.makeConstraints { make in
            make.width.equalTo(60)
        }
        
        dscButton.snp.makeConstraints { make in
            make.width.equalTo(80)
        }
        
        ascButton.snp.makeConstraints { make in
            make.width.equalTo(80)
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(totalCountLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(30)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(buttonStackView.snp.bottom).offset(16)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func collectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        
        let sectionSpacing: CGFloat = 10
        let cellSpacing: CGFloat = 10
        let cellCount: CGFloat = 2
        
        let width = UIScreen.main.bounds.width - 2 * sectionSpacing - (cellCount-1) * cellSpacing
        layout.itemSize = CGSize(width: width / cellCount, height: width / cellCount * 1.6)
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = cellSpacing
        layout.minimumLineSpacing = cellSpacing
        layout.sectionInset = UIEdgeInsets(top: sectionSpacing, left: sectionSpacing, bottom: sectionSpacing, right: sectionSpacing)
        
        return layout
    }
    
    func configureUI() {
        totalCountLabel.font = MyFont.bold15
        totalCountLabel.textColor = MyColor.orange
        
        buttonStackView.axis = .horizontal
        buttonStackView.distribution = .fill
        buttonStackView.alignment = .leading
        buttonStackView.spacing = 8
        
        for i in 0..<buttons.count {
            let button = buttons[i]
            button.tag = i
            let buttonOption = SortOption.allCases[button.tag]
            button.configureButton(isSelect: buttonOption == sortOption)
            button.addTarget(self, action: #selector(sortButtonTapped), for: .touchUpInside)
        }
    }
    
    @objc func sortButtonTapped(sender: UIButton) {
        // 1. 선택된 정렬 기준으로 재검색
        sortOption = SortOption.allCases[sender.tag]
        start = 1
        networkManager.callRequest(
            query: query ?? "",
            start: start,
            sortOption: sortOption
        ) { result in
            switch result {
            case .success(let value):
                self.setSuccessData(value: value)
            case .failure(let error):
                self.failureAction(message: error.localizedDescription)
            }
        }
        
        // 2. 선택된 버튼 UI 변경
        buttons.forEach { button in
            button.configureButton(isSelect: button == sender)
        }
    }
    
    func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.prefetchDataSource = self
        collectionView.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: SearchCollectionViewCell.identifier)
    }
    
    // MARK: - 네트워크 성공/실패 시 실행할 함수
    
    func setSuccessData(value: ShoppingResponse) {
        if start == 1 {
            // 첫 검색이라면 데이터 교체
            shoppingData = value
        } else {
            // 페이지네이션이라면 데이터 추가
            shoppingData?.items.append(contentsOf: value.items)
        }
        
        totalCountLabel.text = shoppingData?.totalCountText
        collectionView.reloadData()
        
        if start == 1 && value.total > 0 {
            // 첫 검색일 때 스크롤 맨 위로 올려주기 (reloadData 이후)
            collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
        }
    }
    
    func failureAction(message: String) {
        showAlert(title: "오류", message: message, actionTitle: "확인") { _ in
            self.navigationController?.popViewController(animated: true)
        }
    }
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shoppingData?.items.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCollectionViewCell.identifier, for: indexPath) as! SearchCollectionViewCell
        let data = shoppingData?.items[indexPath.item]
        cell.configureCell(data: data, query: query ?? "")
        cell.configureButton(isSelected: ud.starIdList.contains(data?.productId ?? ""))
                             
        cell.likeButton.tag = indexPath.item
        cell.likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        return cell
    }
    
    @objc func likeButtonTapped(sender: UIButton) {
        guard let shoppingData else { return }
        let id = shoppingData.items[sender.tag].productId
        let cell = collectionView.cellForItem(at: IndexPath(item: sender.tag, section: 0)) as! SearchCollectionViewCell
        
        let data = shoppingData.items[sender.tag]
        if let index = ud.starIdList.firstIndex(of: id) {
            ud.starIdList.remove(at: index)
            ud.starList.remove(at: index)
            cell.configureButton(isSelected: false)
        } else {
            ud.starIdList.append(id)
            ud.starList.append(data)
            cell.configureButton(isSelected: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = DetailViewController()
        let data = shoppingData?.items[indexPath.item]
        vc.data = data
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension SearchViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        // 페이지 네이션
        guard let shoppingData,
              let query else { return }
        
        indexPaths.forEach { indexPath in
            if indexPath.item == shoppingData.items.count - 8 &&
                shoppingData.items.count < shoppingData.total &&
                start <= 1000 {
                start += networkManager.display
                networkManager.callRequest(
                    query: query,
                    start: start,
                    sortOption: sortOption
                ) { result in
                    switch result {
                    case .success(let value):
                        self.setSuccessData(value: value)
                    case .failure(let error):
                        self.failureAction(message: error.localizedDescription)
                    }
                }
            }
        }
    }
    
}

//
//  SearchViewController.swift
//  ILikeShopping
//
//  Created by 김성민 on 6/14/24.
//

import UIKit
import Alamofire
import Kingfisher
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

class SearchViewController: UIViewController {

    let totalCountLabel = UILabel()
    let simButton = SortButton(option: .sim)
    let dateButton = SortButton(option: .date)
    let dscButton = SortButton(option: .dsc)
    let ascButton = SortButton(option: .asc)
    lazy var buttons = [simButton, dateButton, dscButton, ascButton]
    lazy var buttonStackView = UIStackView(arrangedSubviews: [simButton, dateButton, dscButton, ascButton, UIView()])
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
    
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
    
    let ud = UserDefaultsManager.shared
    
    var query: String?  // 이전 화면에서 전달
    var shoppingData: ShoppingResponse? // 네트워크
    
    let display = 30    // 30으로 고정
    var start = 1       // 페이지네이션 위한 변수
    var sortOption: SortOption = .sim
    
    override func viewDidLoad() {
        super.viewDidLoad()
        callRequest(query: query ?? "")
        
        configureNavigationBar()
        configureHierarchy()
        configureLayout()
        configureCollectionView()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 좋아요 동기화
        collectionView.reloadData()
    }
    
    func configureNavigationBar() {
        navigationItem.title = query
        navigationItem.backButtonDisplayMode = .minimal
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
    
    func configureUI() {
        totalCountLabel.font = MyFont.bold15
        totalCountLabel.textColor = MyColor.orange
        
        buttonStackView.axis = .horizontal
        buttonStackView.distribution = .fill
        buttonStackView.alignment = .leading
        buttonStackView.spacing = 8
        
        simButton.tag = 0
        dateButton.tag = 1
        dscButton.tag = 2
        ascButton.tag = 3
        
        buttons.forEach { button in
            let buttonOption = SortOption.allCases[button.tag]
            button.configureButton(isSelect: buttonOption == sortOption)
            button.addTarget(self, action: #selector(sortButtonTapped), for: .touchUpInside)
        }
    }
    
    @objc func sortButtonTapped(sender: UIButton) {
        // 1. 선택된 정렬 기준으로 재검색
        sortOption = SortOption.allCases[sender.tag]
        start = 1
        callRequest(query: query ?? "")
        
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
    
    func callRequest(query: String) {
        let url = APIURL.shoppingURL
        let param: Parameters = [
            "query" : query,
            "display" : display,
            "start" : start,
            "sort" : sortOption,
        ]
        let headers: HTTPHeaders = [
            "X-Naver-Client-Id" : APIKey.clientID,
            "X-Naver-Client-Secret" : APIKey.clientSecret,
        ]
        
        AF.request(
            url,
            method: .get,
            parameters: param,
            headers: headers
        ).responseDecodable(of: ShoppingResponse.self) { response in
            switch response.result {
            case .success(let value):
                print("SUCCESS")
                
                if self.start == 1 {
                    // 첫 검색이라면 데이터 교체
                    self.shoppingData = value
                } else {
                    // 페이지네이션이라면 데이터 추가
                    self.shoppingData?.items.append(contentsOf: value.items)
                }
                
                self.totalCountLabel.text = "\((self.shoppingData?.total ?? 0).formatted())개의 검색 결과"
                self.collectionView.reloadData()
                
                if self.start == 1 && value.total > 0 {
                    // 첫 검색일 때 스크롤 맨 위로 올려주기 (reloadData 이후)
                    self.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
                }
                
            case .failure(let error):
                print(error)
            }
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
        cell.configureCell(data: data, query: query ?? "", isSelected: ud.starList.contains(data?.productId ?? ""))
        cell.likeButton.tag = indexPath.item
        cell.likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        return cell
    }
    
    @objc func likeButtonTapped(sender: UIButton) {
        guard let shoppingData else { return }
        let id = shoppingData.items[sender.tag].productId
        
        if let index = ud.starList.firstIndex(of: id) {
            ud.starList.remove(at: index)
            
            sender.setImage(MyImage.unselected, for: .normal)
            sender.backgroundColor = MyColor.black
            sender.layer.opacity = 0.5
        } else {
            ud.starList.append(id)
            
            sender.setImage(MyImage.selected, for: .normal)
            sender.backgroundColor = MyColor.white
            sender.layer.opacity = 1
        }
//        collectionView.reloadItems(at: [IndexPath(item: sender.tag, section: 0)])
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
                start += display
                callRequest(query: query)
            }
        }
    }
}

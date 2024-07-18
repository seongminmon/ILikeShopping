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

/*
// TODO: -
- 빈 값 입력 시 알림창 팝업 - 검색 화면으로 돌아가는 확인 버튼만 남기기
*/

final class SearchViewController: BaseViewController {
    
    let totalCountLabel = UILabel()
    let simButton = SortButton(option: .sim)
    let dateButton = SortButton(option: .date)
    let dscButton = SortButton(option: .dsc)
    let ascButton = SortButton(option: .asc)
    lazy var buttons = [simButton, dateButton, dscButton, ascButton]
    lazy var buttonStackView = UIStackView(arrangedSubviews: [simButton, dateButton, dscButton, ascButton, UIView()])
    
    let collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: CollectionViewDesign.collectionViewLayout(
            sectionSpacing: 10,
            cellSpacing: 10,
            cellCount: 2,
            aspectRatio: 1.6
        )
    )
    
    var viewModel: SearchViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        bindData()
    }
    
    // TODO: - 웹뷰에서 좋아요 누른 경우 뷰 업데이트 -> 좋아요 누른 것만 리로드하도록 개선하기
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
    
    func bindData() {
        viewModel.inputNetworkTrigger.value = ()
        
        viewModel.outputList.bind { [weak self] value in
            guard let self else { return }
            totalCountLabel.text = value?.totalCountText
            collectionView.reloadData()
        }
        
        viewModel.outputScrollToTop.bind { [weak self] value in
            guard let self, value != nil else { return }
            collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
        }
        
        viewModel.outputFailureAlert.bind { [weak self] message in
            guard let self else { return }
            guard let message else { return }
            showAlert(title: "오류", message: message, actionTitle: "확인") { _ in
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    override func configureNavigationBar() {
        navigationItem.title = viewModel.query
    }
    
    override func addSubviews() {
        view.addSubview(totalCountLabel)
        view.addSubview(buttonStackView)
        view.addSubview(collectionView)
    }
    
    override func configureLayout() {
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
    
    override func configureView() {
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
            button.configureButton(isSelect: buttonOption == viewModel.sortOption)
            button.addTarget(self, action: #selector(sortButtonTapped), for: .touchUpInside)
        }
    }
    
    @objc func sortButtonTapped(sender: UIButton) {
        // 이미 선택된 버튼을 누르면 패스
        if sender.backgroundColor == MyColor.darkgray { return }
        
        // 1. 선택된 정렬 기준으로 재검색
        viewModel.sortOption = SortOption.allCases[sender.tag]
        // 네트워크 요청
        viewModel.inputNetworkTrigger.value = ()
        
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
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.outputList.value?.items.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: SearchCollectionViewCell.identifier,
            for: indexPath
        ) as? SearchCollectionViewCell,
              let data = viewModel.outputList.value?.items[indexPath.item] else {
            return UICollectionViewCell()
        }
        
        cell.configureCell(data: data, query: viewModel.query ?? "")
        
        viewModel.inputCellForItemAt.value = data.productId
        cell.configureButton(isSelected: viewModel.outputIsBasket.value ?? false)
        
        cell.likeButton.tag = indexPath.item
        cell.likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        return cell
    }
    
    // 좋아요 토글
    @objc func likeButtonTapped(sender: UIButton) {
        guard let data = viewModel.outputList.value?.items[sender.tag] else { return }
        let cell = collectionView.cellForItem(at: IndexPath(item: sender.tag, section: 0)) as! SearchCollectionViewCell
        
        viewModel.inputCellLikeButtonClicked.value = data
        cell.configureButton(isSelected: viewModel.outputIsBasket.value ?? false)
    }
    
    // 웹뷰로 이동
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = DetailViewController()
        let data = viewModel.outputList.value?.items[indexPath.item]
        vc.data = data
        navigate(vc: vc)
    }
}

extension SearchViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        // 페이지 네이션
        indexPaths.forEach { indexPath in
            viewModel.inputPagenationTrigger.value = indexPath.item
        }
    }
}

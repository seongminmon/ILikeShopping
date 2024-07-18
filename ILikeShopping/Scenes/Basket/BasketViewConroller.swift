//
//  BasketViewConroller.swift
//  ILikeShopping
//
//  Created by 김성민 on 6/23/24.
//

import UIKit
import Kingfisher
import SnapKit

final class BasketViewConroller: BaseViewController {
    
    let button0 = OrangeButton(title: FolderOption.total.title)
    let button1 = OrangeButton(title: FolderOption.row.title)
    let button2 = OrangeButton(title: FolderOption.medium.title)
    let button3 = OrangeButton(title: FolderOption.high.title)
    lazy var buttons = [button0, button1, button2, button3]
    lazy var buttonStackView = UIStackView(arrangedSubviews: buttons)
    
    let totalCountLabel = UILabel()
    let collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: CollectionViewDesign.collectionViewLayout(
            sectionSpacing: 10,
            cellSpacing: 10,
            cellCount: 2,
            aspectRatio: 1.6
        )
    )
    
    let viewModel = BasketViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // MARK: - 순서 중요! bindData() 먼저 하면 에러!
        configureCollectionView()
        bindData()
    }
    
    func bindData() {
        viewModel.outputCountLabelText.bind { [weak self] value in
            guard let self else { return }
            totalCountLabel.text = value
        }
        
        viewModel.outputList.bind { [weak self] list in
            guard let self else { return }
            collectionView.reloadData()
            if !list.isEmpty {
                collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.inputViewWillAppearTrigger.value = ()
    }
    
    override func configureNavigationBar() {
        navigationItem.title = viewModel.naviTitle
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: MyImage.magnifyingglass,
            style: .plain,
            target: self,
            action: #selector(searchButtonTapped)
        )
    }
    
    @objc func searchButtonTapped() {
        let vc = BasketSearchViewConroller()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func addSubviews() {
        view.addSubview(buttonStackView)
        view.addSubview(totalCountLabel)
        view.addSubview(collectionView)
    }
    
    override func configureLayout() {
        buttonStackView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(40)
        }
        
        totalCountLabel.snp.makeConstraints { make in
            make.top.equalTo(buttonStackView.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(30)
        }

        collectionView.snp.makeConstraints { make in
            make.top.equalTo(totalCountLabel.snp.bottom).offset(16)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func configureView() {
        for i in 0..<buttons.count {
            buttons[i].tag = i
            buttons[i].addTarget(self, action: #selector(priceButtonTapped), for: .touchUpInside)
            buttons[i].backgroundColor = MyColor.lightgray
        }
        button0.backgroundColor = MyColor.orange
        
        buttonStackView.axis = .horizontal
        buttonStackView.alignment = .fill
        buttonStackView.distribution = .fillProportionally
        buttonStackView.spacing = 8
        
        totalCountLabel.font = MyFont.bold15
        totalCountLabel.textColor = MyColor.orange
    }

    func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: SearchCollectionViewCell.identifier)
    }
    
    @objc func priceButtonTapped(sender: UIButton) {
        // 이미 선택된 버튼을 누르면 패스
        if sender.backgroundColor == MyColor.orange { return }
        
        viewModel.inputFolderButtonTapped.value = sender.tag
        
        // 선택된 버튼 UI 변경
        buttons.forEach { button in
            if button == sender {
                button.backgroundColor = MyColor.orange
            } else {
                button.backgroundColor = MyColor.lightgray
            }
        }
    }
    
}

extension BasketViewConroller: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.outputList.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: SearchCollectionViewCell.identifier,
            for: indexPath
        ) as? SearchCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let data = viewModel.outputList.value[indexPath.item]
        cell.configureCell(data: data)
        cell.configureButton(isSelected: true)
        
        cell.likeButton.tag = indexPath.item
        cell.likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        return cell
    }
    
    @objc func likeButtonTapped(sender: UIButton) {
        viewModel.inputCellButtonTapped.value = sender.tag
        // 애니메이션 효과
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    // 웹뷰로 이동
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = DetailViewController()
        let item = viewModel.outputList.value[indexPath.item]
        let data = Shopping(image: item.image, mallName: item.mallName, title: item.title, lprice: item.lprice, link: item.link, productId: item.productId)
        vc.data = data
        navigate(vc: vc)
    }
}

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
    
    let button0 = OrangeButton(title: " 전체 ")
    let button1 = OrangeButton(title: "~ 10만원")
    let button2 = OrangeButton(title: "10 ~ 100만원")
    let button3 = OrangeButton(title: "100만원 ~")
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
    
    let ud = UserDefaultsManager.shared
    let repository = RealmRepository()
    var folder: Folder?
    var list: [Basket] = []
    var option = FolderOption.total
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(repository.fileURL!)
        
        folder = repository.filteredFolder(option)
        // 처음엔 전체 가져오기
        list = repository.fetchAll()
        configureCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let folder = folder {
            list = Array(folder.baskets)
        } else {
            list = repository.fetchAll()
        }
        totalCountLabel.text = "\(list.count.formatted())개의 쇼핑 리스트"
        collectionView.reloadData()
    }
    
    override func configureNavigationBar() {
        navigationItem.title = "\(ud.nickname)'s Shopping List"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: MyImage.magnifyingglass, style: .plain, target: self, action: #selector(searchButtonTapped))
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
        print(#function, sender.tag)
        
        // 이미 선택된 버튼을 누르면 패스
        if sender.backgroundColor == MyColor.orange { return }
        
        // 1. Folder에 따라 list 변경하기
        // list는 폴더에 담겨있는 baskets 중 하나이거나 전체 basket(folder = nil일 때)
        option = FolderOption.allCases[sender.tag]
        folder = repository.filteredFolder(option)
        if let folder = folder {
            list = Array(folder.baskets)
        } else {
            list = repository.fetchAll()
        }
        totalCountLabel.text = "\(list.count.formatted())개의 쇼핑 리스트"
        collectionView.reloadData()
        
        // 2. 선택된 버튼 UI 변경
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
        return list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: SearchCollectionViewCell.identifier,
            for: indexPath
        ) as? SearchCollectionViewCell else {
            return UICollectionViewCell()
        }
        let data = list[indexPath.item]
        cell.configureCell(data: data)
        cell.configureButton(isSelected: true)
        
        cell.likeButton.tag = indexPath.item
        cell.likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        return cell
    }
    
    @objc func likeButtonTapped(sender: UIButton) {
        // 장바구니 화면에서는 삭제만 가능
        let data = list[sender.tag]
        if let index = ud.starIdList.firstIndex(of: data.productId) {
            // ud 삭제
            ud.starIdList.remove(at: index)
            // list 삭제
            list.remove(at: sender.tag)
            // Realm 삭제
            repository.deleteItem(data.productId)
            // 뷰 업데이트
            totalCountLabel.text = "\(list.count.formatted())개의 쇼핑 리스트"
            collectionView.reloadData()
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    // 웹뷰로 이동
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = DetailViewController()
        let item = list[indexPath.item]
        let data = Shopping(image: item.image, mallName: item.mallName, title: item.title, lprice: item.lprice, link: item.link, productId: item.productId)
        vc.data = data
        navigate(vc: vc)
    }
}

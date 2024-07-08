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
    
    var list: [Basket] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        print(repository.fileURL!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        list = repository.fetchAll()
        totalCountLabel.text = "\(list.count.formatted())개의 쇼핑 리스트"
        collectionView.reloadData()
    }
    
    override func configureNavigationBar() {
        navigationItem.title = "\(ud.nickname)'s Shopping List"
    }
    
    override func addSubviews() {
        view.addSubview(totalCountLabel)
        view.addSubview(collectionView)
    }
    
    override func configureLayout() {
        totalCountLabel.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(30)
        }

        collectionView.snp.makeConstraints { make in
            make.top.equalTo(totalCountLabel.snp.bottom).offset(16)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func configureView() {
        totalCountLabel.font = MyFont.bold15
        totalCountLabel.textColor = MyColor.orange
    }

    func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: SearchCollectionViewCell.identifier)
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
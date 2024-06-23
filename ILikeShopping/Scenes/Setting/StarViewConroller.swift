//
//  StarViewConroller.swift
//  ILikeShopping
//
//  Created by 김성민 on 6/23/24.
//

import UIKit
import SnapKit

class StarViewConroller: BaseViewController {
    
    let totalCountLabel = UILabel()
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
    
    let ud = UserDefaultsManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureHierarchy()
        configureLayout()
        configureUI()
        configureCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        totalCountLabel.text = "\(ud.starList.count.formatted())개의 쇼핑 리스트"
        collectionView.reloadData()
    }
    
    func configureNavigationBar() {
        navigationItem.title = "\(ud.nickname)'s Shopping List"
    }
    
    func configureHierarchy() {
        view.addSubview(totalCountLabel)
        view.addSubview(collectionView)
    }
    
    func configureLayout() {
        totalCountLabel.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(30)
        }

        collectionView.snp.makeConstraints { make in
            make.top.equalTo(totalCountLabel.snp.bottom).offset(16)
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
    }

    func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: SearchCollectionViewCell.identifier)
    }
}

extension StarViewConroller: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ud.starList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCollectionViewCell.identifier, for: indexPath) as! SearchCollectionViewCell
        let data = ud.starList[indexPath.item]
        cell.configureCell(data: data, query: "")
//        cell.configureButton(isSelected: true)
        cell.likeButton.isHidden = true
        
//        cell.likeButton.tag = indexPath.item
//        cell.likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        return cell
    }
    
    // 선택한 셀 삭제
//    @objc func likeButtonTapped(sender: UIButton) {
//        let cell = collectionView.cellForItem(at: IndexPath(item: sender.tag, section: 0)) as! SearchCollectionViewCell
//        let data = ud.starList[sender.tag]
//        let id = data.productId
//        
//        if let index = ud.starIdList.firstIndex(of: id) {
//            ud.starIdList.remove(at: index)
//            ud.starList.remove(at: index)
//            cell.configureButton(isSelected: false)
//        }
//    }
    
    // 웹뷰로 이동
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = DetailViewController()
        let data = ud.starList[indexPath.item]
        vc.data = data
        navigationController?.pushViewController(vc, animated: true)
    }
}

//
//  SettingImageViewController.swift
//  ILikeShopping
//
//  Created by 김성민 on 6/13/24.
//

import UIKit

class SettingImageViewController: UIViewController {
    
    // TODO: - popview할때 인덱스 값 전달하기
    
    let selectedImageView = ProfileImageView(image: nil, isSelect: true)
    let cameraImageView = CameraImageView(frame: .zero)
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
    
    // 기본값은 설정
    var settingOption: SettingOption = .setting
    var selectedIndex: Int = 0
    
    func collectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        
        let sectionSpacing: CGFloat = 10
        let cellSpacing: CGFloat = 10
        let cellCount: CGFloat = 4
        
        // 셀 사이즈
        let width = UIScreen.main.bounds.width - 2 * sectionSpacing - (cellCount-1) * cellSpacing
        layout.itemSize = CGSize(width: width / cellCount, height: width / cellCount)
        // 스크롤 방향
        layout.scrollDirection = .vertical
        // 셀 사이 거리 (가로)
        layout.minimumInteritemSpacing = cellSpacing
        // 셀 사이 거리 (세로)
        layout.minimumLineSpacing = cellSpacing
        // 섹션 인셋
        layout.sectionInset = UIEdgeInsets(top: sectionSpacing, left: sectionSpacing, bottom: sectionSpacing, right: sectionSpacing)
        
        return layout
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureHierarchy()
        configureLayout()
        configureUI()
        configureCollectionView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // 닉네임 화면으로 돌아가기 직전에 데이터 전달
        print(#function)
        let popVc = navigationController?.viewControllers.last! as! SettingNicknameViewController
        popVc.imageIndex = selectedIndex
    }
    
    func configureNavigationBar() {
        navigationItem.title = settingOption.rawValue
    }
    
    func configureHierarchy() {
        view.addSubview(selectedImageView)
        view.addSubview(cameraImageView)
        view.addSubview(collectionView)
    }
    
    func configureLayout() {
        selectedImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.centerX.equalToSuperview()
            make.size.equalTo(150)
        }
        
        cameraImageView.snp.makeConstraints { make in
            make.trailing.bottom.equalTo(selectedImageView)
            make.size.equalTo(50)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(selectedImageView.snp.bottom).offset(40)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func configureUI() {
        selectedImageView.image = MyImage.profileImageList[selectedIndex]
    }
    
    func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ProfileImageCollectionViewCell.self, forCellWithReuseIdentifier: ProfileImageCollectionViewCell.identifier)
    }

}

extension SettingImageViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return MyImage.profileImageList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileImageCollectionViewCell.identifier, for: indexPath) as! ProfileImageCollectionViewCell
        cell.configureCell(index: indexPath.item, selectedIndex: selectedIndex)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.item
        configureUI()
        collectionView.reloadData()
    }
}

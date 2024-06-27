//
//  SettingImageViewController.swift
//  ILikeShopping
//
//  Created by 김성민 on 6/13/24.
//

import UIKit

class SettingImageViewController: BaseViewController {
    
    let selectedImageView = ProfileImageView(frame: .zero)
    let cameraImageView = CameraImageView(frame: .zero)
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
    
    var settingOption: SettingOption = .setting
    var selectedIndex: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // 이전 화면(닉네임 화면)에 데이터 전달
        // TODO: - 클로저, 델리게이트가 더 좋은지
        let popVc = navigationController?.viewControllers.last! as? SettingNicknameViewController
        popVc?.imageIndex = selectedIndex
    }
    
    override func configureNavigationBar() {
        navigationItem.title = settingOption.rawValue
    }
    
    override func addSubviews() {
        view.addSubview(selectedImageView)
        view.addSubview(cameraImageView)
        view.addSubview(collectionView)
    }
    
    override func configureLayout() {
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
    
    func collectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        
        let sectionSpacing: CGFloat = 10
        let cellSpacing: CGFloat = 10
        let cellCount: CGFloat = 4
        
        let width = UIScreen.main.bounds.width - 2 * sectionSpacing - (cellCount-1) * cellSpacing
        layout.itemSize = CGSize(width: width / cellCount, height: width / cellCount)
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = cellSpacing
        layout.minimumLineSpacing = cellSpacing
        layout.sectionInset = UIEdgeInsets(top: sectionSpacing, left: sectionSpacing, bottom: sectionSpacing, right: sectionSpacing)
        
        return layout
    }
    
    override func configureView() {
        selectedImageView.configureImageView(image: MyImage.profileImageList[selectedIndex], isSelect: true)
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
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileImageCollectionViewCell.identifier, for: indexPath) as? ProfileImageCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configureCell(index: indexPath.item, selectedIndex: selectedIndex)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.item
        configureView()
        collectionView.reloadData()
    }
}

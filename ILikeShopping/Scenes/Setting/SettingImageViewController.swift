//
//  SettingImageViewController.swift
//  ILikeShopping
//
//  Created by 김성민 on 6/13/24.
//

import UIKit

protocol SendDataDelegate {
    func recieveData(data: Int) -> Void
}

final class SettingImageViewController: BaseViewController {
    
    let selectedImageView = ProfileImageView(frame: .zero)
    let cameraImageView = CameraImageView(frame: .zero)
    let collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: CollectionViewDesign.collectionViewLayout(
            sectionSpacing: 10,
            cellSpacing: 10,
            cellCount: 4,
            aspectRatio: 1
        )
    )
    
    var settingOption: SettingOption = .setting
    var selectedIndex: Int = 0
    // (1) 이전 화면에 데이터를 전달하기 위한 delegate
    var delegate: SendDataDelegate?
    // (2) 클로저
//    var completionHandler: ((Int) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        print(#function)
//        // 이전 화면(닉네임 화면)에 데이터 전달
////        let popVc = navigationController?.viewControllers.last! as? SettingNicknameViewController
////        popVc?.imageIndex = selectedIndex
//        
//        // MARK: - viewWillDisappear는 실제로 이전 화면으로 돌아가지 않더라도 호출될 수 있음
//        // => 역값전달의 시점은 viewWillDisappear보다 viewDidDisappear가 더 적절해보임.
//        // 단, navigationController?.viewControllers.last!의 방식으로는 전달할 수 없음
//        // => navigationController가 nil이기 때문!
//    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // 1. delegate
        delegate?.recieveData(data: selectedIndex)
        // 2. 클로저
//        completionHandler!(selectedIndex)
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
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ProfileImageCollectionViewCell.identifier,
            for: indexPath
        ) as? ProfileImageCollectionViewCell else {
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

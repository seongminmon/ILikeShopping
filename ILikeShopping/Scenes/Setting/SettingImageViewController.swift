//
//  SettingImageViewController.swift
//  ILikeShopping
//
//  Created by 김성민 on 6/13/24.
//

import UIKit

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
    
    // (1) 이전 화면에 데이터를 전달하기 위한 delegate
//    var delegate: SendDataDelegate?
    // (2) 클로저
//    var completionHandler: ((Int) -> Void)?
    
    var viewModel: SettingImageViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        bindData()
    }
    
    func bindData() {
        viewModel.outputSelectedIndex.bind { [weak self] _ in
            guard let self else { return }
            configureView()
            collectionView.reloadData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.inputViewWillDisappear.value = ()
        
        // 1. delegate
//        delegate?.recieveData(data: selectedIndex)
        // 2. 클로저
//        completionHandler!(selectedIndex)
    }
    
    override func configureNavigationBar() {
        navigationItem.title = viewModel.settingOption.rawValue
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
        guard let index = viewModel.outputSelectedIndex.value else { return }
        selectedImageView.configureImageView(
            image: MyImage.profileImageList[index],
            isSelect: true
        )
    }
    
    func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(
            ProfileImageCollectionViewCell.self,
            forCellWithReuseIdentifier: ProfileImageCollectionViewCell.identifier
        )
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
        ) as? ProfileImageCollectionViewCell,
              let selectedIndex = viewModel.outputSelectedIndex.value else {
            return UICollectionViewCell()
        }
        cell.configureCell(index: indexPath.item, selectedIndex: selectedIndex)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.inputCellSelected.value = indexPath.item
    }
}

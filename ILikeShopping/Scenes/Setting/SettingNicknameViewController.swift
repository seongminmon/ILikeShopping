//
//  SettingNicknameViewController.swift
//  ILikeShopping
//
//  Created by 김성민 on 6/13/24.
//

import UIKit

class SettingNicknameViewController: UIViewController {
    
    let profileImageView = ProfileImageView(image: MyImage.profileImageList.randomElement()!, isSelect: true)
    let profileImageButton = UIButton()
    let cameraImageView = CameraImageView(frame: .zero)
    let nicknameTextField = UITextField()
    let separator = UIView()
    let descriptionLabel = UILabel()
    let completeButton = OrangeButton(title: "완료")

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureHierarchy()
        configureLayout()
        configureUI()
    }
    
    func configureNavigationBar() {
        navigationItem.title = "PROFILE SETTING"
    }
    
    func configureHierarchy() {
        view.addSubview(profileImageView)
        view.addSubview(profileImageButton)
        view.addSubview(cameraImageView)
        view.addSubview(nicknameTextField)
        view.addSubview(descriptionLabel)
        view.addSubview(separator)
        view.addSubview(completeButton)
    }
    
    func configureLayout() {
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.centerX.equalToSuperview()
            make.size.equalTo(150)
        }
        
        profileImageButton.snp.makeConstraints { make in
            make.edges.equalTo(profileImageView)
        }
        
        cameraImageView.snp.makeConstraints { make in
            make.trailing.bottom.equalTo(profileImageView)
            make.size.equalTo(50)
        }
        
        nicknameTextField.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(50)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameTextField.snp.bottom).offset(16)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(24)
        }
        
        separator.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(1)
        }
        
        completeButton.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(50)
        }
    }
    
    func configureUI() {
        profileImageButton.addTarget(self, action: #selector(profileImageButtonTapped), for: .touchUpInside)
        
        nicknameTextField.placeholder = "닉네임을 입력해주세요 :)"
        nicknameTextField.font = Font.regular14
        
        descriptionLabel.text = "닉네임에 @ 는 포함할 수 없어요."
        descriptionLabel.font = Font.regular13
        descriptionLabel.textColor = MyColor.orange
        completeButton.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)
    }
    
    @objc func profileImageButtonTapped() {
        let vc = SettingImageViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func completeButtonTapped() {
        // TODO: - 닉네임 조건 맞을 시 메인 화면으로 window 전환
        let vc = MainViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

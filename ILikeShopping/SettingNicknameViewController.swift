//
//  SettingNicknameViewController.swift
//  ILikeShopping
//
//  Created by 김성민 on 6/13/24.
//

import UIKit

class SettingNicknameViewController: UIViewController {
    
    // TODO: - camera, separator 추가하기
    // TODO: - imageview 선택시 화면이동
    
    let profileImageView = ProfileImageView(image: MyImage.profileImageList.randomElement()!, isSelect: true)
    let nicknameTextField = UITextField()
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
        view.addSubview(nicknameTextField)
        view.addSubview(descriptionLabel)
        view.addSubview(completeButton)
    }
    
    func configureLayout() {
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.centerX.equalToSuperview()
            make.size.equalTo(150)
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
        
        completeButton.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(50)
        }
    }
    
    func configureUI() {
        nicknameTextField.placeholder = "닉네임을 입력해주세요 :)"
        nicknameTextField.font = Font.regular14
        
        descriptionLabel.text = "닉네임에 @ 는 포함할 수 없어요."
        descriptionLabel.font = Font.regular13
        descriptionLabel.textColor = MyColor.orange
        completeButton.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)
    }
    
    @objc func completeButtonTapped() {
        // TODO: - 닉네임 조건 맞을 시 메인 화면으로 이동
    }
}

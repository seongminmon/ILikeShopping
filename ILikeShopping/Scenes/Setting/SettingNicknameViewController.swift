//
//  SettingNicknameViewController.swift
//  ILikeShopping
//
//  Created by 김성민 on 6/13/24.
//

import UIKit

enum NickNameCondition: String {
    case lengthError = "2글자 이상 10글자 미만으로 설정해주세요"
    case specialCharacterError = "닉네임에 @, #, $, % 는 포함할 수 없어요"
    case numberError = "닉네임에 숫자는 포함할 수 없어요"
    case possible = "사용할 수 있는 닉네임이에요"
}

class SettingNicknameViewController: UIViewController {
    
    // TODO: - 닉네임 설정 화면, 닉네임 수정 화면 2개로 활용하기
    
    let profileImageView = ProfileImageView(image: nil, isSelect: true)
    let profileImageButton = UIButton()
    let cameraImageView = CameraImageView(frame: .zero)
    let nicknameTextField = UITextField()
    let separator = UIView()
    let descriptionLabel = UILabel()
    let completeButton = OrangeButton(title: "완료")
    
    let ud = UserDefaultsManager.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureHierarchy()
        configureLayout()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 이미지 설정 화면에서 선택한 이미지 적용하기
        profileImageView.image = ud.profileImage
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
        // random Index 뽑기
        ud.profileImageIndex = Int.random(in: 0..<MyImage.profileImageList.count)
        // 이미지뷰에 이미지 세팅하기
        profileImageView.image = ud.profileImage
        
        profileImageButton.addTarget(self, action: #selector(profileImageButtonTapped), for: .touchUpInside)
        
        nicknameTextField.placeholder = "닉네임을 입력해주세요 :)"
        nicknameTextField.font = Font.regular14
        nicknameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        descriptionLabel.font = Font.regular13
        descriptionLabel.textColor = MyColor.orange
        completeButton.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)
    }
    
    @objc func profileImageButtonTapped() {
        let vc = SettingImageViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func completeButtonTapped() {
        // 닉네임 조건 검사
        if descriptionLabel.text == NickNameCondition.possible.rawValue {
            // 값 저장
            ud.nickname = nicknameTextField.text ?? "OOO"
//            ud.profileImageIndex = 0
            ud.signUpDate = Date()
            
            // 메인 화면으로 window 전환
            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
            let sceneDelegate = windowScene?.delegate as? SceneDelegate
            
            let tab = TabBarController()
            sceneDelegate?.window?.rootViewController = tab
            sceneDelegate?.window?.makeKeyAndVisible()
        }
    }
    
    // textField text 값이 변할 때마다 유효성 검사
    @objc func textFieldDidChange() {
        descriptionLabel.text = checkNickname(nicknameTextField.text ?? "")
    }
    
    func checkNickname(_ str: String) -> String {
        // 1) 2글자 이상 10글자 미만
        // 2) "@, #, $, % 사용 불가
        // 3) 숫자 사용 불가
        if str.count < 2 || str.count >= 10 {
            return NickNameCondition.lengthError.rawValue
        } else if str.contains("@") || str.contains("#") || str.contains("$") || str.contains("%") {
            return NickNameCondition.specialCharacterError.rawValue
        } else if str.filter({ $0.isNumber }).count > 0 {
            return NickNameCondition.numberError.rawValue
        } else {
            return NickNameCondition.possible.rawValue
        }
    }
}

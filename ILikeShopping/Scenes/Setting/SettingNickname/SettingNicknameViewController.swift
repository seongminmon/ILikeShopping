//
//  SettingNicknameViewController.swift
//  ILikeShopping
//
//  Created by 김성민 on 6/13/24.
//

import UIKit
import SnapKit

enum SettingOption: String {
    case setting = "PROFILE SETTING"
    case edit = "EDIT PROFILE"
}

final class SettingNicknameViewController: BaseViewController {
    
    let profileImageView = ProfileImageView(frame: .zero)
    let profileImageButton = UIButton()
    let cameraImageView = CameraImageView(frame: .zero)
    let nicknameTextField = UITextField()
    let separator = UIView()
    let descriptionLabel = UILabel()
    let completeButton = OrangeButton(title: "완료")
    
    // 이전 화면에서 전달
    var settingOption: SettingOption = .setting

    let viewModel = SettingNicknameViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindData()
    }
    
    func bindData() {
        viewModel.outputNicknameValidation.bind { [weak self] error in
            guard let self else { return }
            if let error {
                descriptionLabel.text = error.errorDescription
                completeButton.isEnabled = false
                navigationItem.rightBarButtonItem?.isEnabled = false
            } else {
                descriptionLabel.text = "사용할 수 있는 닉네임이에요"
                completeButton.isEnabled = true
                navigationItem.rightBarButtonItem?.isEnabled = true
            }
        }
    }
    
    override func configureNavigationBar() {
        navigationItem.title = settingOption.rawValue
        
        switch settingOption {
        case .setting:
            break
        case .edit:
            // 수정 일땐 완료 버튼 대신 저장 버튼 사용
            completeButton.isHidden = true
            let saveButton = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(saveButtonTapped))
            navigationItem.rightBarButtonItem = saveButton
        }
    }
    
    override func addSubviews() {
        view.addSubview(profileImageView)
        view.addSubview(profileImageButton)
        view.addSubview(cameraImageView)
        view.addSubview(nicknameTextField)
        view.addSubview(descriptionLabel)
        view.addSubview(separator)
        view.addSubview(completeButton)
    }
    
    override func configureLayout() {
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
        
        separator.snp.makeConstraints { make in
            make.top.equalTo(nicknameTextField.snp.bottom)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(1)
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
    
    override func configureView() {
        switch settingOption {
        case .setting:
            // 초기 설정일 땐 랜덤으로 설정
            viewModel.imageIndex = Int.random(in: 0..<MyImage.profileImageList.count)
            profileImageView.configureImageView(image: MyImage.profileImageList[viewModel.imageIndex], isSelect: true)
        case .edit:
            // 수정일 땐 기존 선택된 이미지로 설정
            profileImageView.configureImageView(image: UserDefaultsManager.shared.profileImage, isSelect: true)
            
            nicknameTextField.text = UserDefaultsManager.shared.nickname
            nicknameTextField.becomeFirstResponder()
        }
        
        profileImageButton.addTarget(self, action: #selector(profileImageButtonTapped), for: .touchUpInside)
        
        nicknameTextField.placeholder = "닉네임을 입력해주세요 :)"
        nicknameTextField.font = MyFont.regular14
        nicknameTextField.clearButtonMode = .whileEditing
        nicknameTextField.delegate = self
        nicknameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        
        separator.backgroundColor = MyColor.black
        
        descriptionLabel.font = MyFont.regular13
        descriptionLabel.textColor = MyColor.orange
        
        completeButton.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)
    }
    
    @objc func profileImageButtonTapped() {
        // 이미지 선택 뷰로 이동
        let vm = SettingImageViewModel()
        vm.settingOption = settingOption
        vm.outputSelectedIndex.value = viewModel.imageIndex
        vm.delegate = self
        let vc = SettingImageViewController()
        vc.viewModel = vm
        navigate(vc: vc)
        
//        let vc = SettingImageViewController()
//        // settingOption 동기화
//        vc.settingOption = settingOption
//        vc.selectedIndex = viewModel.imageIndex
//        // (1) delegate
//        vc.delegate = self
//        navigate(vc: vc)
        
        // (2) 클로저
//        vc.completionHandler = { index in
//            self.imageIndex = index
//            self.profileImageView.image = MyImage.profileImageList[self.imageIndex]
//        }
    }
    
    @objc func textFieldDidChange() {
        viewModel.inputNicknameTextfieldChange.value = nicknameTextField.text
    }
    
    // MARK: - UD에 저장하는 시점 == 완료버튼이나 저장버튼을 누를 때
    
    @objc func completeButtonTapped() {
        viewModel.inputCompleteButtonTapped.value = nicknameTextField.text
        
        // 닉네임 조건 검사
        if viewModel.nicknameValidationError == nil {
            // 메인 화면으로 window 전환
            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
            let sceneDelegate = windowScene?.delegate as? SceneDelegate
            
            let tab = BaseTabBarController()
            sceneDelegate?.window?.rootViewController = tab
            sceneDelegate?.window?.makeKeyAndVisible()
        }
    }
    
    @objc func saveButtonTapped() {
        viewModel.inputSaveButtonTapped.value = nicknameTextField.text
        
        // 닉네임 조건 검사
        if viewModel.nicknameValidationError == nil {
            // 이전 화면으로 돌아가기 (설정 화면)
            navigationController?.popViewController(animated: true)
        }
    }
}

extension SettingNicknameViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // 닉네임 조건 통과 시 키보드 내리기
        if let error = viewModel.outputNicknameValidation.value {
            return false
        } else {
            view.endEditing(true)
            return true
        }
    }
}

// (2) delegate
extension SettingNicknameViewController: SendDataDelegate {
    func recieveData(data: Int) {
        // 이미지 선택 뷰에서 선택한 이미지 보이기
        viewModel.imageIndex = data
        profileImageView.image = MyImage.profileImageList[viewModel.imageIndex]
    }
}

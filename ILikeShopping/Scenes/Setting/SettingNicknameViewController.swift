//
//  SettingNicknameViewController.swift
//  ILikeShopping
//
//  Created by 김성민 on 6/13/24.
//

import UIKit

enum SettingOption: String {
    case setting = "PROFILE SETTING"
    case edit = "EDIT PROFILE"
}

enum NicknameValidationError: Error, LocalizedError {
    case length
    case invalidCharacter
    case number
    
    var errorDescription: String? {
        switch self {
        case .length: "2글자 이상 10글자 미만으로 설정해주세요"
        case .invalidCharacter: "닉네임에 @, #, $, % 는 포함할 수 없어요"
        case .number: "닉네임에 숫자는 포함할 수 없어요"
        }
    }
}

class SettingNicknameViewController: BaseViewController {
    
    let profileImageView = ProfileImageView(frame: .zero)
    let profileImageButton = UIButton()
    let cameraImageView = CameraImageView(frame: .zero)
    let nicknameTextField = UITextField()
    let separator = UIView()
    let descriptionLabel = UILabel()
    let completeButton = OrangeButton(title: "완료")
    
    let ud = UserDefaultsManager.shared
    var settingOption: SettingOption = .setting
    var nicknameValidationError: NicknameValidationError?
    lazy var imageIndex: Int = ud.profileImageIndex

    override func viewDidLoad() {
        super.viewDidLoad()
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
            imageIndex = Int.random(in: 0..<MyImage.profileImageList.count)
            profileImageView.configureImageView(image: MyImage.profileImageList[imageIndex], isSelect: true)
            
            descriptionLabel.textColor = MyColor.orange
        case .edit:
            // 수정일 땐 기존 선택된 이미지로 설정
            profileImageView.configureImageView(image: ud.profileImage, isSelect: true)
            
            nicknameTextField.text = ud.nickname
            nicknameTextField.becomeFirstResponder()
            
            descriptionLabel.textColor = MyColor.black
        }
        
        profileImageButton.addTarget(self, action: #selector(profileImageButtonTapped), for: .touchUpInside)
        
        nicknameTextField.placeholder = "닉네임을 입력해주세요 :)"
        nicknameTextField.font = MyFont.regular14
        nicknameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        separator.backgroundColor = MyColor.black
        
        textFieldDidChange()
        descriptionLabel.font = MyFont.regular13
        
        completeButton.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)
    }
    
    @objc func profileImageButtonTapped() {
        // 이미지 선택 뷰로 이동
        let vc = SettingImageViewController()
        // settingOption 동기화
        vc.settingOption = settingOption
        vc.selectedIndex = imageIndex
        // (1) delegate
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
        
        // (2) 클로저
//        vc.completionHandler = { index in
//            self.imageIndex = index
//            self.profileImageView.image = MyImage.profileImageList[self.imageIndex]
//        }
//        navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - UD에 저장하는 시점 == 완료버튼이나 저장버튼을 누를 때
    
    @objc func completeButtonTapped() {
        // 닉네임 조건 검사
        if nicknameValidationError == nil {
            // 값 저장
            ud.nickname = nicknameTextField.text ?? ""
            ud.profileImageIndex = imageIndex
            ud.signUpDate = Date()
            
            // 메인 화면으로 window 전환
            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
            let sceneDelegate = windowScene?.delegate as? SceneDelegate
            
            let tab = BaseTabBarController()
            sceneDelegate?.window?.rootViewController = tab
            sceneDelegate?.window?.makeKeyAndVisible()
        }
    }
    
    @objc func saveButtonTapped() {
        // 닉네임 조건 검사
        if nicknameValidationError == nil {
            // 값 저장
            ud.nickname = nicknameTextField.text ?? ""
            ud.profileImageIndex = imageIndex
            
            // 이전 화면으로 돌아가기 (설정 화면)
            navigationController?.popViewController(animated: true)
        }
    }
    
    // MARK: - 닉네임 조건 검사
    // Error Handling
    // textField text 값이 변할 때마다 유효성 검사
    @objc func textFieldDidChange() {
        do {
            if try checkNickname(nicknameTextField.text ?? "") {
                nicknameValidationError = nil
                descriptionLabel.text = "사용할 수 있는 닉네임이에요"
            }
        } catch let error as NicknameValidationError {
            nicknameValidationError = error
            descriptionLabel.text = nicknameValidationError?.errorDescription
        } catch {
            print("알 수 없는 에러!")
        }
    }
    
    func checkNickname(_ text: String) throws -> Bool {
        // 1) 2글자 이상 10글자 미만
        guard text.count >= 2 && text.count < 10 else {
            throw NicknameValidationError.length
        }
        // 2) @, #, $, % 사용 불가
        let invalidCharacters = "@#$%"
        guard text.filter({ invalidCharacters.contains($0) }).isEmpty else {
            throw NicknameValidationError.invalidCharacter
        }
        // 3) 숫자 사용 불가
        guard text.filter({ $0.isNumber }).isEmpty else {
            throw NicknameValidationError.number
        }
        return true
    }
    
}

// (2) delegate
extension SettingNicknameViewController: SendDataDelegate {
    func recieveData(data: Int) {
        // 이미지 선택 뷰에서 선택한 이미지 보이기
        imageIndex = data
        profileImageView.image = MyImage.profileImageList[imageIndex]
    }
}

//
//  SettingNicknameViewModel.swift
//  ILikeShopping
//
//  Created by 김성민 on 7/9/24.
//

import Foundation

enum NicknameValidationError: Error, LocalizedError {
    case length
    case invalidCharacter
    case number
    case whitespace
    
    var errorDescription: String? {
        switch self {
        case .length: "2글자 이상 10글자 미만으로 설정해주세요"
        case .invalidCharacter: "닉네임에 @, #, $, % 는 포함할 수 없어요"
        case .number: "닉네임에 숫자는 포함할 수 없어요"
        case .whitespace: "닉네임에 공백은 포함할 수 없어요"
        }
    }
}

final class SettingNicknameViewModel {
    
    var imageIndex: Int = UserDefaultsManager.shared.profileImageIndex
    
    var nicknameValidationError: NicknameValidationError?
    
    // MARK: - Input
    // 닉네임 텍스트 필드에 글자 입력
    var inputNicknameTextfieldChange: Observable<String?> = Observable(UserDefaultsManager.shared.nickname)
    // 완료 버튼 탭
    var inputCompleteButtonTapped: Observable<String?> = Observable(nil)
    // 저장 버튼 탭
    var inputSaveButtonTapped: Observable<String?> = Observable(nil)
    
    // MARK: - Output
    // descriptionLabel에 닉네임 유효성 검사 결과 알려주기
    // MARK: - 초기값으로 nil을 줘도 되는 이유: inputNicknameTextfieldChange의 초기값으로 에러 처리가 가능함
    var outputNicknameValidation: Observable<NicknameValidationError?> = Observable(nil)
    
    init() {
        transform()
    }
    
    private func transform() {
        inputNicknameTextfieldChange.bind { [weak self] value in
            guard let self else { return }
            nicknameValidationResult(value)
        }
        
        inputCompleteButtonTapped.bind { [weak self] value in
            guard let self else { return }
            saveData(value, isNew: true)
        }
        
        inputSaveButtonTapped.bind { [weak self] value in
            guard let self else { return }
            saveData(value, isNew: false)
        }
    }
    
    private func saveData(_ nickname: String?, isNew: Bool) {
        guard let nickname = nickname else { return }
        // 닉네임 조건 검사
        if nicknameValidationError == nil {
            // 값 저장
            UserDefaultsManager.shared.nickname = nickname
            UserDefaultsManager.shared.profileImageIndex = imageIndex
            
            // 새로 추가하는 것이면 현재 날짜도 저장
            if isNew {
                UserDefaultsManager.shared.signUpDate = Date()
            }
        }
    }
    
    // MARK: - 닉네임 조건 검사
    // Error Handling
    // textField text 값이 변할 때마다 유효성 검사
    private func nicknameValidationResult(_ text: String?) {
        guard let text = text else { return }
        do {
            if try checkNickname(text) {
                nicknameValidationError = nil
                outputNicknameValidation.value = nil
            }
        } catch let error as NicknameValidationError {
            nicknameValidationError = error
            outputNicknameValidation.value = nicknameValidationError
        } catch {
            print("알 수 없는 에러!")
        }
    }
    
    private func checkNickname(_ text: String) throws -> Bool {
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
        // 4) 공백 사용 불가
        guard text.filter({ $0.isWhitespace }).isEmpty else {
            throw NicknameValidationError.whitespace
        }
        return true
    }
}

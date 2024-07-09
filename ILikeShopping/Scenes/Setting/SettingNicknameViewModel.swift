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
    
    var errorDescription: String? {
        switch self {
        case .length: "2글자 이상 10글자 미만으로 설정해주세요"
        case .invalidCharacter: "닉네임에 @, #, $, % 는 포함할 수 없어요"
        case .number: "닉네임에 숫자는 포함할 수 없어요"
        }
    }
}

final class SettingNicknameViewModel {
    
//    let ud = UserDefaultsManager.shared
    var nicknameValidationError: NicknameValidationError?
//    lazy var imageIndex: Int = ud.profileImageIndex
    
    // MARK: - Input
    // 닉네임 텍스트 필드에 글자 입력
    var inputNicknameTextfieldChange: Observable<String?> = Observable("")
    // 완료 버튼 탭
    // 저장 버튼 탭
    
    // MARK: - Output
    // descriptionLabel에 닉네임 유효성 검사 결과 알려주기
    var outputNicknameValidation: Observable<String?> = Observable("")
    
    init() {
        inputNicknameTextfieldChange.bind { text in
            self.nicknameValidationResult(text)
        }
    }
    
    private func nicknameValidationResult(_ text: String?) {
        guard let text = text else { return }
        do {
            if try checkNickname(text) {
                nicknameValidationError = nil
                outputNicknameValidation.value = "사용할 수 있는 닉네임이에요"
            }
        } catch let error as NicknameValidationError {
            nicknameValidationError = error
            outputNicknameValidation.value = nicknameValidationError?.errorDescription
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
        return true
    }
}

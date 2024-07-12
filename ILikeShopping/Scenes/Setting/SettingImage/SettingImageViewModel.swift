//
//  SettingImageViewModel.swift
//  ILikeShopping
//
//  Created by 김성민 on 7/12/24.
//

import Foundation

protocol SendDataDelegate {
    func recieveData(data: Int) -> Void
}

final class SettingImageViewModel {
    
    var settingOption: SettingOption = .setting
    // 이전 화면에 데이터를 전달하기 위한 delegate
    var delegate: SendDataDelegate?
    
    // MARK: - Input
    var inputViewWillDisappear: Observable<Void?> = Observable(nil)
    var inputCellSelected: Observable<Int?> = Observable(nil)
    
    // MARK: - Output
    var outputSelectedIndex: Observable<Int?> = Observable(nil)

    init() {
        transform()
    }
    
    private func transform() {
        inputViewWillDisappear.bind { [weak self] _ in
            guard let self,
                  let data = outputSelectedIndex.value else {
                return
            }
            delegate?.recieveData(data: data)
        }
        
        inputCellSelected.bind { [weak self] index in
            guard let self, let index else { return }
            outputSelectedIndex.value = index
        }
    }
}

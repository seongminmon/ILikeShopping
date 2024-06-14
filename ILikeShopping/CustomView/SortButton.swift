//
//  SortButton.swift
//  ILikeShopping
//
//  Created by 김성민 on 6/14/24.
//

import UIKit

class SortButton: UIButton {
    
    init(option: SortOption, isSelect: Bool) {
        super.init(frame: .zero)
        setTitle(option.buttonTitle, for: .normal)
        titleLabel?.font = Font.regular14
        if isSelect {
            setTitleColor(MyColor.white, for: .normal)
            backgroundColor = MyColor.darkgray
        } else {
            setTitleColor(MyColor.black, for: .normal)
            backgroundColor = MyColor.white
        }
        clipsToBounds = true
        layer.cornerRadius = 15
        layer.borderColor = MyColor.darkgray.cgColor
        layer.borderWidth = 1
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

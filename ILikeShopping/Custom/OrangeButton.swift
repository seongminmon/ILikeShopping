//
//  OrangeButton.swift
//  ILikeShopping
//
//  Created by 김성민 on 6/13/24.
//

import UIKit

class OrangeButton: UIButton {
    
    init(title: String) {
        super.init(frame: .zero)
        setTitle(title, for: .normal)
        titleLabel?.font = MyFont.bold16
        setTitleColor(MyColor.white, for: .normal)
        backgroundColor = MyColor.orange
        clipsToBounds = true
        layer.cornerRadius = 20
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

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
        titleLabel?.font = .boldSystemFont(ofSize: 16)
        setTitleColor(.white, for: .normal)
        backgroundColor = .systemOrange
        clipsToBounds = true
        layer.cornerRadius = 20
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

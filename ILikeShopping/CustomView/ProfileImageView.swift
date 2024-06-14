//
//  ProfileImageView.swift
//  ILikeShopping
//
//  Created by 김성민 on 6/13/24.
//

import UIKit

class ProfileImageView: UIImageView {
    
    init(image: UIImage?, isSelect: Bool) {
        super.init(frame: .zero)
        self.image = image
        contentMode = .scaleAspectFit
        
        if isSelect {
            layer.borderWidth = 3
            layer.borderColor = MyColor.orange.cgColor
            alpha = 1
        } else {
            layer.borderWidth = 1
            layer.borderColor = MyColor.lightgray.cgColor
            alpha = 0.5
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        clipsToBounds = true
        layer.cornerRadius = frame.width / 2
    }
}

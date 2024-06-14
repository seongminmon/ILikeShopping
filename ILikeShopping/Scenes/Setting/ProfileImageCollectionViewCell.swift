//
//  ProfileImageCollectionViewCell.swift
//  ILikeShopping
//
//  Created by 김성민 on 6/14/24.
//

import UIKit
import SnapKit

class ProfileImageCollectionViewCell: UICollectionViewCell {
    
    let profileImageView =  ProfileImageView(image: nil, isSelect: false)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(profileImageView)
        profileImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(index: Int, selectedIndex: Int) {
        let image = MyImage.profileImageList[index]
        profileImageView.image = image
        
        if index == selectedIndex {
            profileImageView.layer.borderWidth = 3
            profileImageView.layer.borderColor = MyColor.orange.cgColor
            profileImageView.alpha = 1
        } else {
            profileImageView.layer.borderWidth = 1
            profileImageView.layer.borderColor = MyColor.lightgray.cgColor
            profileImageView.alpha = 0.5
        }
    }
}

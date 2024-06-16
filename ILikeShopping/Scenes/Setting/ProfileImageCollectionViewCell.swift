//
//  ProfileImageCollectionViewCell.swift
//  ILikeShopping
//
//  Created by 김성민 on 6/14/24.
//

import UIKit
import SnapKit

class ProfileImageCollectionViewCell: UICollectionViewCell {
    
    let profileImageView = ProfileImageView(frame: .zero)
    
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
        profileImageView.configureImageView(image: MyImage.profileImageList[index], isSelect: index == selectedIndex)
    }
}

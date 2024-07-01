//
//  ProfileImageCollectionViewCell.swift
//  ILikeShopping
//
//  Created by 김성민 on 6/14/24.
//

import UIKit
import SnapKit

final class ProfileImageCollectionViewCell: BaseCollectionViewCell {
    
    let profileImageView = ProfileImageView(frame: .zero)
    
    override func addSubviews() {
        contentView.addSubview(profileImageView)
    }
    
    override func configureLayout() {
        profileImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configureCell(index: Int, selectedIndex: Int) {
        profileImageView.configureImageView(image: MyImage.profileImageList[index], isSelect: index == selectedIndex)
    }
}

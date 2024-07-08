//
//  BasketSearchTableViewCell.swift
//  ILikeShopping
//
//  Created by 김성민 on 7/8/24.
//

import UIKit
import SnapKit

final class BasketSearchTableViewCell: BaseTableViewCell {
    
    let mainLabel = UILabel()
    let subLabel = UILabel()
    
    override func addSubviews() {
        contentView.addSubview(mainLabel)
        contentView.addSubview(subLabel)
    }
    
    override func configureLayout() {
        mainLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(16)
        }
        
        subLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(16)
        }
    }
    
    override func configureView() {
        mainLabel.text = "메인라벨"
        subLabel.text = "서브라벨"
    }
}

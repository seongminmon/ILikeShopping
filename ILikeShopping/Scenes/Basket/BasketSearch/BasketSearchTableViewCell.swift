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
            make.verticalEdges.equalToSuperview().inset(8)
            make.leading.equalToSuperview().inset(16)
            make.trailing.equalTo(subLabel.snp.leading).offset(-8)
            make.height.greaterThanOrEqualTo(subLabel)
        }
        
        subLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(16)
            make.width.equalTo(120)
            make.height.equalTo(40)
        }
    }
    
    override func configureView() {
        mainLabel.numberOfLines = 0
        subLabel.clipsToBounds = true
        subLabel.layer.cornerRadius = 20
        subLabel.backgroundColor = MyColor.orange
        subLabel.textAlignment = .center
    }
    
    func configureCell(_ data: Basket) {
        mainLabel.text = data.encodedString
        // 역관계 이용해서 접근하기
        subLabel.text = "\(data.main.first!.name)"
    }
}

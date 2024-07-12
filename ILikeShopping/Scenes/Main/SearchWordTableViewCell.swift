//
//  SearchWordTableViewCell.swift
//  ILikeShopping
//
//  Created by 김성민 on 6/14/24.
//

import UIKit
import SnapKit

final class SearchWordTableViewCell: BaseTableViewCell {

    let clockImageView = UIImageView()
    let mainLabel = UILabel()
    let deleteButton = UIButton()
    
    override func addSubviews() {
        contentView.addSubview(clockImageView)
        contentView.addSubview(mainLabel)
        contentView.addSubview(deleteButton)
    }
    
    override func configureLayout() {
        clockImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
            make.size.equalTo(20)
        }
        
        mainLabel.snp.makeConstraints { make in
            make.leading.equalTo(clockImageView.snp.trailing).offset(8)
            make.trailing.equalTo(deleteButton.snp.leading).offset(-8)
            make.centerY.equalToSuperview()
            make.height.equalTo(20)
        }
        
        deleteButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
            make.size.equalTo(20)
        }
    }
    
    override func configureView() {
        clockImageView.image = MyImage.clock
        clockImageView.tintColor = MyColor.black
        mainLabel.font = MyFont.regular14
        deleteButton.setImage(MyImage.xmark, for: .normal)
        deleteButton.tintColor = MyColor.black
    }
    
    func configureCell(text: String) {
        mainLabel.text = text
    }
}

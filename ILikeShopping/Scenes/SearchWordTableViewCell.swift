//
//  SearchWordTableViewCell.swift
//  ILikeShopping
//
//  Created by 김성민 on 6/14/24.
//

import UIKit
import SnapKit

class SearchWordTableViewCell: UITableViewCell {

    let clockImageView = UIImageView()
    let mainLabel = UILabel()
    let deleteButton = UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(clockImageView)
        contentView.addSubview(mainLabel)
        contentView.addSubview(deleteButton)
        
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
        
        clockImageView.image = MyImage.clock
        clockImageView.tintColor = MyColor.black
        mainLabel.font = MyFont.regular14
        deleteButton.setImage(MyImage.xmark, for: .normal)
        deleteButton.tintColor = MyColor.black
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(text: String) {
        mainLabel.text = text
    }
}

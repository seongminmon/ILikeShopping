//
//  SettingTableViewCell.swift
//  ILikeShopping
//
//  Created by 김성민 on 6/14/24.
//

import UIKit
import SnapKit

class SettingTableViewCell: UITableViewCell {

    let titleLabel = UILabel()
    let shoppingImageView = UIImageView()
    let shoppingCountLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(shoppingImageView)
        contentView.addSubview(shoppingCountLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.trailing.equalTo(shoppingImageView)
            make.centerY.equalToSuperview()
            make.height.equalTo(30)
        }
        
        shoppingImageView.snp.makeConstraints { make in
            make.trailing.equalTo(shoppingCountLabel.snp.leading).offset(-4)
            make.centerY.equalToSuperview()
            make.size.equalTo(20)
        }
        
        shoppingCountLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
            make.height.equalTo(30)
        }
        
        titleLabel.font = Font.regular14
        shoppingCountLabel.font = Font.regular14
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(title: String, count: Int?) {
        titleLabel.text = title
        if let count {
            shoppingImageView.image = UIImage(named: "like_selected")!
            shoppingCountLabel.text = "\(count)개의 상품"
            let fullText = shoppingCountLabel.text ?? ""
            let attribtuedString = NSMutableAttributedString(string: fullText)
            let range = (fullText as NSString).range(of: "\(count)개")
            attribtuedString.addAttribute(.font, value: Font.bold14, range: range)
            shoppingCountLabel.attributedText = attribtuedString
        } else {
            shoppingImageView.image = nil
            shoppingCountLabel.text = nil
        }
    }
    
}

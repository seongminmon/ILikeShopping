//
//  SearchCollectionViewCell.swift
//  ILikeShopping
//
//  Created by 김성민 on 6/14/24.
//

import UIKit
import Kingfisher
import SnapKit

class SearchCollectionViewCell: UICollectionViewCell {
    
    let mainImageView = UIImageView()
    let likeButton = UIButton()
    let mallLabel = UILabel()
    let titleLabel = UILabel()
    let priceLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(mainImageView)
        contentView.addSubview(likeButton)
        contentView.addSubview(mallLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(priceLabel)
        
        mainImageView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(mainImageView.snp.width).multipliedBy(1.1)
        }
        
        likeButton.snp.makeConstraints { make in
            make.trailing.bottom.equalTo(mainImageView).inset(8)
            make.size.equalTo(30)
        }
        
        mallLabel.snp.makeConstraints { make in
            make.top.equalTo(mainImageView.snp.bottom).offset(4)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(16)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(mallLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalToSuperview()
        }
        
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(20)
            make.bottom.equalToSuperview().inset(8)
        }
        
        mainImageView.clipsToBounds = true
        mainImageView.layer.cornerRadius = 20
        
        likeButton.clipsToBounds = true
        likeButton.layer.cornerRadius = 10
        
        mallLabel.font = MyFont.regular13
        mallLabel.textColor = MyColor.gray
        
        titleLabel.font = MyFont.regular14
        titleLabel.textColor = MyColor.black
        titleLabel.numberOfLines = 2
        
        priceLabel.font = MyFont.bold15
        priceLabel.textColor = MyColor.black
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(data: Shopping?, query: String, isSelected: Bool) {
        guard let data else { return }
        mainImageView.kf.setImage(with: data.imageUrl)
        mallLabel.text = data.mallName
        
        titleLabel.text = data.encodedString
        let fullText = titleLabel.text ?? ""
        let attribtuedString = NSMutableAttributedString(string: fullText)
        let range = (fullText as NSString).range(of: query)
        attribtuedString.addAttribute(.backgroundColor, value: MyColor.orange, range: range)
        titleLabel.attributedText = attribtuedString
        
        priceLabel.text = data.price
        
        if isSelected {
            likeButton.setImage(MyImage.selected, for: .normal)
            likeButton.backgroundColor = MyColor.white
            likeButton.layer.opacity = 1
        } else {
            likeButton.setImage(MyImage.unselected, for: .normal)
            likeButton.backgroundColor = MyColor.black
            likeButton.layer.opacity = 0.5
        }
        
    }
}

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
        }
        
        mainImageView.clipsToBounds = true
        mainImageView.layer.cornerRadius = 20
        
        // TODO: - like 동기화 시키기
        likeButton.setImage(MyImage.unselected, for: .normal)
        likeButton.backgroundColor = MyColor.black
        likeButton.layer.opacity = 0.5
        
        likeButton.clipsToBounds = true
        likeButton.layer.cornerRadius = 10
        
        mallLabel.font = Font.regular13
        mallLabel.textColor = MyColor.gray
        
        titleLabel.font = Font.regular14
        titleLabel.textColor = MyColor.black
        titleLabel.numberOfLines = 2
        
        priceLabel.font = Font.bold15
        priceLabel.textColor = MyColor.black
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(data: Shopping?) {
        guard let data else { return }
        mainImageView.kf.setImage(with: data.imageUrl)
        mallLabel.text = data.mallName
        titleLabel.text = data.encodedString
        priceLabel.text = data.price
    }
}

//
//  SearchCollectionViewCell.swift
//  ILikeShopping
//
//  Created by 김성민 on 6/14/24.
//

import UIKit
import SnapKit

final class SearchCollectionViewCell: BaseCollectionViewCell {
    
    let mainImageView = UIImageView()
    let likeButton = UIButton()
    let mallLabel = UILabel()
    let titleLabel = UILabel()
    let priceLabel = UILabel()
    
    override func addSubviews() {
        contentView.addSubview(mainImageView)
        contentView.addSubview(likeButton)
        contentView.addSubview(mallLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(priceLabel)
    }
    
    override func configureLayout() {
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
    }
    
    override func configureView() {
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
    
    // 검색 결과일 때 데이터 세팅
    func configureCell(data: Shopping?, query: String) {
        guard let data else { return }
        
        // MARK: - Kingfisher -> Data(contentsOf) 방식으로 교체해보기
//        mainImageView.kf.setImage(with: data.imageUrl)
        DispatchQueue.global().async {
            do {
                let imageData = try Data(contentsOf: data.imageUrl!)
                DispatchQueue.main.async {
                    self.mainImageView.image = UIImage(data: imageData)
                }
            } catch {
                print(error)
            }
        }
        
        mallLabel.text = data.mallName
        
        titleLabel.text = data.encodedString
        let fullText = titleLabel.text ?? ""
        let attribtuedString = NSMutableAttributedString(string: fullText)
        let range = (fullText as NSString).range(of: query)
        attribtuedString.addAttribute(.backgroundColor, value: MyColor.orange, range: range)
        titleLabel.attributedText = attribtuedString
        
        priceLabel.text = data.price
    }
    
    // 장바구니 목록일 때 데이터 세팅
    func configureCell(data: Basket) {
        mainImageView.kf.setImage(with: data.imageUrl)
        
        mallLabel.text = data.mallName
        
        titleLabel.text = data.encodedString
        let fullText = titleLabel.text ?? ""
        let attribtuedString = NSMutableAttributedString(string: fullText)
        let range = (fullText as NSString).range(of: "")
        attribtuedString.addAttribute(.backgroundColor, value: MyColor.orange, range: range)
        titleLabel.attributedText = attribtuedString
        
        priceLabel.text = data.price
    }
    
    func configureButton(isSelected: Bool) {
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

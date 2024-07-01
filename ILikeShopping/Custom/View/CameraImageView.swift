//
//  CameraImageView.swift
//  ILikeShopping
//
//  Created by 김성민 on 6/13/24.
//

import UIKit
import SnapKit

final class CameraImageView: UIView {
    
    let camera = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(camera)
        
        camera.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }
        
        camera.contentMode = .scaleAspectFit
        camera.image = MyImage.camera
        camera.tintColor = MyColor.white
        
        backgroundColor = MyColor.orange
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        clipsToBounds = true
        layer.cornerRadius = frame.width / 2
    }
}

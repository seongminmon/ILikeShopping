//
//  UIImage+.swift
//  ILikeShopping
//
//  Created by 김성민 on 6/27/24.
//

import UIKit

extension UIImage {
    static func bindingImage(_ imageName: String) -> UIImage {
        return UIImage(named: imageName) ?? UIImage()
    }
}

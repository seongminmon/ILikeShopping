//
//  ReuseIdentifier.swift
//  ILikeShopping
//
//  Created by 김성민 on 6/14/24.
//

import UIKit

private protocol ReuseIdentifierProtocol: AnyObject {
    static var identifier: String { get }
}

extension UICollectionViewCell: ReuseIdentifierProtocol {
    static var identifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell: ReuseIdentifierProtocol {
    static var identifier: String {
        return String(describing: self)
    }
}

//
//  CollectionViewDesign.swift
//  ILikeShopping
//
//  Created by 김성민 on 6/27/24.
//

import UIKit

enum CollectionViewDesign {
    
    static func collectionViewLayout(sectionSpacing: CGFloat, cellSpacing: CGFloat, cellCount: CGFloat) -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.width - 2 * sectionSpacing - (cellCount-1) * cellSpacing
        layout.itemSize = CGSize(width: width / cellCount, height: width / cellCount)
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = cellSpacing
        layout.minimumLineSpacing = cellSpacing
        layout.sectionInset = UIEdgeInsets(top: sectionSpacing, left: sectionSpacing, bottom: sectionSpacing, right: sectionSpacing)
        return layout
    }
    
}

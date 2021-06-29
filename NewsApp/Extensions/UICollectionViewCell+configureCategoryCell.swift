//
//  UICollectionViewCell+configureCategoryCell.swift
//  NewsApp
//
//  Created by SERGEY VOROBEV on 25.06.2021.
//

import UIKit

extension UICollectionViewCell {
    func configureCategoryCellView() {
        layer.cornerRadius = 10
        backgroundColor = UIColor(named: "CategoryCellBackground")
    }
}

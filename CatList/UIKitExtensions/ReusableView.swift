//
//  ReusableView.swift
//  CatList
//
//  Created by Nitesh Tak on 27/7/19.
//  Copyright © 2019 Gini. All rights reserved.
//

import Foundation

import UIKit

protocol ReusableView: class {}

extension ReusableView where Self: UIView {
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
}

extension UICollectionViewCell: ReusableView {}

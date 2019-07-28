//
//  LoadingFooterView.swift
//  CatList
//
//  Created by Nitesh Tak on 29/7/19.
//  Copyright © 2019 Gini. All rights reserved.
//

import UIKit

class LoadingFooterView: UICollectionReusableView, NibLoadableView, ReusableView {
    
    @IBOutlet weak var loader: UIActivityIndicatorView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func startAnimate() {
        loader.isHidden = false
        loader.startAnimating()
    }
    
    func stopAnimate() {
        loader.isHidden = true
        loader.stopAnimating()
    }
    
}

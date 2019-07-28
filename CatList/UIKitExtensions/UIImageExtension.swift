//
//  UIImageExtension.swift
//  CatList
//
//  Created by Nitesh Tak on 27/7/19.
//  Copyright © 2019 Gini. All rights reserved.
//

import UIKit

extension UIImage {
    
    enum FilterPhotoEffect: String {
        case noir = "CIPhotoEffectNoir", mono = "CIPhotoEffectMono", tonal = "CIPhotoEffectTonal"
    }
    
    static func image(with color: UIColor?) -> UIImage? {
        guard let color = color else { return nil }
        let r = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(r.size)
        let context = UIGraphicsGetCurrentContext()!
        context.setFillColor(color.cgColor)
        context.fill(r)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    func image(with filter: FilterPhotoEffect) -> UIImage {
        let currentFilter = CIFilter(name: filter.rawValue)
        let context = CIContext(options: nil)
        currentFilter!.setValue(CIImage(image: self), forKey: kCIInputImageKey)
        let output = currentFilter!.outputImage
        let cgimg = context.createCGImage(output!,from: output!.extent)
        let processedImage = UIImage(cgImage: cgimg!)
        return processedImage
    }
}


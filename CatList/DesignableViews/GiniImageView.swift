//
//  GiniImageView.swift
//  CatList
//
//  Created by Nitesh Tak on 27/7/19.
//  Copyright © 2019 Gini. All rights reserved.
//

import UIKit
import SDWebImage

class GiniImageView: GiniDesignableView {

    @IBInspectable
    var image: UIImage? = nil {
        didSet {
            imageLayer.contents = image?.cgImage
            if useDashedBorder {
                hasDashedBorder = image == nil
            }
        }
    }
    
    var imageURL: URL? = nil {
        willSet {
            cancelImageLoad(forKey: .image)
        }
        didSet {
            guard let url = imageURL else {
                image = placeholderImage
                return
            }
            loadImage(atURL: url, forKey: LoadKey.image.rawValue) { [weak self] image in
                self?.image = image ?? self?.placeholderImage
            }
        }
    }
    
    private let imageLayer = CALayer()
    private var useDashedBorder = false
    
    @IBInspectable var placeholderImage: UIImage? = UIImage(named: "placeholderAvatar") {
        didSet {
            image = image ?? placeholderImage
        }
    }
    
    @IBInspectable var placeholderFillColor: UIColor? = nil {
        didSet {
            placeholderImage = UIImage.image(with: placeholderFillColor)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        isOpaque = false
        imageLayer.contentsGravity = CALayerContentsGravity.resizeAspectFill
        imageLayer.masksToBounds = true
        layer.insertSublayer(imageLayer, at: 0)
    }
    
    deinit {
        cancelLoading()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        useDashedBorder = hasDashedBorder
    }
    
    override func layoutSublayers(of aLayer: CALayer) {
        
        if isRound {
            cornerRadius = min(bounds.width, bounds.height) / 2.0
        }
        
        super.layoutSublayers(of: aLayer)
        if aLayer == layer {
            imageLayer.frame = aLayer.bounds.insetBy(dx: borderWidth / 2.0, dy: borderWidth / 2.0)
        }
    }
    
    @IBInspectable
    var isRound: Bool = false  {
        didSet {
            setNeedsLayout()
        }
    }
    
    override var cornerRadius: CGFloat {
        didSet {
            imageLayer.cornerRadius = cornerRadius
        }
    }
    
    // MARK: - Image loading
    
    private enum LoadKey: String {
        case image = "image"
    }
    
    private func cancelImageLoad(forKey key: LoadKey) {
        sd_cancelImageLoadOperation(withKey: key.rawValue)
    }
    
    func cancelLoading() {
        cancelImageLoad(forKey: .image)
    }

}

extension GiniImageView: ImageLoader {}

protocol ImageLoader {}

extension ImageLoader where Self: UIView {
    func loadImage(atURL loadURL: URL, forKey key: String, completion: @escaping (UIImage?)->()) {
        cancelImageLoad(forKey: key)
        let manager = SDWebImageManager.shared
        
        // try and load directly from the cache
        let cacheKey = manager.cacheKey(for: loadURL)
        manager.imageCache.containsImage(forKey: cacheKey, cacheType: .all) { [weak self] type in
            switch type {
            case .disk, .memory:
                manager.imageCache.queryImage(forKey: cacheKey, context: nil) { image, _, _ in
                    completion(image)
                }
            default:
                let operation = manager.loadImage(with: loadURL, options: [SDWebImageOptions.retryFailed],
                                                  progress: { _,_,_ in },
                                                  completed: { image, _, _, _, finished, _ in
                                                    DispatchQueue.main.async(execute: {
                                                        completion(image)
                                                    })
                })
                
                self?.sd_setImageLoad(operation, forKey: key)
            }
        }
    }
    
    func cancelImageLoad(forKey key: String) {
        sd_cancelImageLoadOperation(withKey: key)
    }
}

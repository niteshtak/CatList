//
//  GiniDesignableView.swift
//  CatList
//
//  Created by Nitesh Tak on 27/7/19.
//  Copyright © 2019 Gini. All rights reserved.
//

import UIKit

class GiniDesignableView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private let borderLayer = CAShapeLayer()
    
    private func commonInit() {
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.lineCap = CAShapeLayerLineCap.round
        borderLayer.lineJoin = CAShapeLayerLineJoin.round
        layer.addSublayer(borderLayer)
    }
    
    override func didAddSubview(_ subview: UIView) {
        super.didAddSubview(subview)
        
        // move borderlayer to the top
        borderLayer.removeFromSuperlayer()
        layer.addSublayer(borderLayer)
    }
    
    override func layoutSublayers(of aLayer: CALayer) {
        super.layoutSublayers(of: aLayer)
        if aLayer == layer {
            borderLayer.frame = aLayer.bounds
            updatePath()
        }
    }
    
    private func updatePath() {
        let rect = bounds.insetBy(dx: borderWidth / 2.0, dy: borderWidth / 2.0)
        borderLayer.path = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).cgPath
    }
    
    @IBInspectable
    var hasDashedBorder: Bool = false {
        didSet {
            borderLayer.lineDashPattern = hasDashedBorder ? [3, 4] : nil
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get { return borderLayer.lineWidth }
        set { borderLayer.lineWidth = newValue }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            guard let color = borderLayer.strokeColor else { return nil }
            return UIColor(cgColor: color)
        }
        set {
            borderLayer.strokeColor = newValue?.cgColor
        }
    }
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            updatePath()
        }
        
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            guard let color = layer.shadowColor else { return nil }
            return UIColor(cgColor: color)
        }
        set {
            layer.shadowColor = newValue?.cgColor
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var shadowOffsetY: CGFloat {
        get {
            return layer.shadowOffset.height
        }
        set {
            layer.shadowOffset.height = newValue
        }
    }

}

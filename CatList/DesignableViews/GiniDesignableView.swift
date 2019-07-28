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

@IBDesignable
class GiniDesignableButton: UIButton {
    
    private let borderLayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        originalTintColor = tintColor
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
    var selectedTextColor: UIColor? = nil {
        didSet {
            updateBackground()
        }
    }
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    override var backgroundColor: UIColor? {
        didSet {
            updateBackground()
        }
    }
    
    @IBInspectable
    var disabledBackgroundColor: UIColor? = nil {
        didSet {
            updateBackground()
        }
    }
    
    @IBInspectable
    var selectedBackgroundColor: UIColor? = nil {
        didSet {
            updateBackground()
        }
    }
    
    @IBInspectable
    var selectedTintColor: UIColor? = nil {
        didSet {
            updateBackground()
        }
    }
    
    private var originalTintColor: UIColor!
    
    override var isSelected: Bool {
        didSet {
            updateBackground()
        }
    }
    
    func updateBackground() {
        guard let _ = window else { return }
        setBackgroundImage(UIImage.image(with: backgroundColor), for: .normal)
        setBackgroundImage(UIImage.image(with: disabledBackgroundColor), for: .disabled)
        setBackgroundImage(UIImage.image(with: selectedBackgroundColor), for: .selected)
        setTitleColor(selectedTextColor, for: .selected)
        tintColor = (isSelected ? selectedTintColor : originalTintColor) ?? originalTintColor
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        updateBackground()
    }
}

class GiniShadowButton: UIButton {
    
    private var shadowLayer: CAShapeLayer!
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        if shadowLayer == nil {
            shadowLayer = CAShapeLayer()
            shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: layer.cornerRadius).cgPath
            shadowLayer.fillColor = backgroundColor?.cgColor
            
            shadowLayer.shadowColor = UIColor.black.cgColor
            shadowLayer.shadowPath = shadowLayer.path
            shadowLayer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            shadowLayer.shadowOpacity = 0.2
            shadowLayer.shadowRadius = 2
            
            layer.insertSublayer(shadowLayer, below: nil)
        }
    }
}

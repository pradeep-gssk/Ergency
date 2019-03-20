//
//  EGButton.swift
//  Ergency
//
//  Created by Guduru, Pradeep(AWF) on 1/28/19.
//  Copyright © 2019 Guduru, Pradeep(AWF). All rights reserved.
//

import UIKit

@objc protocol EGButtonDelegate {
    @objc optional func openButton(_ button: EGButton)
    @objc optional func closeButton(_ button: EGButton)
}


@IBDesignable
class EGButton: UIView {

    var delegate:EGButtonDelegate?
    var fabTitleColor : UIColor?
    var highLightColor : UIColor?
    var originalColor : UIColor?
    var overLayView : EGOverLayView!
    
    var buttonLayer : EGButtonLayer!
    var isHide : Bool = true
    
    var buttonCells : EGButtonCell?
    
    var items : [EGButtonCell] = []
    
    var plusColor: UIColor = UIColor.black {
        didSet{
            self.buttonLayer?.plusColor = plusColor
        }
    }
    
    public init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 55, height: 55))
        backgroundColor = UIColor.orange
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.buttonLayer = EGButtonLayer(bg: self.backgroundColor)
        self.originalColor = self.backgroundColor
        self.backgroundColor = UIColor.clear
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.6
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.addSublayer(self.buttonLayer)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 55, height: 55)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.buttonLayer?.frame = self.bounds
        self.invalidateIntrinsicContentSize()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.highLightColor = self.originalColor
        self.buttonLayer.backgroundColor = UIColor.white.withAlphaComponent(0.5).cgColor//self.highLightColor?.white(rate: 0.7).cgColor
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.buttonLayer?.backgroundColor = self.originalColor?.cgColor

        guard self.items.count > 0 else {
            return
        }
        
        if (self.isHide) {
            self.openButton()
        } else {
            self.closeButton()
        }
    }
    
    fileprivate func openButton() {
        self.isHide = false
        self.overLayView = EGOverLayView()
        self.superview?.insertSubview(self.overLayView, belowSubview:self)
        self.overLayView.addTarget(self, action: #selector(EGButton.closeButton), for: .touchUpInside)
        UIView.animate(withDuration: 0.3) {
            self.layer.transform = CATransform3DMakeRotation(CGFloat(-Double.pi/4), 0.0, 0.0, 1)
            self.overLayView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        }
        
        for item in self.items {
            self.overLayView.addSubview(item)
        }
        
        self.popAnimation(show: true)
        self.delegate?.openButton?(self)
    }
    
    @objc func closeButton() {
        UIView.animate(withDuration: 0.3) {
            self.layer.transform = CATransform3DMakeRotation(0, 0.0, 0.0, 1)
            self.overLayView.backgroundColor = UIColor.clear
        }
        
        self.popAnimation(show: false)
        self.delegate?.closeButton?(self)
    }
    
    fileprivate func popAnimation(show: Bool) {
        var delay = 0.0
        if show {
            for (index,item) in items.enumerated() {
                item.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y - self.frame.height * CGFloat(index+1) , width: self.frame.width, height: self.frame.height)
                item.transform = CGAffineTransform.init(scaleX: 0.0, y: 0.0)
                UIView.animate(withDuration: 0.3, delay: delay, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: UIView.AnimationOptions(), animations: {
                    item.transform = CGAffineTransform.identity
                    item.alpha = 1
                }, completion: nil)
                delay += 0.15
            }
        }
        else {
            for (index,item) in items.reversed().enumerated() {
                UIView.animate(withDuration: 0.2, delay: delay, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: [], animations: {
                    
                    item.transform = CGAffineTransform.init(scaleX: 0.1, y: 0.1)
                    item.alpha = 0
                }, completion: { (finish) in
                    if index == self.items.count-1 && !show {
                        self.isHide = true
                        self.overLayView.removeFromSuperview()
                    }
                    item.transform = CGAffineTransform.identity
                })
                delay += 0.15
            }
        }
    }
    
    open func add(color: UIColor = UIColor.clear, title: String? = nil, image: UIImage? = nil, handle: ((EGButtonCell)->Void)? = nil) {
        let item = EGButtonCell()
        item.buttonItemColor = color
        item.icon = image
        item.backgroundColor = UIColor.clear
        item.alpha = 0
        item.title = title
        item.titleColor = self.fabTitleColor ?? UIColor.white
        item.actionCloure = handle
        item.actionButton = self
        self.items.append(item)
    }
}

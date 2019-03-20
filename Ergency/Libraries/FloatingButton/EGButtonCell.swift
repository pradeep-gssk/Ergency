//
//  EGButtonCell.swift
//  Ergency
//
//  Created by Guduru, Pradeep(AWF) on 1/28/19.
//  Copyright © 2019 Guduru, Pradeep(AWF). All rights reserved.
//

import UIKit

class EGButtonCell: UIView {

    weak var actionButton: EGButton?
    fileprivate let circleLayer = CAShapeLayer()
    fileprivate let tintLayer = CAShapeLayer()
    let circlePath = UIBezierPath(roundedRect: CGRect(x: 16, y: 0, width: 46, height: 46), cornerRadius: 20)
    
    var actionCloure: ((EGButtonCell) -> Void)?
    
    var originColor: UIColor?
    open var buttonItemColor: UIColor = UIColor.clear {
        didSet {
            circleLayer.fillColor = buttonItemColor.cgColor
            originColor? = buttonItemColor
        }
    }
    
    open var titleColor: UIColor = UIColor.white {
        didSet {
            titleLabel.textColor = titleColor
        }
    }
    
    var _titleLabel: UILabel? = nil
    open var titleLabel: UILabel {
        get {
            if _titleLabel == nil {
                _titleLabel = UILabel()
                _titleLabel?.textColor = titleColor
                addSubview(_titleLabel!)
            }
            return _titleLabel!
        }
    }
    
    open var title: String? = nil {
        didSet {
            titleLabel.text = title
            titleLabel.sizeToFit()
            titleLabel.frame.origin.x = -titleLabel.frame.size.width
            titleLabel.frame.origin.y = 21-titleLabel.frame.size.height/2
        }
    }
    
    var _iconImageView: UIImageView? = nil
    open var iconImageView: UIImageView {
        get {
            if _iconImageView == nil {
                _iconImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
                _iconImageView?.contentMode = UIView.ContentMode.scaleAspectFill
                addSubview(_iconImageView!)
            }
            return _iconImageView!
        }
    }
    
    open var icon: UIImage? = nil {
        didSet {
            iconImageView.image = icon
        }
    }
    
    override var frame: CGRect{
        didSet{
            _iconImageView?.center = CGPoint(x: self.frame.width/2, y: self.frame.height/3.2)
        }
    }
    
    public init() {
        super.init(frame:CGRect.zero)
        self.creatCircle()
        self.createShadow()
        self.createLabelShadow()
//        self.addLongPress()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    fileprivate func addLongPress() {
//        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(EGButtonCell.longPressed(_:)))
//        self.addGestureRecognizer(longPress)
//    }
//
//    @objc fileprivate func longPressed(_ longPress: UILongPressGestureRecognizer) {
//        if longPress.state == UIGestureRecognizer.State.ended {
//            tintLayer.removeFromSuperlayer()
//            actionCloure?(self)
//            actionButton?.closeButton()
//            circleLayer.fillColor = originColor?.cgColor
//        }
//        else {
//            print("came here")
//        }
//
//    }
    
    fileprivate func creatCircle() {
        circleLayer.path = circlePath.cgPath
        circleLayer.fillColor = buttonItemColor.cgColor
        originColor = buttonItemColor
        layer.addSublayer(circleLayer)
    }
    
    fileprivate func creatLayer() {
        tintLayer.path = circlePath.cgPath
        tintLayer.fillColor = UIColor.white.withAlphaComponent(0.5).cgColor
        layer.addSublayer(tintLayer)
    }
    
    fileprivate func createShadow() {
        circleLayer.shadowOffset = CGSize(width: 0, height: 0)
        circleLayer.shadowOpacity = 1
    }
    
    fileprivate func createLabelShadow() {
        titleLabel.layer.shadowOffset = CGSize(width: 1, height: 1)
        titleLabel.layer.shadowRadius = 2
        titleLabel.layer.shadowColor = UIColor.black.cgColor
        titleLabel.layer.shadowOpacity = 0.5
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.creatLayer()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        tintLayer.removeFromSuperlayer()
        actionCloure?(self)
        actionButton?.closeButton()
//        if let touch = touches.first{
//            if touch.tapCount == 1 {
//
//            }
//        }
        circleLayer.fillColor = originColor?.cgColor
    }
}

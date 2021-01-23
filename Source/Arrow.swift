//
//  arrow.swift
//
//  Created by magesh on 30/11/20.
//

import UIKit

class Arrow: UIView {
    
    var color = UIColor.white {
        didSet {
            setNeedsDisplay()
        }
    }
    
    func getArrowBodyPath(frame: CGRect) -> CGPath {
        let width = frame.width
        let height = frame.height
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: width * 0.82, y: 0))
        bezierPath.addCurve(to: .init(x: width/2, y: height * 0.9), controlPoint1: CGPoint(x: width * 0.8, y: height * 0.34), controlPoint2: CGPoint(x: width * 0.4, y: height * 0.3))
            
        return bezierPath.cgPath
    }
    
    func getArrowHeadPath(frame: CGRect) -> CGPath {
        let width = frame.width
        let height = frame.height
        let bezier2Path = UIBezierPath()
        bezier2Path.move(to: CGPoint(x: width * 0.44, y: height * 0.84))
        bezier2Path.addLine(to: CGPoint(x: width/2, y: height))
        bezier2Path.addLine(to: CGPoint(x: width * 0.56, y: height * 0.84))
        return bezier2Path.cgPath
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup(frame: frame)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.sublayers?.removeAll()
        setup(frame: frame)
    }

    func setup(frame: CGRect){
        let body = CAShapeLayer()
        body.path = getArrowBodyPath(frame: frame)
        body.strokeColor = color.cgColor
        body.lineWidth = 2
        body.fillColor = UIColor.clear.cgColor
        body.strokeEnd = 0
        

        let head = CAShapeLayer()
        head.path = getArrowHeadPath(frame: frame)
        head.strokeColor = color.cgColor
        head.lineWidth = 2
        head.fillColor = UIColor.clear.cgColor
        head.strokeEnd = 0
    
    
        let bodyAnimation = CABasicAnimation(keyPath: "strokeEnd")
        bodyAnimation.fromValue = 0
        bodyAnimation.toValue = 1
        bodyAnimation.duration = 0.6
        bodyAnimation.isRemovedOnCompletion = false
        bodyAnimation.fillMode = .forwards
        body.add(bodyAnimation, forKey: "BODY_ANIMATION")
        
        let headAnimation = CABasicAnimation(keyPath: "strokeEnd")
        headAnimation.fromValue = 0
        headAnimation.toValue = 1
        headAnimation.duration = 0.6
        headAnimation.isRemovedOnCompletion = false
        headAnimation.fillMode = .forwards
        head.add(headAnimation, forKey: "HEAD_ANIMATION")
        
        
        layer.addSublayer(head)
        layer.addSublayer(body)
    }
    
}

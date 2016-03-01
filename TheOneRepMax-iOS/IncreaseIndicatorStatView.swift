//
//  IncreaseIndicatorStatView.swift
//  TheOneRepMax
//
//  Created by Developer on 2/29/16.
//  Copyright © 2016 JwitApps. All rights reserved.
//

import UIKit

import ORMKitiOS

class IncreaseIndicatorStatView: SimpleStatStackView {
    
    let containerView = IndicatorView()
    
    override init(stats: ORSoloStats) {
        super.init(stats: stats)
        
        distribution = .Fill
        
        containerView.setContentCompressionResistancePriority(260, forAxis: .Vertical)
        
        removeArrangedSubview(detailLabel)
        
        addArrangedSubview(containerView)
        
        update()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func update() {
        super.update()
        
        titleLabel.text = "Progressing"
    }

}



class IndicatorView: UIView {
    
    let drawingLayer = CAShapeLayer()
    
    var heightConstraint: NSLayoutConstraint!
    
    let indicatorHeight: CGFloat = 30.0
    
    init() {
        super.init(frame: CGRect.zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        heightConstraint = heightConstraint ?? heightAnchor.constraintEqualToConstant(indicatorHeight)
        
        [heightConstraint].forEach {
            $0.priority = 990
            $0.active = true
        }
        

        layer.addSublayer(drawingLayer)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        drawX()
    }
    
    func drawX() {
        let viewSize = layer.frame.size
        
        
        let checkPath = UIBezierPath()
        
        let xPath = UIBezierPath()
        let lineWidth: CGFloat = 5
        
        let xDimensions = CGSize(width: indicatorHeight - lineWidth, height: indicatorHeight)
        
        checkPath.moveToPoint(CGPoint(x: lineWidth, y: viewSize.height*(2/3)))
        checkPath.addLineToPoint(CGPoint(x: viewSize.width/2, y: viewSize.height - lineWidth))
        checkPath.addLineToPoint(CGPoint(x: viewSize.width - lineWidth, y: lineWidth))
        
        xPath.moveToPoint(CGPoint(x: viewSize.width/2 - xDimensions.width/2, y: lineWidth))
        xPath.addLineToPoint(CGPoint(x: viewSize.width/2 + xDimensions.width/2, y: viewSize.height - lineWidth))
        xPath.moveToPoint(CGPoint(x: viewSize.width/2 + xDimensions.width/2, y: lineWidth))
        xPath.addLineToPoint(CGPoint(x: viewSize.width/2 - xDimensions.width/2, y: viewSize.height - lineWidth))
        
        drawingLayer.path = xPath.CGPath
        drawingLayer.strokeColor = UIColor.darkGrayColor().CGColor
        drawingLayer.lineWidth = lineWidth
        
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = 2
        animation.fromValue = 0
        animation.toValue = 1
        
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        drawingLayer.strokeEnd = 1
        
        drawingLayer.addAnimation(animation, forKey: "animatedDraw")
    }
    
   
}

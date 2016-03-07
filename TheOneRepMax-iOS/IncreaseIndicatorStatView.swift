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
    
    let indicatorView = IndicatorView()
    
    override init(stats: ORSoloStats) {
        super.init(stats: stats)

        removeArrangedSubview(detailLabel)
        
        addArrangedSubview(indicatorView)
        
        update()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func update() {
        super.update()
        
        titleLabel.text = "Progressing?"
        
        if let recentEntries = stats.entries().sortedByReverseDate[safe: 0...1] {
            
            let latestEntry = recentEntries[0]
            let olderEntry = recentEntries[1]
            
            if latestEntry.max.integerValue > olderEntry.max.integerValue {
                indicatorView.symbol = .Check
            } else if latestEntry.max.integerValue < olderEntry.max.integerValue {
                indicatorView.symbol = .X
            }
            
        }
        
    }

}

class IndicatorView: UIView {
    
    enum IndicatorSymbol {
        case X, Check
    }
    
    // Contains all animated drawing
    let drawingLayer = CAShapeLayer()
    
    // Ensures vertical space for indicator
    var heightConstraint: NSLayoutConstraint!
    
    let indicatorHeight: CGFloat = 30.0
    let indicatorLineWidth: CGFloat = 3.0
    
    var symbol: IndicatorSymbol = .X {
        didSet { setNeedsDisplay() }
    }
    
    init() {
        super.init(frame: CGRect.zero)
        
        setupViewConstraints()
        
        layer.addSublayer(drawingLayer)
    }
    
    func setupViewConstraints() {
        translatesAutoresizingMaskIntoConstraints = false

        heightConstraint = heightConstraint ?? heightAnchor.constraintEqualToConstant(indicatorHeight)
        
        heightConstraint.priority = 990
        heightConstraint.active = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Drawing functions must be called from here to ensure that the view's frame has been calculated before any drawing begins
    override func layoutSubviews() {
        super.layoutSubviews()
        
        switch symbol {
        case .X:
            drawX()
        case .Check:
            drawCheck()
        }
    }
    
    func drawX() {
        let viewSize = layer.frame.size
        
        let indicatorDimensions = CGSize(width: indicatorHeight - indicatorLineWidth, height: indicatorHeight)
        
        let topLeft = CGPoint(x: viewSize.width/2 - indicatorDimensions.width/2, y: indicatorLineWidth)
        let topRight = CGPoint(x: viewSize.width/2 + indicatorDimensions.width/2, y: indicatorLineWidth)
        let bottomLeft = CGPoint(x: viewSize.width/2 - indicatorDimensions.width/2, y: viewSize.height - indicatorLineWidth)
        let bottomRight = CGPoint(x: viewSize.width/2 + indicatorDimensions.width/2, y: viewSize.height - indicatorLineWidth)
        
        let path = UIBezierPath()

        path.moveToPoint(topLeft)
        path.addLineToPoint(bottomRight)
        path.moveToPoint(topRight)
        path.addLineToPoint(bottomLeft)
        
        drawPath(path.CGPath)
        drawingLayer.strokeColor = UIColor.redColor().CGColor
    }
    
    func drawCheck() {
        let viewSize = layer.frame.size
        
        let indicatorDimensions = CGSize(width: indicatorHeight, height: indicatorHeight)
        
        let leftEnd = CGPoint(x: viewSize.width/2 - indicatorDimensions.width/3, y: indicatorDimensions.height*(1/2))
        let bottom = CGPoint(x: viewSize.width/2, y: indicatorDimensions.height)
        let rightEnd = CGPoint(x: viewSize.width/2 + indicatorDimensions.width/2 - indicatorLineWidth, y: 0)
        
        let path = UIBezierPath()

        path.moveToPoint(leftEnd)
        path.addLineToPoint(bottom)
        path.addLineToPoint(rightEnd)
        
        drawPath(path.CGPath)
        drawingLayer.strokeColor = UIColor.greenColor().CGColor
    }
    
    func drawPath(path: CGPath) {
        drawingLayer.path = path
        drawingLayer.fillColor = UIColor.clearColor().CGColor
        drawingLayer.lineWidth = indicatorLineWidth
        drawingLayer.strokeEnd = 1
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = 2
        animation.fromValue = 0
        animation.toValue = 1
        
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        drawingLayer.addAnimation(animation, forKey: "animatedDraw")
    }
   
}

//
//  NumberScrollerView.swift
//  TheOneRepMax
//
//  Created by Developer on 12/22/15.
//  Copyright © 2015 JwitApps. All rights reserved.
//

import UIKit

class PercentageScrollerView: UIStackView {

    var max: Int = 0
    
    var valueLabels = [PercentageView]()
    
    var delegates = [NumberScrollerDelegate]()
    
    init(max: Int) {
        self.max = max
        
        let percentages = [5, 10, 15, 20, 25, 30, 35, 40, 45,
                            50, 55, 60, 65, 70, 75, 80, 85, 90, 95]
        
        let percentageValueLabels = percentages.map {
            return PercentageView(percentage: $0, max: max, displayResult: false)
        }
        
        let dividerLabel = UILabel()
        dividerLabel.text = "•"
        dividerLabel.font = UIFont(name: dividerLabel.font!.fontName, size: 15)
        
        var allSubviews: [UIView] = [dividerLabel]
        
        for valueLabel in percentageValueLabels {
            allSubviews.append(valueLabel)
            
            let dividerLabel = UILabel()
            dividerLabel.text = "•"
            dividerLabel.font = UIFont(name: dividerLabel.font!.fontName, size: 15)
            
            allSubviews.append(dividerLabel)
        }

        
        super.init(arrangedSubviews: allSubviews)
        
        self.axis = .Horizontal
        self.distribution = .EqualSpacing
        
        valueLabels = percentageValueLabels

    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            
            let location = touch.locationInView(self)

            for view in valueLabels where view.frame.contains(location) {
                callbackNumberSelected(percentageView: view)
                
                view.toggleMagnification()
            }
            
        }
    }
    
    func addDelegate(delegate: NumberScrollerDelegate) {
        delegates.append(delegate)
    }
    
    func callbackNumberSelected(percentageView percentageView: PercentageView) {
        for delegate in delegates {
            delegate.numberSelected(percentageView: percentageView)
        }
    }

}

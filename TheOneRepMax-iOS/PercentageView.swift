//
//  PercentageView.swift
//  TheOneRepMax
//
//  Created by Developer on 12/22/15.
//  Copyright © 2015 JwitApps. All rights reserved.
//

import UIKit

class PercentageView: FocusResizingLabel {

    var percentage = 0
    var max = 0
    
    var displayResult = false
    
    init(percentage: Int, max: Int, displayResult: Bool) {
        self.percentage = percentage
        self.max = max
        self.displayResult = displayResult
        
        super.init()
        
        let percentageFraction = CGFloat(percentage) / 100
        let result = Int(percentageFraction * CGFloat(max))
        
        if displayResult {
            self.text = "\(percentage)% | \(result)"
        } else {
            self.text = "\(percentage)"
        }
        
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}

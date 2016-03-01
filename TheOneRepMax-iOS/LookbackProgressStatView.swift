//
//  EstimatedProgressStatView.swift
//  TheOneRepMax
//
//  Created by Developer on 2/13/16.
//  Copyright © 2016 JwitApps. All rights reserved.
//

import UIKit

import ORMKitiOS

class LookbackProgressStatView: SimpleStatStackView {
    
    var dayLookback: Int = 0

    init(stats: ORSoloStats, dayLookback: Int) {
        self.dayLookback = dayLookback
        
        super.init(stats: stats)
        
        update()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update() {
        super.update()
        
        titleLabel.text = "Last \(dayLookback) Days"
        detailLabel.text = "--- lbs."
        
        if let lookbackProgress = stats.dayLookback(numberOfDays: dayLookback) {
            
            let lookbackDate = NSDate().dateByAddingTimeInterval(Double(-dayLookback*24*60*60))
            
            
            if let estimatedMax = stats.estimatedMax(targetDate: lookbackDate),
                let currentEntry = stats.currentEntry {
                
                print(stats.percentageIncrease(firstValue: estimatedMax, secondValue: currentEntry.max.integerValue))
                
            }
            
            detailLabel.text = "\(Int(lookbackProgress)) lbs."
        }
        
    }
    
}
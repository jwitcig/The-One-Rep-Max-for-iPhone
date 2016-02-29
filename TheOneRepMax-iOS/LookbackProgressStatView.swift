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
            
            detailLabel.text = "\(Int(lookbackProgress)) lbs."
        }
        
    }
    
}
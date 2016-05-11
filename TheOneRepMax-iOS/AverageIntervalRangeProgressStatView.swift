//
//  AverageIntervalRangeProgress.swift
//  TheOneRepMax
//
//  Created by Developer on 2/18/16.
//  Copyright © 2016 JwitApps. All rights reserved.
//

import UIKit



class AverageIntervalRangeProgressStatView: SimpleStatStackView {
    
    var interval = 0
    var dateRange: (NSDate, NSDate)?
    
    init(stats: ORSoloStats, interval: Int, dateRange specifiedDateRange: (NSDate, NSDate)? = nil) {
        super.init(stats: stats)
        
        self.interval = interval
        
        dateRange = specifiedDateRange ?? stats.dateRangeOfEntries()
        
        update()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update() {
        super.update()
        
        titleLabel.text = "Average \(interval) Day Progress"
        detailLabel.text = "--- lbs."
        
        guard let selectedDateRange = dateRange else { return }
        
        if let (averageProgress, _) = stats.averageProgress(dateRange: selectedDateRange, dayInterval: interval) {
            let numberFormatter = NSNumberFormatter()
            numberFormatter.roundingMode = .RoundDown
            numberFormatter.maximumFractionDigits = 1
            
            if let progressString = numberFormatter.stringFromNumber(NSNumber(float: averageProgress)) {
            
                detailLabel.text = "\(progressString) lbs."
            }
            
        }
    }
    
}

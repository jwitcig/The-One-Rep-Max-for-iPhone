//
//  SinceLastEntryStatPanel.swift
//  TheOneRepMax
//
//  Created by Developer on 2/13/16.
//  Copyright © 2016 JwitApps. All rights reserved.
//

import UIKit

import ORMKitiOS

class SinceLastEntryStatView: SimpleStatStackView {

    convenience init(stats: ORSoloStats) {
        self.init(frame: CGRect.zero)
        
        self.stats = stats
        
        update()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update() {
        super.update()
        
        titleLabel.text = "Last Entry"
        detailLabel.text = "---"
        
        if let daysSinceEntry = stats.daysSinceLastEntry {
            guard daysSinceEntry != 0 else {
                detailLabel.text = "Today"
                return
            }
            
            var pluralizedSuffix = "Days Ago"
            
            if daysSinceEntry == 1 {
                pluralizedSuffix = "Day Ago"
            }
            detailLabel.text = "\(daysSinceEntry) \(pluralizedSuffix)"
        }
    }
    
}

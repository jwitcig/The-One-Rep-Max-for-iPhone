//
//  SinceLastEntryStatPanel.swift
//  TheOneRepMax
//
//  Created by Developer on 2/13/16.
//  Copyright © 2016 JwitApps. All rights reserved.
//

import UIKit



class SinceLastEntryStatView: SimpleStatStackView {

    override init(stats: ORSoloStats) {
        super.init(stats: stats)
        
        update()
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

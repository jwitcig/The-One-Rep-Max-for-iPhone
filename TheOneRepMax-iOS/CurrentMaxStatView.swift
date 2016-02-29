//
//  CurrentMaxStatView.swift
//  TheOneRepMax
//
//  Created by Developer on 2/9/16.
//  Copyright © 2016 JwitApps. All rights reserved.
//

import UIKit

import ORMKitiOS

class CurrentMaxStatView: SimpleStatStackView {

    override init(stats: ORSoloStats) {
        super.init(stats: stats)
        
        update()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func update() {
        super.update()
        
        titleLabel.text = "Current Max"
        detailLabel.text = "--- lbs."
        
        if let latestEntry = stats.entries().sortedByReverseDate.first {
            detailLabel.text = "\(latestEntry.max.integerValue) lbs."
        }
    }
    
}
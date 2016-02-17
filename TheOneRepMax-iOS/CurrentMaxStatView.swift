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
        
        titleLabel.text = "Current Max"
        detailLabel.text = "--- lbs."
        
        if let latestEntry = stats.entries().sortedByReverseDate.first {
            detailLabel.text = "\(latestEntry.max.integerValue) lbs."
        }
    }
    
}
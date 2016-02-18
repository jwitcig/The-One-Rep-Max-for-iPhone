//
//  NoLiftSelectedStatView.swift
//  TheOneRepMax
//
//  Created by Developer on 2/17/16.
//  Copyright © 2016 JwitApps. All rights reserved.
//

import UIKit

import ORMKitiOS

class NoLiftSelectedStatView: SimpleStatStackView {
    
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
        
        titleLabel.text = "No Lift Selected"
        detailLabel.text = "Select a lift in the filter"
       
    }
    
}

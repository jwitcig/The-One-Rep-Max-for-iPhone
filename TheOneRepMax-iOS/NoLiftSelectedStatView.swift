//
//  NoLiftSelectedStatView.swift
//  TheOneRepMax
//
//  Created by Developer on 2/17/16.
//  Copyright © 2016 JwitApps. All rights reserved.
//

import UIKit



class NoLiftSelectedStatView: SimpleStatStackView {
    
    override init(stats: ORSoloStats) {
        super.init(stats: stats)
        
        update()
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

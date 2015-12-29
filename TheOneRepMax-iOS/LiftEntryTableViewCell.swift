//
//  LiftEntryTableViewCell.swift
//  TheOneRepMax
//
//  Created by Developer on 12/17/15.
//  Copyright © 2015 JwitApps. All rights reserved.
//

import UIKit
import ORMKitiOS

class LiftEntryTableViewCell: UITableViewCell {
    
    var entry: ORLiftEntry!
    
    init(style: UITableViewCellStyle, reuseIdentifier: String?, entry: ORLiftEntry) {
        self.entry = entry
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}

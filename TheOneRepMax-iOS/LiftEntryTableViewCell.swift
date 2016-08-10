//
//  LiftEntryTableViewCell.swift
//  TheOneRepMax
//
//  Created by Developer on 12/17/15.
//  Copyright © 2015 JwitApps. All rights reserved.
//

import UIKit


class LiftEntryTableViewCell: UITableViewCell {
    
    var entry: Entry!
    
    init(style: UITableViewCellStyle, reuseIdentifier: String?, entry: Entry) {
        self.entry = entry
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}

//
//  StatPanelRow.swift
//  TheOneRepMax
//
//  Created by Developer on 2/13/16.
//  Copyright © 2016 JwitApps. All rights reserved.
//

import UIKit

class StatPanelRow: UIStackView {
    
    var statPanels = [SimpleStatStackView]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        axis = .Horizontal
        alignment = .Fill
        distribution = .FillProportionally
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func addArrangedSubview(view: UIView) {
        super.addArrangedSubview(view)
        
        if let statPanel = view as? SimpleStatStackView {
            statPanels.append(statPanel)
        }
    }

}

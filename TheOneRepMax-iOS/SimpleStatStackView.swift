//
//  SimpleStatStackView.swift
//  TheOneRepMax
//
//  Created by Developer on 2/9/16.
//  Copyright © 2016 JwitApps. All rights reserved.
//

import UIKit

import ORMKitiOS

enum ProgressItemType {
    case AllLifts, SpecificLift
}

protocol StatPanelItem {
    var progressItemType: ProgressItemType { get set }
}

protocol StatPanel {
    func update()
}

class SimpleStatStackView: UIStackView, StatPanel {

    var stats: ORSoloStats!
    
    var titleLabel = UILabel()
    var detailLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        translatesAutoresizingMaskIntoConstraints = false

        axis = .Vertical

        alignment = .Fill
        distribution = .FillEqually

        let fontDescriptor = titleLabel.font.fontDescriptor().fontDescriptorWithSymbolicTraits(.TraitBold)
        titleLabel.font = UIFont(descriptor: fontDescriptor, size: 0)

        titleLabel.textAlignment = .Center
        detailLabel.textAlignment = .Center

        addArrangedSubview(titleLabel)
        addArrangedSubview(detailLabel)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update() { }
    
}

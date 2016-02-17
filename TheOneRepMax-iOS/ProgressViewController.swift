//
//  ProgressViewController.swift
//  TheOneRepMax
//
//  Created by Developer on 2/9/16.
//  Copyright © 2016 JwitApps. All rights reserved.
//

import UIKit

import ORMKitiOS

class ProgressViewController: ORViewController, DataViewerDelegate {
    
    var dataViewerViewController: DataViewerViewController!
    
    @IBOutlet weak var mainStackView: UIStackView!
    
    var statPanels = [SimpleStatStackView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataViewerViewController.addDelegate(self)
        
        let topRowStackView = StatPanelRow()
        let secondRowStackView = StatPanelRow()
        
        let currentMaxStatPanel = CurrentMaxStatView(stats: session.soloStats)
        let sinceLastEntryStatPanel = SinceLastEntryStatPanel(stats: session.soloStats)
        let recentLookbackStatPanel = LookbackProgressStatView(stats: session.soloStats, dayLookback: 14)
        let threeMonthLookbackStatPanel = LookbackProgressStatView(stats: session.soloStats, dayLookback: 60)
        
        statPanels.append(currentMaxStatPanel)
        statPanels.append(sinceLastEntryStatPanel)
        statPanels.append(recentLookbackStatPanel)
        statPanels.append(threeMonthLookbackStatPanel)
        
        
        topRowStackView.addArrangedSubview(currentMaxStatPanel)
        topRowStackView.addArrangedSubview(createSeparator(orientation: .Vertical))
        topRowStackView.addArrangedSubview(sinceLastEntryStatPanel)
        
        secondRowStackView.addArrangedSubview(recentLookbackStatPanel)
        secondRowStackView.addArrangedSubview(createSeparator(orientation: .Vertical))
        secondRowStackView.addArrangedSubview(threeMonthLookbackStatPanel)
        
        mainStackView.addArrangedSubview(topRowStackView)
        mainStackView.addArrangedSubview(createSeparator(orientation: .Horizontal))
        mainStackView.addArrangedSubview(secondRowStackView)
    }
    
    func selectedLiftDidChange(liftTemplate liftTemplate: ORLiftTemplate?, liftEntries: [ORLiftEntry]) {
        
        session.soloStats.defaultTemplate = liftTemplate
        
        updateStatPanels()
    }
    
    func updateStatPanels() {
        for statPanel in statPanels {
            statPanel.update()
        }
    }
    
    func createSeparator(orientation orientation: Orientation) -> UIView {
        let separator = UIView()
        separator.backgroundColor = UIColor.blackColor()
        
        let horizontalSeparatorHeight = CGFloat(1)
        let verticalSeparatorWidth = CGFloat(1)
        
        var constraint: NSLayoutConstraint!
       
        switch orientation {
            
        case .Horizontal:
            constraint = separator.heightAnchor.constraintEqualToConstant(horizontalSeparatorHeight)
        case .Vertical:
            constraint = separator.widthAnchor.constraintEqualToConstant(verticalSeparatorWidth)
        }
        
        NSLayoutConstraint.activateConstraints([constraint])
        return separator
    }

}

enum Orientation {
    case Horizontal, Vertical
}

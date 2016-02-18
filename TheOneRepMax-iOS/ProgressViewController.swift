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
    
    enum ProgressRowsCollectionType {
        case AllLifts, SpecificLift
    }
    
    var dataViewerViewController: DataViewerViewController!
    
    var simpleHistoryGraphViewController: SimpleHistoryGraphViewController!
    
    @IBOutlet weak var mainStackView: UIStackView!

    var progressRowsCollection = [ProgressRowsCollectionType: [StatPanelRow]]()
    
    var statPanels: [SimpleStatStackView] {
        var allStatPanelRows = [StatPanelRow]()
        
        if let allLiftsRows = progressRowsCollection[.AllLifts] {
            allStatPanelRows.appendContentsOf(allLiftsRows)
        }
        if let specificLiftRows = progressRowsCollection[.SpecificLift] {
            allStatPanelRows.appendContentsOf(specificLiftRows)
        }
        
        var allStatPanels = [SimpleStatStackView]()
        for row in allStatPanelRows {
            allStatPanels.appendContentsOf(row.statPanels)
        }
        return allStatPanels
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let specificLiftFirstRow = StatPanelRow()
        let specificLiftSecondRow = StatPanelRow()
        
        let currentMaxStatPanel = CurrentMaxStatView(stats: session.soloStats)
        let sinceLastEntryStatPanel = SinceLastEntryStatPanel(stats: session.soloStats)
        let recentLookbackStatPanel = LookbackProgressStatView(stats: session.soloStats, dayLookback: 14)
        let threeMonthLookbackStatPanel = LookbackProgressStatView(stats: session.soloStats, dayLookback: 60)
        
        
        specificLiftFirstRow.addArrangedSubview(currentMaxStatPanel)
        specificLiftFirstRow.addArrangedSubview(createSeparator(orientation: .Vertical))
        specificLiftFirstRow.addArrangedSubview(sinceLastEntryStatPanel)
        
        specificLiftSecondRow.addArrangedSubview(recentLookbackStatPanel)
        specificLiftSecondRow.addArrangedSubview(createSeparator(orientation: .Vertical))
        specificLiftSecondRow.addArrangedSubview(threeMonthLookbackStatPanel)
        
        mainStackView.addArrangedSubview(specificLiftFirstRow)
        mainStackView.addArrangedSubview(createSeparator(orientation: .Horizontal))
        mainStackView.addArrangedSubview(specificLiftSecondRow)
        
        let allLiftsFirstRow = StatPanelRow()
        let noLiftSelectedPanel = NoLiftSelectedStatView(stats: session.soloStats)
        
        allLiftsFirstRow.addArrangedSubview(noLiftSelectedPanel)
        mainStackView.addArrangedSubview(allLiftsFirstRow)

        
        progressRowsCollection[.SpecificLift] = [specificLiftFirstRow, specificLiftSecondRow]
        progressRowsCollection[.AllLifts] = [allLiftsFirstRow]

        
        updateRowsCollectionVisibility()
    }
    
    func updateRowsCollectionVisibility() {
        let specificLiftPanelRowsHidden = session.soloStats.defaultTemplate == nil
        let allLiftPanelRowsHidden = !specificLiftPanelRowsHidden
        
        if let rows = progressRowsCollection[.SpecificLift] {
            for row in rows {
                row.hidden = specificLiftPanelRowsHidden
            }
        }
        
        if let rows = progressRowsCollection[.AllLifts] {
            for row in rows {
                row.hidden = allLiftPanelRowsHidden
            }
        }
    }
    
    func selectedLiftDidChange(liftTemplate liftTemplate: ORLiftTemplate?, liftEntries: [ORLiftEntry]) {
        
        session.soloStats.defaultTemplate = liftTemplate
        
        updateStatPanels()
        updateRowsCollectionVisibility()
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SimpleGraphSegue" {
            guard let graphViewController = segue.destinationViewController as? SimpleHistoryGraphViewController else {
                print("'SimpleGraphSegue' identifier used on ViewController class other than SimpleHistoryGraphViewController!")
                return
            }
            simpleHistoryGraphViewController = graphViewController

            dataViewerViewController.addDelegate(graphViewController)

        }
        
        
    }

}

enum Orientation {
    case Horizontal, Vertical
}

//
//  ProgressViewController.swift
//  TheOneRepMax
//
//  Created by Developer on 2/9/16.
//  Copyright © 2016 JwitApps. All rights reserved.
//

import UIKit

import RealmSwift

class ProgressViewController: ORViewController, DataViewerDelegate {
    
    var dataViewerViewController: DataViewerViewController!
    
    @IBOutlet weak var mainStackView: UIStackView!
    
    var statListItemsCollection: [StatListItem] = []
    var statListItemsAllLifts: [StatListItem] {
        return statListItemsCollection.filter { $0.progressItemType == ProgressItemType.AllLifts }
    }
    var statListItemsSpecificLift: [StatListItem] {
        return statListItemsCollection.filter { $0.progressItemType == ProgressItemType.SpecificLift }
    }
    var statPanels: [StatPanel] {
        get {
            var panels = [StatPanel]()
            
            statListItemsCollection.forEach {
                guard let row = $0 as? StatPanelRow else { return }
                panels.appendContentsOf(row.statPanels)
            }
            return panels
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        enableTransparentBackground()

        // Add spacer view to top and bottom of the stackview
        mainStackView.addArrangedSubview(UIView())
        mainStackView.addArrangedSubview(UIView())
        
        
        let specificLiftFirstRow = StatPanelRow()
        let specificLiftSecondRow = StatPanelRow()
        let specificLiftThirdRow = StatPanelRow()
        let specificLiftFourthRow = StatPanelRow()
        specificLiftFirstRow.progressItemType = .SpecificLift
        specificLiftSecondRow.progressItemType = .SpecificLift
        specificLiftThirdRow.progressItemType = .SpecificLift
        specificLiftFourthRow.progressItemType = .SpecificLift
        
        var specificLiftRows = [StatPanelRow]()
        for _ in 0..<4 {
            let row = StatPanelRow()
            row.progressItemType = .SpecificLift
            specificLiftRows.append(row)
        }
        
        let currentMaxStatPanel = CurrentMaxStatView(stats: session.soloStats)
        let sinceLastEntryStatPanel = SinceLastEntryStatView(stats: session.soloStats)
        let recentLookbackStatPanel = LookbackProgressStatView(stats: session.soloStats, dayLookback: 14)
        let threeMonthLookbackStatPanel = LookbackProgressStatView(stats: session.soloStats, dayLookback: 60)
        
        let averageWeeklyProgress = AverageIntervalRangeProgressStatView(stats: session.soloStats, interval: 7)
        
        let increaseIndicatorStatPanel = IncreaseIndicatorStatView(stats: session.soloStats)
        
        specificLiftRows[0].addArrangedSubview(sinceLastEntryStatPanel)

        
        specificLiftRows[1].addArrangedSubview(currentMaxStatPanel)
        specificLiftRows[1].addArrangedSubview(createSeparator(orientation: .Vertical) as! UIView)
        specificLiftRows[1].addArrangedSubview(increaseIndicatorStatPanel)
        
        specificLiftRows[2].addArrangedSubview(recentLookbackStatPanel)
        specificLiftRows[2].addArrangedSubview(createSeparator(orientation: .Vertical) as! UIView)
        specificLiftRows[2].addArrangedSubview(threeMonthLookbackStatPanel)
        
        specificLiftRows[3].addArrangedSubview(averageWeeklyProgress)
        
        
        let allLiftsFirstRow = StatPanelRow()
        allLiftsFirstRow.progressItemType = .AllLifts
        let noLiftSelectedPanel = NoLiftSelectedStatView(stats: session.soloStats)
        
        allLiftsFirstRow.addArrangedSubview(noLiftSelectedPanel)


        let allLiftsRows = [allLiftsFirstRow]
            
        (specificLiftRows + allLiftsRows).forEach { registerStatPanelRow(panelRow: $0) }
    
        updateRowsCollectionVisibility()
    }
    
    func registerStatPanelRow(panelRow panelRow: StatPanelRow) {
        var needsSeparator = true
        
        switch panelRow.progressItemType {
            
        case .SpecificLift:
            needsSeparator = statListItemsSpecificLift.count == 0 ? false : true
            
        case .AllLifts:
            needsSeparator = statListItemsAllLifts.count == 0 ? false : true
        }
        
        if needsSeparator {
            var separator = createSeparator(orientation: .Horizontal)
            separator.progressItemType = panelRow.progressItemType
            
            statListItemsCollection.append(separator)
            
            mainStackView.insertArrangedSubview(separator as! UIView, atIndex: mainStackView.arrangedSubviews.count-1)
        }
        
        statListItemsCollection.append(panelRow)

        mainStackView.insertArrangedSubview(panelRow, atIndex: mainStackView.arrangedSubviews.count-1)
    }
    
    func updateRowsCollectionVisibility() {
        let specificLiftPanelRowsHidden = true
        let statPanelItemsAllLiftsHidden = !specificLiftPanelRowsHidden
        
        statListItemsAllLifts.forEach { ($0 as! UIView).hidden = statPanelItemsAllLiftsHidden }
        statListItemsSpecificLift.forEach { ($0 as! UIView).hidden = specificLiftPanelRowsHidden }
    }
    
    func selectedLiftDidChange(lift lift: LocalLift?, liftEntries: Results<LocalEntry>) {
        updateStatPanels()
        updateRowsCollectionVisibility()
    }
    
    func updateStatPanels() {
        statPanels.forEach { $0.update() }
    }
    
    func createSeparator(orientation orientation: Orientation) -> StatListItem {
        let separator = StatPanelRowSeparator(orientation: orientation)
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
        
        constraint.priority = 990
        NSLayoutConstraint.activateConstraints([constraint])
        return separator as StatListItem
    }

}

enum Orientation {
    case Horizontal, Vertical
}

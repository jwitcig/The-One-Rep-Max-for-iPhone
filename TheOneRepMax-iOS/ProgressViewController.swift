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
    
    @IBOutlet weak var simpleHistoryGraphViewControllerContainer: UIView!
    @IBOutlet weak var simpleHistoryGraphViewControllerContainerHeightConstraint: NSLayoutConstraint!
    
    var simpleHistoryGraphViewController: SimpleHistoryGraphViewController!
    
    @IBOutlet weak var mainStackView: UIStackView!
    
//    var statPanels: [SimpleStatStackView] {
//        var allStatPanelRows = [StatPanelRow]()
//        
//        if let allLiftsRows = progressRowsCollection[.AllLifts] {
//            allStatPanelRows.appendContentsOf(allLiftsRows)
//        }
//        if let specificLiftRows = progressRowsCollection[.SpecificLift] {
//            allStatPanelRows.appendContentsOf(specificLiftRows)
//        }
//        
//        var allStatPanels = [SimpleStatStackView]()
//        for row in allStatPanelRows {
//            allStatPanels.appendContentsOf(row.statPanels)
//        }
//        return allStatPanels
//    }
    
    var statPanelItemsCollection: [StatPanelItem] = []
    var statPanelItemsAllLifts: [StatPanelItem] {
        return statPanelItemsCollection.filter { $0.progressItemType == ProgressItemType.AllLifts }
    }
    var statPanelItemsSpecificLift: [StatPanelItem] {
        return statPanelItemsCollection.filter { $0.progressItemType == ProgressItemType.SpecificLift }
    }
    var statPanels: [StatPanel] {
        get {
            var statPanelList = [StatPanel]()
            for statPanelItem in statPanelItemsCollection
                where statPanelItem is StatPanel {
                statPanelList.append(statPanelItem as! StatPanel)
            }
            return statPanelList
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        enableTransparentBackground()
        
        let specificLiftFirstRow = StatPanelRow()
        let specificLiftSecondRow = StatPanelRow()
        let specificLiftThirdRow = StatPanelRow()
        specificLiftFirstRow.progressItemType = .SpecificLift
        specificLiftSecondRow.progressItemType = .SpecificLift
        specificLiftThirdRow.progressItemType = .SpecificLift
        
        
        let currentMaxStatPanel = CurrentMaxStatView(stats: session.soloStats)
        let sinceLastEntryStatPanel = SinceLastEntryStatView(stats: session.soloStats)
        let recentLookbackStatPanel = LookbackProgressStatView(stats: session.soloStats, dayLookback: 14)
        let threeMonthLookbackStatPanel = LookbackProgressStatView(stats: session.soloStats, dayLookback: 60)
        
        let averageWeeklyProgress = AverageIntervalRangeProgressStatView(stats: session.soloStats, interval: 7)
        
        specificLiftFirstRow.addArrangedSubview(currentMaxStatPanel)
        specificLiftFirstRow.addArrangedSubview(createSeparator(orientation: .Vertical) as! UIView)
        specificLiftFirstRow.addArrangedSubview(sinceLastEntryStatPanel)
        
        specificLiftSecondRow.addArrangedSubview(recentLookbackStatPanel)
        specificLiftSecondRow.addArrangedSubview(createSeparator(orientation: .Vertical) as! UIView)
        specificLiftSecondRow.addArrangedSubview(threeMonthLookbackStatPanel)
        
        specificLiftThirdRow.addArrangedSubview(averageWeeklyProgress)
        
        
        
        let allLiftsFirstRow = StatPanelRow()
        allLiftsFirstRow.progressItemType = .AllLifts
        let noLiftSelectedPanel = NoLiftSelectedStatView(stats: session.soloStats)
        
        allLiftsFirstRow.addArrangedSubview(noLiftSelectedPanel)
        mainStackView.addArrangedSubview(allLiftsFirstRow)

        updateRowsCollectionVisibility()
        
        let specificLiftRows = [specificLiftFirstRow, specificLiftSecondRow, specificLiftThirdRow]
        
        
        let allLiftsRows = [allLiftsFirstRow]
            
        (specificLiftRows + allLiftsRows).forEach { registerStatPanelRow(panelItem: $0) }
        
    }
    
    func registerStatPanelRow(panelItem panelItem: StatPanelItem) {
        var separator = createSeparator(orientation: .Horizontal)
        
        separator.progressItemType = panelItem.progressItemType

        statPanelItemsCollection.append(separator)
        mainStackView.addArrangedSubview(separator as! UIView)
        
        statPanelItemsCollection.append(panelItem)

        if panelItem is UIView {
            mainStackView.addArrangedSubview(panelItem as! UIView)
        }
    }
    
    func updateRowsCollectionVisibility() {
        let specificLiftPanelRowsHidden = session.soloStats.defaultTemplate == nil
        let statPanelItemsAllLiftsHidden = !specificLiftPanelRowsHidden
        
        statPanelItemsAllLifts.forEach { ($0 as! UIView).hidden = statPanelItemsAllLiftsHidden }
        statPanelItemsSpecificLift.forEach { ($0 as! UIView).hidden = specificLiftPanelRowsHidden }
    }
    
    func selectedLiftDidChange(liftTemplate liftTemplate: ORLiftTemplate?, liftEntries: [ORLiftEntry]) {
        
        session.soloStats.defaultTemplate = liftTemplate
        
        updateStatPanels()
        updateRowsCollectionVisibility()
        
        if liftEntries.count == 0 {
            simpleHistoryGraphViewControllerContainerHeightConstraint.constant = 44
        }
    }
    
    func updateStatPanels() {
        statPanels.forEach { $0.update() }
    }
    
    func createSeparator(orientation orientation: Orientation) -> StatPanelItem {
        let separator = ProgressRowSeparator()
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
        return separator as StatPanelItem
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

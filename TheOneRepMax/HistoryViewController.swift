//
//  HistoryViewController.swift
//  TheOneRepMax
//
//  Created by Developer on 6/29/15.
//  Copyright (c) 2015 JwitApps. All rights reserved.
//

import Cocoa
import CloudKit
import ORMKit

class HistoryViewController: ORViewController, CPTScatterPlotDelegate, CPTScatterPlotDataSource {
    
    @IBOutlet weak var liftNameLabel: NSTextField!
    
    @IBOutlet weak var liftEntriesContainer: NSFlippedScrollView!
    @IBOutlet weak var graphHostingView: CPTGraphHostingView!
    var graph: CPTXYGraph?
    typealias plotDataType = [CPTScatterPlotField: Double]
    var plotData = [plotDataType]()
    
    var liftEntries = [ORLiftEntry]()
    
    private let oneDay: Double = 24 * 60 * 60
    
    private var liftTemplate: ORLiftTemplate {
        return self.representedObject as! ORLiftTemplate
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func initGraph(#entries: [ORLiftEntry]) {
        
        // Create graph from theme
        let newGraph = CPTXYGraph(frame: CGRectZero)
        newGraph.applyTheme(CPTTheme(named: kCPTDarkGradientTheme))
        
        self.graphHostingView.hidden = false
        self.graphHostingView.hostedGraph = newGraph
        
        // Paddings
        newGraph.paddingLeft   = 10.0
        newGraph.paddingRight  = 10.0
        newGraph.paddingTop    = 10.0
        newGraph.paddingBottom = 10.0
        
        // Plot space
        let plotSpace = newGraph.defaultPlotSpace as! CPTXYPlotSpace
        let dateRange = self.daysBetweenDate(startDate: entries.first!.date, endDate: entries.last!.date) + 2
        plotSpace.allowsUserInteraction = true
        plotSpace.xRange = CPTPlotRange(location: 0, length: dateRange)
        plotSpace.yRange = CPTPlotRange(location: 0, length: 600.0)
        
        // Axes
        let axisSet = newGraph.axisSet as! CPTXYAxisSet
        
        if let x = axisSet.xAxis {
            x.majorIntervalLength   = 10
            x.minorTicksPerInterval = 0
            x.orthogonalPosition    = 0
        }
        
        if let y = axisSet.xAxis {
            y.majorIntervalLength   = 0.5
            y.minorTicksPerInterval = 5
            y.orthogonalPosition    = 0
            y.delegate = self
        }
        
        // Create a blue plot area
        let boundLinePlot = CPTScatterPlot(frame: CGRectZero)
        let blueLineStyle = CPTMutableLineStyle()
        blueLineStyle.miterLimit    = 1.0
        blueLineStyle.lineWidth     = 3.0
        blueLineStyle.lineColor     = CPTColor.blueColor()
        boundLinePlot.dataLineStyle = blueLineStyle
        boundLinePlot.identifier    = "Blue Plot"
        boundLinePlot.dataSource    = self
        newGraph.addPlot(boundLinePlot)
        
        let fillImage = CPTImage(named:"BlueTexture")
        fillImage.tiled = true
        boundLinePlot.areaFill      = CPTFill(image: fillImage)
        boundLinePlot.areaBaseValue = 0.0
        
        // Add plot symbols
        let symbolLineStyle = CPTMutableLineStyle()
        symbolLineStyle.lineColor = CPTColor.blackColor()
        let plotSymbol = CPTPlotSymbol.ellipsePlotSymbol()
        plotSymbol.fill          = CPTFill(color: CPTColor.blueColor())
        plotSymbol.lineStyle     = symbolLineStyle
        plotSymbol.size          = CGSize(width: 10.0, height: 10.0)
        boundLinePlot.plotSymbol = plotSymbol
        
        // Create a green plot area
        let dataSourceLinePlot = CPTScatterPlot(frame: CGRectZero)
        let greenLineStyle               = CPTMutableLineStyle()
        greenLineStyle.lineWidth         = 3.0
        greenLineStyle.lineColor         = CPTColor.greenColor()
        greenLineStyle.dashPattern       = [5.0, 5.0]
        dataSourceLinePlot.dataLineStyle = greenLineStyle
        dataSourceLinePlot.identifier    = "individual"
        dataSourceLinePlot.dataSource    = self
        
        // Put an area gradient under the plot above
        let areaColor    = CPTColor(componentRed: 0.3, green: 1.0, blue: 0.3, alpha: 0.8)
        let areaGradient = CPTGradient(beginningColor: areaColor, endingColor: CPTColor.clearColor())
        areaGradient.angle = -90.0
        let areaGradientFill = CPTFill(gradient: areaGradient)
        dataSourceLinePlot.areaFill      = areaGradientFill
        dataSourceLinePlot.areaBaseValue = 1.75
        
        // Animate in the new plot, as an example
        dataSourceLinePlot.opacity = 0.0
        newGraph.addPlot(dataSourceLinePlot)
        
        let fadeInAnimation = CABasicAnimation(keyPath: "opacity")
        fadeInAnimation.duration            = 1.0
        fadeInAnimation.removedOnCompletion = false
        fadeInAnimation.fillMode            = kCAFillModeForwards
        fadeInAnimation.toValue             = 1.0
        dataSourceLinePlot.addAnimation(fadeInAnimation, forKey: "animateOpacity")
        
        // Add some initial data
        var contentArray = [plotDataType]()
        
        for i in 0 ..< entries.count {
            let x = self.daysBetweenDate(startDate: entries.first!.date, endDate: entries[i].date)
            let y = entries[i].max
            let dataPoint: plotDataType = [.X: Double(x+1), .Y: Double(y)]
            contentArray.append(dataPoint)
        }
        self.plotData = contentArray
        
        self.graph = newGraph
    }
    
    func daysBetweenDate(#startDate: NSDate, endDate: NSDate) -> Int {
        var calendar = NSCalendar.currentCalendar()
        let cal = NSCalendar.currentCalendar()
        let unit: NSCalendarUnit = .CalendarUnitDay
        let components = cal.components(unit, fromDate: startDate, toDate: endDate, options: nil)
        return components.day
    }
    
    func numberOfRecordsForPlot(plot: CPTPlot) -> UInt {
        return UInt(self.plotData.count)
    }
    
    func numberForPlot(plot: CPTPlot, field fieldEnum: UInt, recordIndex index: UInt) -> AnyObject? {
        
        if let field = CPTScatterPlotField(rawValue: Int(fieldEnum)) {
            let i = Int(index)
            return self.plotData[i][field]
        }
        
       return nil
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        
        self.updateLiftNameLabel(self.liftTemplate.liftName)
        
        self.cloudData.fetchLiftEntries(template: self.liftTemplate) { (response) -> () in
            if response.error == nil {
                
                self.liftEntries = []
                for record in response.results as! [CKRecord] {
                    self.liftEntries.append(ORLiftEntry(record: record))
                }
                
                runOnMainThread {
                    if self.liftEntries.count > 0 {
                        self.displayLiftEntries(self.liftEntries)
                        self.initGraph(entries: self.liftEntries)
                    }
                }
                
            } else {
                println(response.error)
            }
        }
    }
    
    override func viewDidDisappear() {
        self.clearDataDisplays()
    }
    
    func clearDataDisplays() {
        self.liftEntriesContainer.documentView = nil
        self.graph = nil
        self.graphHostingView.hidden = true
    }
    
    func displayLiftEntries(entries: [ORLiftEntry]) {
        self.clearDataDisplays()
        
        var container = NSFlippedView()
        for (i, entry) in enumerate(entries) {
            let topPadding = 0 as CGFloat
            var width = self.liftEntriesContainer.frame.width
            var height = 40 as CGFloat
            var x = 0 as CGFloat
            var y = (height + topPadding) * CGFloat(i)
            var item = LiftEntryTableItem(frame: NSRect(x: x, y: y, width: width, height: height), liftEntry: entry)
            container.addSubview(item)
            container.frame = NSRect(x: 0, y: 0, width: self.liftEntriesContainer.frame.width, height: CGRectGetMaxY(item.frame))
        }
        
        self.liftEntriesContainer.documentView = container
    }
    
    func updateLiftNameLabel(liftName: String) {
        self.liftNameLabel.stringValue = liftName
    }
    
    @IBAction func backPressed(sender: NSButton) {
        if let destination = self.fromViewController {
            self.parentVC.transitionFromViewController(self, toViewController: destination, options: NSViewControllerTransitionOptions.SlideUp, completionHandler: nil)
        }
    }
    
}

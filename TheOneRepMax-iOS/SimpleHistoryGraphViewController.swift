//  SimpleHistoryGraphViewController.swift
//  TheOneRepMax
//
//  Created by Developer on 2/8/16.
//  Copyright © 2016 JwitApps. All rights reserved.
//

import UIKit

import ORMKitiOS

class SimpleHistoryGraphViewController: ORViewController, CPTPlotDataSource {
    
    var historyViewController: HistoryViewController!
    
    @IBOutlet weak var graphHostingView: CPTGraphHostingView!

    typealias plotDataType = [CPTScatterPlotField: Double]
    var plotData = [plotDataType]()
    
    var graph: CPTXYGraph?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func updateGraph(entries entries: [ORLiftEntry]) {
        graphHostingView.userInteractionEnabled = false
        
        // Create graph from theme
        let newGraph = CPTXYGraph(frame: CGRectZero)
        newGraph.applyTheme(CPTTheme(named: kCPTPlainBlackTheme))
        
        kCPTPlainBlackTheme
        newGraph.title = "Last 14 Days"
        let titleStyle = CPTMutableTextStyle()
        titleStyle.color = CPTColor.whiteColor()
        titleStyle.fontSize = 25
        
        newGraph.titleTextStyle = titleStyle
        
        self.graphHostingView.hidden = false
        self.graphHostingView.hostedGraph = newGraph
        
        // Paddings
        newGraph.paddingLeft   = 0
        newGraph.paddingRight  = 0
        newGraph.paddingTop    = 0
        newGraph.paddingBottom = 0
        
        // Plot space
        let plotSpace = newGraph.defaultPlotSpace as! CPTXYPlotSpace
        
        plotSpace.allowsUserInteraction = true
        
        let min = entries.map { $0.max.integerValue }.minElement { $0 < $1 }
        let max = entries.map { $0.max.integerValue }.maxElement { $0 < $1 }
        guard let lowestMax = min, let highestMax = max else  { return }
        
        let maxRange = highestMax - lowestMax
        let rangePadding = 20
        
        plotSpace.xRange = CPTPlotRange(location: 0, length: 16)
        plotSpace.yRange = CPTPlotRange(location: lowestMax - rangePadding, length: maxRange + rangePadding*2)
        
        // Axes
        let axisSet = newGraph.axisSet as! CPTXYAxisSet
        
        if let x = axisSet.xAxis {
            x.majorIntervalLength   = 1
            x.minorTicksPerInterval = 0
            x.orthogonalPosition    = 0
            x.axisConstraints = CPTConstraints(lowerOffset: 0)
        }
        
        if let y = axisSet.yAxis {
            y.majorIntervalLength   = (maxRange + 2 * rangePadding) / 5
            y.minorTicksPerInterval = 5
            y.orthogonalPosition    = 0
            y.delegate = self
        }
        
        // Create a blue plot area
        let boundLinePlot = CPTScatterPlot(frame: CGRectZero)
        let blueLineStyle = CPTMutableLineStyle()
        blueLineStyle.miterLimit    = 1.0
        blueLineStyle.lineWidth     = 3.0
        blueLineStyle.lineColor     = CPTColor.lightGrayColor()
        boundLinePlot.dataLineStyle = blueLineStyle
        boundLinePlot.identifier    = "Blue Plot"
        boundLinePlot.dataSource    = self
        newGraph.addPlot(boundLinePlot)
        
        // Add plot symbols
        let symbolLineStyle = CPTMutableLineStyle()
        symbolLineStyle.lineColor = CPTColor.whiteColor()
        let plotSymbol = CPTPlotSymbol.ellipsePlotSymbol()
        plotSymbol.fill          = CPTFill(color: CPTColor.whiteColor())
        plotSymbol.lineStyle     = symbolLineStyle
        plotSymbol.size          = CGSize(width: 10.0, height: 10.0)
        boundLinePlot.plotSymbol = plotSymbol
        
        // Create a green plot area
        let dataSourceLinePlot = CPTScatterPlot(frame: CGRectZero)
        let greenLineStyle               = CPTMutableLineStyle()
        greenLineStyle.lineWidth         = 3.0
        greenLineStyle.lineColor         = CPTColor.greenColor()
        greenLineStyle.dashPattern       = [5.0, 5.0]
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
        let contentArray: [plotDataType] = entries.map {
            let x = 14 - NSDate.daysBetween(startDate: $0.date, endDate: NSDate())
            let y = $0.max
            let dataPoint: plotDataType = [.X: Double(x+1), .Y: Double(y)]
            return dataPoint
        }
        
        self.plotData = contentArray
        self.graph = newGraph
    }
    
    func numberOfRecordsForPlot(plot: CPTPlot) -> UInt {
        return UInt(self.plotData.count)
    }
    
    func numberForPlot(plot: CPTPlot, field fieldEnum: UInt, recordIndex index: UInt) -> AnyObject? {
        
        guard let field = CPTScatterPlotField(rawValue: Int(fieldEnum)) else { return nil }
        
        let i = Int(index)
        return self.plotData[i][field]
    }
    
    func requestGraphUpdate(entries entries: [ORLiftEntry]) {
        updateGraph(entries: historyViewController.liftEntries)
    }
    
}

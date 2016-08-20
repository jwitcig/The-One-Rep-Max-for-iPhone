//
//  ORSoloStats.swift
//  ORMKit
//
//  Created by Developer on 7/5/15.
//  Copyright (c) 2015 JwitApps. All rights reserved.
//

#if os(iOS)
    import UIKit
#elseif os(OSX)
    import Cocoa
#endif

import RealmSwift

public class ORSoloStats: ORStats {
    
    var userId: String

    public init(userId: String) {
        self.userId = userId
        super.init()
    }
    
    private var _allEntries: [Entry]?
    var allEntries: [Entry] {
        // line below only used to compile, delete it
        let entries = [Entry]()
        self._allEntries = entries.filter{$0.id==userId}
        return self._allEntries!
    }
    
    var currentEntry: Entry? {
        return entries(chronologicalOrder: true).first
    }
    
    var daysSinceLastEntry: Int? {
        return currentEntry?.date.daysBeforeToday()
    }
    
    func entries(chronologicalOrder chronologicalOrder: Bool) -> [Entry] {
        return allEntries.sort{$0.0.date.compare($0.1.date) == .OrderedAscending}
    }
    
    // Gives increase as a percentage of the firstEntry's max
    func percentageIncrease(firstEntry firstEntry: Entry, secondEntry: Entry) -> Float {
        return percentageIncrease(firstValue: firstEntry.max, secondValue: secondEntry.max)
    }
    
    // Gives increase as a percentage of the firstValue
    func percentageIncrease(firstValue firstValue: Int, secondValue: Int) -> Float {
        let difference = Float(secondValue - firstValue)
        return difference / Float(firstValue) * 100
    }
    
    func dateRangeOfEntries() -> (NSDate, NSDate)? {
        let sortedEntries = entries(chronologicalOrder: true)
        if let firstEntryDate = sortedEntries.first?.date,
            let lastEntryDate = sortedEntries.last?.date {
                
                return (firstEntryDate, lastEntryDate)
        }
        return nil
    }
    
    func averageProgress(dateRange customDateRange: (NSDate, NSDate)? = nil, dayInterval: Int? = nil) -> (Float, (NSDate, NSDate))? {
        
        let sortedEntries = entries(chronologicalOrder: true)
        guard let dateRange = customDateRange ?? (sortedEntries.first?.date, sortedEntries.last?.date) as? (NSDate, NSDate) else {
            return nil
        }
        
        let initial = self.estimatedMax(targetDate: dateRange.0)
        let final = self.estimatedMax(targetDate: dateRange.1)
        
        
        let dateRangeSpread = NSDate.daysBetween(startDate: dateRange.0, endDate: dateRange.1)
        let interval = dayInterval ?? dateRangeSpread
        
        if let initialMax = initial, finalMax = final {
            let totalProgress = finalMax - initialMax
            let dateRangeSpread = dateRangeSpread
            let dailyProgress = Float(totalProgress) / Float(dateRangeSpread)
            return (dailyProgress * Float(interval), dateRange)
        }
        return nil
    }
    
    func dayLookback(numberOfDays numberOfDays: Int) -> Float? {
        let today = NSDate()
        let initialDay = today.dateByAddingTimeInterval(Double(-numberOfDays*24*60*60))
        
        return averageProgress(dateRange: (initialDay, today))?.0
    }
    
    func estimatedMax(targetDate targetDate: NSDate) -> Int? {
        
        let entries = self.entries(chronologicalOrder: true)
        
        if let firstEntry = entries.first {
            if targetDate.isBefore(date: firstEntry.date) && abs(targetDate.daysBetween(endDate: firstEntry.date)) <= 3 {
                return firstEntry.max
            }
        }
        if let lastEntry = entries.last {
            if lastEntry.date.isBefore(date: targetDate) && abs(targetDate.daysBetween(endDate: lastEntry.date)) <= 3 {
                return lastEntry.max
            }
        }
        
        for (index, entry) in entries.enumerate() {
            let previousEntry = entry
            let nextEntryIndex = index + 1
            
            guard nextEntryIndex < entries.count else { return nil }
            
            let nextEntry = entries[nextEntryIndex]
            
            guard targetDate.isBetween(firstDate: previousEntry.date, secondDate: nextEntry.date, inclusive: true) else {
                continue
            }
            
            guard !targetDate.isSameDay(date: previousEntry.date) else {
                return previousEntry.max
            }
            
            guard !targetDate.isSameDay(date: nextEntry.date) else {
                return nextEntry.max
            }
            
            let dateRange = NSDate.daysBetween(startDate: previousEntry.date, endDate: nextEntry.date)
            let dateInset = NSDate.daysBetween(startDate: previousEntry.date, endDate: targetDate)
            
            let maxDifference = Float(nextEntry.max) - Float(previousEntry.max)
            
            let dateProportion = Float(dateInset) / Float(dateRange)
            
            return Int(
                round(dateProportion * maxDifference + Float(previousEntry.max))
            )

        }
        return nil
    }
    
}
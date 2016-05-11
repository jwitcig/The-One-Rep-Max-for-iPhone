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

import CoreData

import SwiftTools

public class ORSoloStats: ORStats {
        
    public init(athlete: ORAthlete) {
        self.athlete = athlete
        super.init()
    }
    
    var athlete: ORAthlete
    
    private var _allEntries: [ORLiftEntry]?
    public var allEntries: [ORLiftEntry] {
        let fetchRequest = NSFetchRequest(entityName: ORLiftEntry.entityName)
        fetchRequest.predicate = NSPredicate(format: "%K == %@", "athlete", session.currentAthlete!)
        
        let context = NSManagedObjectContext.contextForCurrentThread()
        
        var managedObjects: [NSManagedObject]?
        do {
            managedObjects = try context.executeFetchRequest(fetchRequest) as? [NSManagedObject]
        } catch let error as NSError {
            print(error)
        }
        
        self._allEntries = managedObjects?.map {
            ORLiftEntry(id: $0.valueForKey("id") as! String )
        }
        
        return self._allEntries ?? []
    }
    
    public var defaultTemplate: ORLiftTemplate?
    
    public var currentEntry: ORLiftEntry? {
        return entries(chronologicalOrder: true).first
    }
    
    public var daysSinceLastEntry: Int? {
        return currentEntry?.date.daysBeforeToday()
    }
    
    public func entries(template liftTemplate: ORLiftTemplate? = nil, chronologicalOrder: Bool) -> [ORLiftEntry] {
        var desiredEntries = self.allEntries
        if let template = liftTemplate ?? defaultTemplate {
            desiredEntries = desiredEntries.filter { $0.liftTemplate == template }
        }
        
        let descriptor = NSSortDescriptor(key: "date", ascending: chronologicalOrder)
        
        desiredEntries = NSArray(array: desiredEntries).sortedArrayUsingDescriptors([descriptor]) as! [ORLiftEntry]
        return desiredEntries
    }
    
    // Gives increase as a percentage of the firstEntry's max
    public func percentageIncrease(firstEntry firstEntry: ORLiftEntry, secondEntry: ORLiftEntry) -> Float {
        return percentageIncrease(firstValue: firstEntry.max, secondValue: secondEntry.max)
    }
    
    // Gives increase as a percentage of the firstValue
    public func percentageIncrease(firstValue firstValue: Int, secondValue: Int) -> Float {
        let difference = Float(secondValue - firstValue)
        return difference / Float(firstValue) * 100
    }
    
    public func dateRangeOfEntries(liftTemplate liftTemplate: ORLiftTemplate? = nil) -> (NSDate, NSDate)? {
        let sortedEntries = entries(template: liftTemplate, chronologicalOrder: true)
        if let firstEntryDate = sortedEntries.first?.date,
            let lastEntryDate = sortedEntries.last?.date {
                
                return (firstEntryDate, lastEntryDate)
        }
        return nil
    }
    
    public func averageProgress(dateRange customDateRange: (NSDate, NSDate)? = nil, dayInterval: Int? = nil, liftTemplate: ORLiftTemplate? = nil) -> (Float, (NSDate, NSDate))? {
        guard let template = liftTemplate ?? defaultTemplate else { return nil }
        
        let sortedEntries = entries(chronologicalOrder: true)
        guard let dateRange = customDateRange ?? (sortedEntries.first?.date, sortedEntries.last?.date) as? (NSDate, NSDate) else {
            return nil
        }
        
        let initial = self.estimatedMax(targetDate: dateRange.0, liftTemplate: template)
        let final = self.estimatedMax(targetDate: dateRange.1, liftTemplate: template)
        
        
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
    
    public func dayLookback(numberOfDays numberOfDays: Int, liftTemplate: ORLiftTemplate? = nil) -> Float? {
        let today = NSDate()
        let initialDay = today.dateByAddingTimeInterval(Double(-numberOfDays*24*60*60))
        
        return averageProgress(dateRange: (initialDay, today), liftTemplate: liftTemplate)?.0
    }
    
    public func estimatedMax(targetDate targetDate: NSDate, liftTemplate: ORLiftTemplate? = nil) -> Int? {
        guard let template = liftTemplate ?? defaultTemplate else { return nil }
        
        let entries = self.entries(template: template, chronologicalOrder: true)
        
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
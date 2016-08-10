//
//  ORMSession.swift
//  ORMKit
//
//  Created by Application Development on 6/13/15.
//  Copyright (c) 2015 JwitApps. All rights reserved.
//

#if os(iOS)
    import UIKit
#elseif os(OSX)
    import Cocoa
#endif

import RealmSwift

import SwiftTools

public protocol ORUserDataChangeDelegate {
    
    func dataWasChanged()
    
}

public class ORSession {
    
    public static var currentSession = ORSession()
    
    public var currentViewController: UIViewController!
    
    private var userDataChangeDelegates = [ORUserDataChangeDelegate]()
    
//    private var _localData: ORLocalData!
//    public var localData: ORLocalData! {
//        get { return _localData }
//        set {
//            self._localData = newValue
//            self._localData.session = self
//        }
//    }
    
//    private var _cloudData: ORCloudData!
//    public var cloudData: ORCloudData! {
//        get { return _cloudData }
//        set {
//            self._cloudData = newValue
//            self._cloudData.session = self
//        }
//    }
    
    private var _soloStats: ORSoloStats!
    public var soloStats: ORSoloStats {
        get { return _soloStats }
        set {
            _soloStats = newValue
            _soloStats.session = self
        }
    }
    
    public init() { }
    
    public func initDefaultData() {
        let realm = try! Realm()
        
        guard realm.objects(LocalLift).count == 0 else {
            print("Default data in place")
            return
        }
        
        try! realm.write {
            generateDefaultLiftTemplates().forEach { realm.add($0) }
        }
    }
    
    func generateDefaultLiftTemplates() -> [LocalLift] {
        var hangCleanTemplate = LocalLift()
        hangCleanTemplate.name = "Hang Clean"
        
        var squatTemplate = LocalLift()
        squatTemplate.name = "Squat"
        
        var benchPressTemplate = LocalLift()
        benchPressTemplate.name = "Bench Press"
        
        var deadLiftTemplate = LocalLift()
        deadLiftTemplate.name = "Dead Lift"
        
        return [hangCleanTemplate, squatTemplate, benchPressTemplate, deadLiftTemplate]
    }
    
    public func addUserDataChangeDelegate(delegate: ORUserDataChangeDelegate) {
        userDataChangeDelegates.append(delegate)
    }
    
    internal func messageUserDataChangeDelegates() {
        userDataChangeDelegates.forEach { $0.dataWasChanged() }
    }
    
}
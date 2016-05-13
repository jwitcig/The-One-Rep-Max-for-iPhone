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

    public var currentAthlete: ORAthlete? {
        get {
            guard let id = self.currentAthleteIdentityID else { return nil }
            
            return try! Realm().objects(ORAthlete).filter("model.id == %@", id).first
        }
        set {
            if let athlete = newValue {
                self.currentAthleteIdentityID = athlete.identityID
            }
        }
    }
    
    private var currentAthleteIdentityID: String?
    
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
        
    public func signInLocally() -> (Bool, ORAthlete?) {
        
        guard let athlete = ORAthlete.getLastAthlete() else {
            
            if let anyAthlete = try! Realm().objects(ORAthlete).first {
                ORAthlete.setCurrentAthlete(anyAthlete)
                return (true, anyAthlete)
            }
            
            return (false, nil)
        }
        
        ORAthlete.setCurrentAthlete(athlete)
        return (true, athlete)
    }
 
    public func initDefaultData() {
        let realm = try! Realm()
        let liftTemplates = realm.objects(ORLiftTemplate).filter("defaultLift == true")
        
        guard liftTemplates.count == 0 else {
            print("Default data in place")
            return
        }
        
        try! realm.write {
            generateDefaultLiftTemplates().forEach { realm.add($0) }
        }
    }
    
    func generateDefaultLiftTemplates() -> [ORLiftTemplate] {
        let hangCleanTemplate = ORLiftTemplate()
        hangCleanTemplate.liftName = "Hang Clean"
        hangCleanTemplate.defaultLift = true
        hangCleanTemplate.liftDescription = "Pull up"
        
        let squatTemplate = ORLiftTemplate()
        squatTemplate.liftName = "Squat"
        squatTemplate.defaultLift = true
        squatTemplate.liftDescription = "Squat down"
        
        let benchPressTemplate = ORLiftTemplate()
        benchPressTemplate.liftName = "Bench Press"
        benchPressTemplate.defaultLift = true
        benchPressTemplate.liftDescription = "Push up"
        
        let deadLiftTemplate = ORLiftTemplate()
        deadLiftTemplate.liftName = "Dead Lift"
        deadLiftTemplate.defaultLift = true
        deadLiftTemplate.liftDescription = "Bend at the knees"
        
        return [hangCleanTemplate, squatTemplate, benchPressTemplate, deadLiftTemplate]
    }
    
    public func addUserDataChangeDelegate(delegate: ORUserDataChangeDelegate) {
        userDataChangeDelegates.append(delegate)
    }
    
    internal func messageUserDataChangeDelegates() {
        userDataChangeDelegates.forEach { $0.dataWasChanged() }
    }
    
}
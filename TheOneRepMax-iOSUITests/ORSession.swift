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

import Firebase
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
    
    public func addUserDataChangeDelegate(delegate: ORUserDataChangeDelegate) {
        userDataChangeDelegates.append(delegate)
    }
    
    internal func messageUserDataChangeDelegates() {
        userDataChangeDelegates.forEach { $0.dataWasChanged() }
    }
    
}
//
//  AppDelegate.swift
//  TheOneRepMax-iOS
//
//  Created by Developer on 9/14/15.
//  Copyright © 2015 JwitApps. All rights reserved.
//

import UIKit
import CoreData

import Firebase
import FirebaseAuth
import RealmSwift

let userInteractiveThread = dispatch_get_global_queue(Int(QOS_CLASS_USER_INTERACTIVE.rawValue), 0)
let userInitiatedThread = dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.rawValue), 0)
let backgroundThread = dispatch_get_global_queue(Int(QOS_CLASS_UNSPECIFIED.rawValue), 0)

func runOnMainThread(block: (()->())) {
    dispatch_async(dispatch_get_main_queue(), block)
}

func runOnUserInteractiveThread(block: (()->())) {
    dispatch_async(userInteractiveThread, block)
}

func runOnUserInitiatedThread(block: (()->())) {
    dispatch_async(userInitiatedThread, block)
}

func runOnBackgroundThread(block: (()->())) {
    dispatch_async(backgroundThread, block)
}

enum OneRepMaxNotificationType {
    enum OneRepMax: String {
        case OneRepMaxDidChange
    }
}

let coreDataStoreName = "SingleViewCoreData.sqlite"

enum Environment {
    case Debug, TestFlight, Release
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {

    var window: UIWindow?
    
    override init() {
        let servicesFileName = NSBundle.mainBundle().infoDictionary!["Google Services File"] as! String
    
        let options = FIROptions(contentsOfFile: NSBundle.mainBundle().pathForResource(servicesFileName, ofType: "plist"))
        FIRApp.configureWithOptions(options)
        
        FIRDatabase.database().persistenceEnabled = true
    }

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        return true
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {

        return true
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        print("received remote notification")
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(application: UIApplication) {

    }
    
}



//  MainViewController.swift
//  TheOneRepMax
//
//  Created by Application Development on 9/20/15.
//  Copyright © 2015 JwitApps. All rights reserved.
//

import CoreData
import UIKit

import Firebase
import FirebaseAuth
import RealmSwift

class MainViewController: ORViewController {

    var shouldAttemptAuthOnReconnect = false
    
    let connectionRef = FIRDatabase.database().referenceWithPath(".info/connected")

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let lift = LocalLift()
//        lift.setValue("_liftID", forKey: "_liftId")
//        
//        let realm = try! Realm()
//        try! realm.write {
//            realm.add(managedObjects.map(createRealmObject), update: true)
//        }
//        
        
        ORSession.currentSession.soloStats = ORSoloStats(userId: "")
        
        if coreDataStoreExists {
            if copyCoreDataToRealm() {
                removeCoreDataStore()
            }
        }
        
        let successBlock: ((FIRUser)->()) = { user in
            self.performSegueWithIdentifier("LoginSegue", sender: self)
        }
        
        connectionRef.observeEventType(.Value, withBlock: { snapshot in
            if let connected = snapshot.value as? Bool where connected {

                guard self.shouldAttemptAuthOnReconnect else { return }
                
                self.attemptAnonymousAuth(successBlock: successBlock)
            }
        })
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        connectionRef.removeAllObservers()
    }
    
    func attemptAnonymousAuth(successBlock successBlock: ((user: FIRUser)->())) {
        FIRAuth.auth()?.signInAnonymouslyWithCompletion({ user, error in
            guard error == nil else {
                
                let alert = UIAlertController(title: nil, message: nil, preferredStyle: .Alert)
                
                var title = "An error has occured😕"
                var message = "Give it another go."
                
                let errorName = error?.userInfo[FIRAuthErrorNameKey] as? String
                if errorName == "ERROR_NETWORK_REQUEST_FAILED" {
                    title = "You're not connected!"
                    message = "Make sure you're connected to the internet to get going!"
                    
                    alert.addAction(UIAlertAction(title: "Ah okay", style: .Default, handler: nil))
                    self.shouldAttemptAuthOnReconnect = true
                }
                
                alert.title = title
                alert.message = message
                self.presentViewController(alert, animated: true, completion: nil)
                return
            }
            
            guard let user = user else { return }
            
            if self.realmStoreExists {
                self.copyRealmToFirebase(user.uid, completionBlock: { success in
                    
                    if success {
                        self.removeRealmStore()
                    }
                })
            }
            
            successBlock(user: user)
        })
    }
    
    override func viewDidAppear(animated: Bool) {
        let loginSuccessBlock = {
            self.performSegueWithIdentifier("LoginSegue", sender: self)
        }
        
        let startLinkBlock = {
            guard let signUpViewController = self.storyboard?.instantiateViewControllerWithIdentifier("SignUpViewController") as? SignUpViewController else {
                return
            }
            signUpViewController.successBlock = loginSuccessBlock
            self.presentViewController(signUpViewController, animated: true, completion: nil)
        }
        
        let proceedAnonymouslyBlock = {
            self.attemptAnonymousAuth(successBlock: { (user) in
                loginSuccessBlock()
            })
        }
        
        let linkageBlock = {
            self.proposeAccountLinkage(selectionBlock: { startLink in
                if startLink {
                    startLinkBlock()
                } else {
                    proceedAnonymouslyBlock()
                }
            })
        }
        
        if let currentUser = FIRAuth.auth()?.currentUser {
            if currentUser.anonymous {
                if self.linkageProposalExpired {
                    linkageBlock()
                } else {
                    proceedAnonymouslyBlock()
                }
            } else {
                loginSuccessBlock()
            }
        } else {
            linkageBlock()
        }
    }
    
    let ProposeAccountLinkingTimestampKey = "ProposeAccountLinkingTimestamp"
    
    var linkageProposalExpired: Bool {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setValue(nil, forKey: ProposeAccountLinkingTimestampKey)
       
        guard let lastPresentedTimestamp = userDefaults.valueForKey(ProposeAccountLinkingTimestampKey) as? Double else {
            return true
        }
        
        let lastPresented = NSDate(timeIntervalSince1970: lastPresentedTimestamp)
        
        // if last presented over 2 days ago
        return NSDate().timeIntervalSinceDate(lastPresented) > 60*60*24 * 2
    }
    
    func proposeAccountLinkage(selectionBlock selectionBlock: (startLink: Bool)->()) {
        let alert = UIAlertController(title: "Secure your data", message: "Linking your data to an email will ensure have everything you need, wherever you need it!", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Secure Now", style: .Default, handler: { action in
            selectionBlock(startLink: true)
        }))
        alert.addAction(UIAlertAction(title: "No Thanks", style: .Default, handler: { action in
            selectionBlock(startLink: false)
        }))
        self.presentViewController(alert, animated: true, completion: nil)
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setValue(NSDate().timeIntervalSince1970, forKey: ProposeAccountLinkingTimestampKey)
        userDefaults.synchronize()
    }
    
    var coreDataStoreExists: Bool {
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent(coreDataStoreName)
        return NSFileManager.defaultManager().fileExistsAtPath(url.path!)
    }
    
    var realmStoreExists: Bool {
        guard let realmPath = Realm.Configuration.defaultConfiguration.fileURL?.path else { return false }
        return NSFileManager.defaultManager().fileExistsAtPath(realmPath)
    }
    
    func removeCoreDataStore() -> Bool {
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent(coreDataStoreName)
        do {
            try NSFileManager.defaultManager().removeItemAtURL(url)
        } catch {
            print(error)
            return false
        }
        return true
    }
    
    func removeRealmStore() -> Bool {
        guard let realmURL = Realm.Configuration.defaultConfiguration.fileURL else { return false }
        
        let realmURLs = [
            realmURL,
            realmURL.URLByAppendingPathExtension("lock"),
            realmURL.URLByAppendingPathExtension("log_a"),
            realmURL.URLByAppendingPathExtension("log_b"),
            realmURL.URLByAppendingPathExtension("note")
        ]
        let manager = NSFileManager.defaultManager()
        for URL in realmURLs {
            do {
                try manager.removeItemAtURL(URL)
            } catch { }
        }
        return true
    }
    
    func setupCoreData() {
        
        let athlete = NSEntityDescription.insertNewObjectForEntityForName("ORAthlete", inManagedObjectContext: managedObjectContext)
        athlete["firstName"] = "jimmy"
        athlete["lastName"] = "johnguys"
        
        let liftTemplates: [NSManagedObject] = ["Hang Clean", "Squat", "Bench Press", "Dead Lift"].map {
            let liftTemplate = NSEntityDescription.insertNewObjectForEntityForName("ORLiftTemplate", inManagedObjectContext: managedObjectContext)
            
            liftTemplate["liftName"] = $0
            liftTemplate["defaultLift"] = true
            liftTemplate["liftDescription"] = "some guyie"
            liftTemplate["creator"] = athlete
            return liftTemplate
        }
        
        let entry = NSEntityDescription.insertNewObjectForEntityForName("ORLiftEntry", inManagedObjectContext: managedObjectContext)
        entry["date"] = NSDate()
        entry["maxOut"] = true
        entry["reps"] = 1
        entry["weightLifted"] = 100
        entry["liftTemplate"] = liftTemplates[0]
        entry["athlete"] = athlete
        
        let entry1 = NSEntityDescription.insertNewObjectForEntityForName("ORLiftEntry", inManagedObjectContext: managedObjectContext)
        entry1["date"] = NSDate()
        entry1["maxOut"] = false
        entry1["reps"] = 2
        entry1["weightLifted"] = 120
        entry1["liftTemplate"] = liftTemplates[1]
        entry1["athlete"] = athlete
        
        do {
            try managedObjectContext.save()
        } catch {
            print(error)
        }
    }
    
    func copyCoreDataToRealm() -> Bool {
        
        func createRealmObject<T: Object>(managedObject managedObject: NSManagedObject, type: T.Type) -> T {
            var object: Object!
            
            switch managedObject.entity.name! {
                
            case "ORLiftTemplate":
                object = LocalLift(value: [
                    "_id": "Lift:\(managedObject.objectID.hashValue)",
                    "_name": managedObject["liftName"] as? String ?? "error_lift_name"
                    ])
                
            case "ORLiftEntry":
                let date = managedObject["date"] as? NSDate ?? NSDate()
                let createdDate = managedObject["date"] as? NSDate ?? NSDate()

                object = LocalEntry(value: [
                    "_id": NSUUID().UUIDString,
                    "_date": Int(date.timeIntervalSince1970),
                    "_createdDate": Int(createdDate.timeIntervalSince1970),
                    "_maxOut": managedObject["maxOut"] as? Bool ?? false,
                    "_reps": managedObject["reps"] as? Int ?? 0,
                    "_weightLifted": managedObject["weightLifted"] as? Int ?? 0,
                    "_categoryId": "Lift:\((managedObject["liftTemplate"]as! NSManagedObject).objectID.hashValue)",
                    "_userId": "",
                    ])
            default:
                break
            }
            return object as! T
        }
        
        let types: [String: Object.Type] = ["ORLiftTemplate": LocalLift.self, "ORLiftEntry": LocalEntry.self]
        
        var managedObjects = [NSManagedObject]()
        
        for (className, realmType) in types {
            let fetchRequest = NSFetchRequest(entityName: className)
            
            do {
                managedObjects += try managedObjectContext.executeFetchRequest(fetchRequest) as! [NSManagedObject]
                
                            } catch {
                print(error)
                return false
            }
            
            let realmObjects = managedObjects.map {
                createRealmObject(managedObject: $0, type: realmType)
            }
            
            let realm = try! Realm()
            try! realm.write {
                realm.add(realmObjects, update: true)
            }
        }
        
        return true
    }
    
    func clearRealm() {
        let realmURL = Realm.Configuration.defaultConfiguration.fileURL!
        let realmURLs = [
            realmURL,
            realmURL.URLByAppendingPathExtension("lock"),
            realmURL.URLByAppendingPathExtension("log_a"),
            realmURL.URLByAppendingPathExtension("log_b"),
            realmURL.URLByAppendingPathExtension("note")
        ]
        let manager = NSFileManager.defaultManager()
        for URL in realmURLs {
            do {
                try manager.removeItemAtURL(URL)
            } catch {
                // handle error
            }
        }
    }

    func copyRealmToFirebase(userID: String, completionBlock: (success: Bool)->()) {
        let firebase = FIRDatabase.database().reference()
        let usersEntriesRef = firebase.child("entries/\(userID)")
        
        // gets Weight Lifting category information
        firebase.child("categories/Weight Lifting").queryOrderedByChild("type").queryEqualToValue("entry").observeSingleEventOfType(.Value, withBlock: { snapshot in
            
            let realm = try! Realm()

            let firebaseLifts = snapshot.children.map{Lift(snapshot: $0 as! FIRDataSnapshot)}
            let localLifts = realm.objects(LocalLift.self)
            
            var transfers = [String: AnyObject]()
            for entry in realm.objects(LocalEntry.self).sorted("_date") {
                
                let date = entry["_date"] as? Int ?? Int(NSDate().timeIntervalSince1970)
                
                var timestamp: Int!
                if let existingTimestamp = entry["_createdDate"] as? Int
                    where existingTimestamp != 0 {
                    timestamp = existingTimestamp
                } else {
                    timestamp = date
                }
                
                let liftID = entry["_categoryId"] as? String ?? "none"
                let localLift = localLifts.filter("_id == %@", liftID).first
                
                guard let firebaseLift = (firebaseLifts.filter{$0.name==localLift?._name}).first else {
                    completionBlock(success: false)
                    return
                }
                
                var fullEntryData = [String: AnyObject]()
                fullEntryData["weight_lifted"] = entry["_weightLifted"] as? Int ?? 0
                fullEntryData["reps"] = entry["_reps"] as? Int ?? 0
                fullEntryData["date"] = date
                fullEntryData["timestamp"] = timestamp
                fullEntryData["formula"] = "epley"
                fullEntryData["entry_type"] = "max"
//                fullEntryData["user_id"] = userID
//                fullEntryData["category_id"] = firebaseLift.id
//                fullEntryData["category_name"] = firebaseLift.name
//                fullEntryData["category_type"] = "Weight Lifting"
                
                let firebaseEntryId = usersEntriesRef.childByAutoId().key
                
//                var recentEntryData = [String: AnyObject]()
//                recentEntryData["reps"] = fullEntryData["reps"]
//                recentEntryData["weight_lifted"] = fullEntryData["weight_lifted"]
//                recentEntryData["date"] = fullEntryData["date"]
//                recentEntryData["category_name"] = fullEntryData["category_name"]
//                recentEntryData["category_type"] = fullEntryData["category_type"]
//                recentEntryData["entry_id"] = entryID
                
//                transfers["recent/\(firebaseLift.id)"] = recentEntryData
                transfers["\(firebaseLift.id)/\(firebaseEntryId)"] = fullEntryData
            }
            
            usersEntriesRef.updateChildValues(transfers) { error, reference in
                completionBlock(success: error == nil)
            }
        })
    }
    
    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.jwitapps.TheOneRepMax_iOS" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle(forClass: ORSession.self).URLForResource("TheOneRepMax", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent(coreDataStoreName)
        
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            let options = [NSMigratePersistentStoresAutomaticallyOption: true,
                           NSInferMappingModelAutomaticallyOption: true]
            
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: options)
            
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            
            dict[NSUnderlyingErrorKey] = error as NSError
            
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(parentContext: nil)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }

}

// LocalEntry exists only to enable the retrieval of data from Realm for migration
class LocalEntry: Object {
    dynamic var _id: String = "Entry:" + NSUUID().UUIDString
    
    dynamic var _date: Int = 0
    dynamic var _createdDate: Int = 0
    dynamic var _maxOut: Bool = false
    dynamic var _reps: Int = 0
    dynamic var _weightLifted: Int = 0
    
    dynamic var _categoryId: String = ""
    dynamic var _userId: String = ""
   
    override static func primaryKey() -> String? {
        return "_id"
    }
}

// LocalLift exists only to enable the retrieval of data from Realm for migration
class LocalLift: Object {
    dynamic var _id = ""
    dynamic var _name = ""
    
    override static func primaryKey() -> String? {
        return "_id"
    }
}



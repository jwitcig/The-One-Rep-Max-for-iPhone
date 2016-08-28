//
//  DataViewerViewController.swift
//  TheOneRepMax
//
//  Created by Developer on 2/8/16.
//  Copyright © 2016 JwitApps. All rights reserved.
//

import Firebase
import FirebaseAuth
import RealmSwift

import SwiftTools

protocol DataViewerDelegate {
    
    var dataViewerViewController: DataViewerViewController! { get set }
    
    func selectedLiftDidChange(lift lift: Lift?, liftEntries: [Entry])
}

class DataViewerViewController: ORViewController, UIPopoverPresentationControllerDelegate {

    @IBOutlet weak var filterBar: UINavigationBar!
    
    var filterView: LiftTableView?
    
    var liftEntries = [Entry]()
    
    var delegates = [DataViewerDelegate]()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Corrects offset for container views' content
        self.edgesForExtendedLayout = .None
        
        presentFilterViewController()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        updateDelegates()
    
        // analytics
        let device = UIDevice.currentDevice()
        let analyticsItems = device.batteryMonitoringEnabled ? ["battery_level": device.batteryLevel] : [String: NSObject]()
        FIRAnalytics.logEventWithName("VIEW_launched_data_viewer", parameters: analyticsItems)
    }
    
    func updateDelegates() {
        updateFilterBar()
        
        guard let userID = FIRAuth.auth()?.currentUser?.uid else { return }
        
        guard let lift = filterView?.selectedLift else { return }
        
        let database = FIRDatabase.database().reference()
        let categoryRef = database.child("entries/\(userID)/\(lift.id)")
        categoryRef.keepSynced(true)
        categoryRef.observeEventType(.Value, withBlock: { snapshot in
            let entries = snapshot.children.map { Entry(snapshot: $0 as! FIRDataSnapshot) }
            
            self.delegates.forEach {
                $0.selectedLiftDidChange(lift: lift, liftEntries: entries)
            }
        })
    }
    
    func updateFilterBar() {
        guard let filterNavigationItem = filterBar.items?[0] else {
            return
        }
        
        guard let selectedLift = filterView?.selectedLift else {
            filterNavigationItem.title = "All Entries"
            return
        }
        
        filterNavigationItem.title = selectedLift.name
    }
    
    var blurView: UIVisualEffectView?
    
    func presentFilterViewController() {
        let blur = UIBlurEffect(style: .Light)
        blurView = UIVisualEffectView(effect: blur)
        blurView?.translatesAutoresizingMaskIntoConstraints = false
        blurView?.alpha = 0
        self.view.addSubview(blurView!)
        
        filterView = LiftTableView.create()
        filterView?.translatesAutoresizingMaskIntoConstraints = false
        filterView?.didSelectLiftBlock = { lift in
            self.updateDelegates()
            
            UIView.animateWithDuration(0.1, animations: { 
                self.blurView?.alpha = 0
            }, completion: { finished in
                self.blurView?.removeFromSuperview()
                self.blurView = nil
            })
        }
        self.view.addSubview(filterView!)
        
        let database = FIRDatabase.database().reference()
        let categoriesRef = database.child("categories/Weight Lifting")
                                     .queryOrderedByChild("type")
                                     .queryEqualToValue("entry")
        categoriesRef.keepSynced(true)
        categoriesRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            self.filterView?.lifts = snapshot.children.map{Lift(snapshot: $0 as! FIRDataSnapshot)}.sort{$0.0.name<$0.1.name}
        })
        
        NSLayoutConstraint.activateConstraints([
            filterView!.widthAnchor.constraintEqualToAnchor(self.view.widthAnchor, multiplier: 0.8),
            filterView!.heightAnchor.constraintEqualToAnchor(self.view.heightAnchor),
            
            filterView!.centerXAnchor.constraintEqualToAnchor(self.view.centerXAnchor),
            filterView!.centerYAnchor.constraintEqualToAnchor(self.view.centerYAnchor),
            
            blurView!.widthAnchor.constraintEqualToAnchor(self.view.widthAnchor),
            blurView!.heightAnchor.constraintEqualToAnchor(self.view.heightAnchor),
            
            blurView!.centerXAnchor.constraintEqualToAnchor(self.view.centerXAnchor),
            blurView!.centerYAnchor.constraintEqualToAnchor(self.view.centerYAnchor),
        ])
        
        UIView.animateWithDuration(0.1) { 
            self.blurView?.alpha = 1
        }
    }
    
    func addDelegate(delegate: DataViewerDelegate) {
        delegates.append(delegate)
    }
    
    @IBAction func filterPressed(button: UIBarButtonItem) {
        presentFilterViewController()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if var destinationViewController = segue.destinationViewController as? DataViewerDelegate {
            destinationViewController.dataViewerViewController = self
            
            addDelegate(destinationViewController)
        }
    }
    
}

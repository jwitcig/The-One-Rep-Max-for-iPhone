//
//  DataViewerViewController.swift
//  TheOneRepMax
//
//  Created by Developer on 2/8/16.
//  Copyright © 2016 JwitApps. All rights reserved.
//

import RealmSwift

import SwiftTools

protocol DataViewerDelegate {
    
    var dataViewerViewController: DataViewerViewController! { get set }
    
    func selectedLiftDidChange(lift lift: LocalLift?, liftEntries: Results<LocalEntry>)
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
        
//        filterViewController?.selectedLiftTemplate = templates.first
        
        presentFilterViewController()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        updateDelegates()
        
        
        let eventClient = AWSMobileClient.sharedInstance.mobileAnalytics.eventClient
        let event = eventClient.createEventWithEventType("View_DataViewer")
        
        let device = UIDevice.currentDevice()
        if device.batteryMonitoringEnabled {
            event.addMetric(device.batteryLevel, forKey: "battery_level")
        }
        
        eventClient.recordEvent(event)
    }
    
    func setupFilterViewController() {
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
//        filterViewController = storyboard.instantiateViewControllerWithIdentifier("FilterPopover") as? FilterPopoverViewController
//        
//        filterViewController?.dataViewerViewController = self
//        
//        filterViewController?.modalPresentationStyle = .FullScreen
    }
    
    func updateDelegates() {
        updateFilterBar()
        
        var liftEntries = try! Realm().objects(LocalEntry)//.filter("_userId == %@", "")
        
        if let lift = filterView?.selectedLift {
            liftEntries = liftEntries.filter("_categoryId == %@", lift.id)
        }
        
        delegates.forEach {
            $0.selectedLiftDidChange(lift: filterView?.selectedLift, liftEntries: liftEntries)
        }
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
        self.view.addSubview(blurView!)
        
        filterView = LiftTableView.create()
        filterView?.translatesAutoresizingMaskIntoConstraints = false
        filterView?.didSelectLiftBlock = { lift in
            self.updateDelegates()
            
            self.blurView?.removeFromSuperview()
            self.blurView = nil
        }
        self.view.addSubview(filterView!)
        
        NSLayoutConstraint.activateConstraints([
            filterView!.widthAnchor.constraintEqualToAnchor(self.view.widthAnchor, multiplier: 0.8),
            filterView!.heightAnchor.constraintEqualToAnchor(self.view.heightAnchor, multiplier: 0.6),
            
            filterView!.centerXAnchor.constraintEqualToAnchor(self.view.centerXAnchor),
            filterView!.centerYAnchor.constraintEqualToAnchor(self.view.centerYAnchor),
            
            blurView!.widthAnchor.constraintEqualToAnchor(self.view.widthAnchor),
            blurView!.heightAnchor.constraintEqualToAnchor(self.view.heightAnchor),
            
            blurView!.centerXAnchor.constraintEqualToAnchor(self.view.centerXAnchor),
            blurView!.centerYAnchor.constraintEqualToAnchor(self.view.centerYAnchor),
        ])
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

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
    
    func selectedLiftDidChange(liftEntries liftEntries: Results<LocalEntry>)
}

class DataViewerViewController: ORViewController, UIPopoverPresentationControllerDelegate {

    @IBOutlet weak var filterBar: UINavigationBar!
    
    var filterViewController: FilterPopoverViewController?
    
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
    }
    
    func setupFilterViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        filterViewController = storyboard.instantiateViewControllerWithIdentifier("FilterPopover") as? FilterPopoverViewController
        
        filterViewController?.dataViewerViewController = self
        
        filterViewController?.modalPresentationStyle = .Popover
    }
    
    func updateDelegates() {
        updateFilterBar()
        
        var liftEntries = try! Realm().objects(LocalEntry)//.filter("_userId == %@", "")
        
        if let lift = filterViewController?.selectedLift {
            liftEntries = liftEntries.filter("_lift == %@", lift.name)
        }
        
        delegates.forEach {
            $0.selectedLiftDidChange(liftEntries: liftEntries)
        }
    }
    
    func updateFilterBar() {
        guard let filterNavigationItem = filterBar.items?[0] else {
            return
        }
        
        guard let selectedLift = filterViewController?.selectedLift else {
            filterNavigationItem.title = "All Entries"
            return
        }
        
        filterNavigationItem.title = selectedLift.name
    }
    
    func presentFilterViewController() {
        setupFilterViewController()
        
        self.presentViewController(filterViewController!, animated: true, completion: nil)
    }
    
    func addDelegate(delegate: DataViewerDelegate) {
        delegates.append(delegate)
    }
    
    @IBAction func filterPressed(button: UIBarButtonItem) {
        presentFilterViewController()
        
        // configure the Popover presentation controller
        let popController = filterViewController!.popoverPresentationController!
        
        popController.permittedArrowDirections = .Any
        popController.delegate = self
        
        popController.barButtonItem = self.navigationItem.rightBarButtonItem
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if var destinationViewController = segue.destinationViewController as? DataViewerDelegate {
            destinationViewController.dataViewerViewController = self
            
            addDelegate(destinationViewController)
        }
    }
    
}

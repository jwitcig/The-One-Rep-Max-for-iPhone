//
//  DataViewerViewController.swift
//  TheOneRepMax
//
//  Created by Developer on 2/8/16.
//  Copyright © 2016 JwitApps. All rights reserved.
//

import UIKit

import ORMKitiOS

protocol DataViewerDelegate {
    
    var dataViewerViewController: DataViewerViewController! { get set }
    
    func selectedLiftDidChange(liftTemplate liftTemplate: ORLiftTemplate?, liftEntries: [ORLiftEntry])
}

class DataViewerViewController: ORViewController, UIPopoverPresentationControllerDelegate {

    @IBOutlet weak var filterBar: UINavigationBar!
    
    var filterViewController: FilterPopoverViewController?
    
    var liftEntries = [ORLiftEntry]()
    
    var delegates = [DataViewerDelegate]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Corrects offset for container views' content
        self.edgesForExtendedLayout = .None
    }
    
    override func viewWillAppear(animated: Bool) {
        updateDelegates(liftTemplate: filterViewController?.selectedLiftTemplate)
    }
    
    func setupFilterViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        filterViewController = storyboard.instantiateViewControllerWithIdentifier("FilterPopover") as? FilterPopoverViewController
        
        filterViewController?.modalPresentationStyle = .Popover
    }
    
    func updateDelegates(liftTemplate liftTemplate: ORLiftTemplate?) {
        guard let athlete = session.currentAthlete else {
            print("No current athlete!")
            return
        }
        
        let (entries, response) = localData.fetchLiftEntries(athlete: athlete, template: liftTemplate, options: nil)
        
        guard response.success else {
            print("Error in fetching ORLiftEntrys")
            return
        }
        
        for delegate in delegates {
            delegate.selectedLiftDidChange(liftTemplate: liftTemplate, liftEntries: entries)
        }
    }
    
    func updateFilterBar() {
        guard let filterNavigationItem = filterBar.items?[0] else {
            return
        }
        
        guard let selectedTemplate = filterViewController?.selectedLiftTemplate else {
            filterNavigationItem.title = "All Entries"
            return
        }
        
        filterNavigationItem.title = selectedTemplate.liftName
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
        }
    }
    
}
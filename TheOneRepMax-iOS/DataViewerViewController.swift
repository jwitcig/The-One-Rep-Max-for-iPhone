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
        
        let templates = try! Realm().objects(ORLiftTemplate)
        
        filterViewController?.selectedLiftTemplate = templates.first
        
        presentFilterViewController()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        updateDelegates(liftTemplate: filterViewController?.selectedLiftTemplate)
    }
    
    func setupFilterViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        filterViewController = storyboard.instantiateViewControllerWithIdentifier("FilterPopover") as? FilterPopoverViewController
        
        filterViewController?.dataViewerViewController = self
        
        filterViewController?.modalPresentationStyle = .Popover
    }
    
    func updateDelegates(liftTemplate liftTemplate: ORLiftTemplate?) {
        updateFilterBar()
        
        let realm = try! Realm()
        
        guard let athlete = session.currentAthlete else {
            print("No current athlete!")
            return
        }
        
        let athletePredicate = NSPredicate(key: "athlete", comparator: .Equals, value: athlete)
        
        var compoundPredicate: NSCompoundPredicate?
        if let template = liftTemplate {
            let liftTemplatePredicate = NSPredicate(key: "liftTemplate", comparator: .Equals, value: template)
            
            compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [athletePredicate, liftTemplatePredicate])
        }
        
        let finalPredicate = compoundPredicate ?? athletePredicate
        
        let liftEntries = Array(realm.objects(ORLiftEntry).filter(finalPredicate))
        
        for delegate in delegates {
            delegate.selectedLiftDidChange(liftTemplate: liftTemplate, liftEntries: liftEntries)
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
            
            addDelegate(destinationViewController)
        }
    }
    
}

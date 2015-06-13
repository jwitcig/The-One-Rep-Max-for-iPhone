//
//  HomeViewController.swift
//  TheOneRepMax
//
//  Created by Application Development on 6/10/15.
//  Copyright (c) 2015 JwitApps. All rights reserved.
//

import Cocoa
import CloudKit
import ORMKit

class HomeViewController: NSViewController {
    
    @IBOutlet weak var templatesContainerView: NSView!
    
    var parentVC: MainViewController!

    var container: CKContainer!
    var publicDB: CKDatabase!

    var templates: [ORLiftTemplate]?
        
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.parentVC = self.parentViewController! as! MainViewController
        
//        let predicate = NSPredicate(format: "isDefault == 1")
//        let query = ORLiftTemplate.query(predicate: NSPredicate(value: true))
//        self.publicDB.performQuery(query, inZoneWithID: nil) { (templateRecords, error) -> Void in
//            if error == nil {
//                
//                self.templates = []
//                for record in templateRecords as! [CKRecord] {
//                    self.templates!.append(ORLiftTemplate(record: record))
//                }
//                println("displaying \(self.templates)")
//                self.displayTemplates(self.templates!)
//            } else {
//                println(error)
//            }
//        }
        
    }
    
    func displayTemplates(templates: [ORLiftTemplate]) {
        for (i, template) in enumerate(templates) {
            
            var templateButton = LiftTemplateButton(frame: CGRect(), template: template, index: i)
            
            self.templatesContainerView.addSubview(templateButton)
        }
    }
    
    @IBAction func logoutPressed(sender: NSButton) {
        self.parentVC.transitionFromViewController(self, toViewController: self.parentVC.loginVC, options: NSViewControllerTransitionOptions.SlideRight, completionHandler: nil)
    }
    
}

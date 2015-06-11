//
//  HomeViewController.swift
//  TheOneRepMax
//
//  Created by Application Development on 6/10/15.
//  Copyright (c) 2015 JwitApps. All rights reserved.
//

import Cocoa

class HomeViewController: NSViewController {
    
    @IBOutlet weak var templatesContainerView: NSView!
    
    var parentVC: MainViewController!
    
    var templates: [LiftTemplate]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.parentVC = self.parentViewController! as! MainViewController

    }
    
    func takes(some: ModelField) {
        println(some.databaseKey)
    }
    
    func displayTemplates(templates: [LiftTemplate]) {
        for (i, template) in enumerate(templates) {
            
            var templateButton = LiftTemplateButton(frame: CGRect(), template: template, index: i)
            
            self.templatesContainerView.addSubview(templateButton)
        }
    }
    
    @IBAction func logoutPressed(sender: NSButton) {
        self.parentVC.transitionFromViewController(self, toViewController: self.parentVC.loginVC, options: NSViewControllerTransitionOptions.SlideRight, completionHandler: nil)
    }
    
}

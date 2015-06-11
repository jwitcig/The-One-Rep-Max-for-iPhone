//
//  HomeViewController.swift
//  TheOneRepMax
//
//  Created by Application Development on 6/10/15.
//  Copyright (c) 2015 JwitApps. All rights reserved.
//

import Cocoa
import Alamofire

class HomeViewController: NSViewController {
    
    @IBOutlet weak var templatesContainerView: NSView!
    
    var parentVC: MainViewController!
    
    var templates: [LiftTemplate]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.parentVC = self.parentViewController! as! MainViewController
        
//        fetchLiftTemplates()
        
        let user = "jwitcig"
        let password = "540223"
        
        let credential = NSURLCredential(user: user, password: password, persistence: NSURLCredentialPersistence.None)
        
//        let parameters = [LiftEntry.Field.weightLifted.rawValue+"__in": 311]
        Alamofire.request(.GET, "http://localhost:8000/dashboard/lift-entry/", parameters: nil)
            .authenticate(usingCredential: credential)
            .responseJSON { (request, _, json, error) in
                
                if error == nil {
                    println(json!)
                    println(count(json as! [[String: AnyObject]]))
                    
                    self.takes(LiftEntry.Field.weightLifted)
                    self.takes(LiftEntry.Field.reps)

                } else {
                    println(error)
                }
        }
    }
    
    func takes(some: ModelField) {
        println(some.databaseKey)
    }
    
    func fetchLiftTemplates() {
        
        let user = "jwitcig"
        let password = "540223"
        
        let credential = NSURLCredential(user: user, password: password, persistence: NSURLCredentialPersistence.None)
        
        let parameters = ["lift_name": ["Squat", "Bench Press"], "id": [7]]
        Alamofire.request(.GET, "http://localhost:8000/dashboard/lift-template/", parameters: parameters)
            .authenticate(usingCredential: credential)
            .responseJSON { (request, _, json, error) in
                
                if error == nil {
                    self.templates = LiftTemplate.templates(json!)
                    self.displayTemplates(self.templates!)
                } else {
                    println(error)
                }
        }
    
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

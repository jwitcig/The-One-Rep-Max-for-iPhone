//
//  SetupViewController.swift
//  TheOneRepMax
//
//  Created by Developer on 7/5/15.
//  Copyright (c) 2015 JwitApps. All rights reserved.
//

import Cocoa
import CloudKit
import ORMKit

class SetupViewController: ORViewController {
    
    @IBOutlet var optionsScrollView: NSScrollView!
    
    var organization: OROrganization?
    
    let optionViewHeight = 40 as CGFloat
    let optionViewTopPadding = 5 as CGFloat
    
    var optionNumber = 0
    
    var optionViews = [SetupOptionView]()
    
    var options = [String: SetupOption]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initOptionItems()
    }
    
    func initOptionItems() {
        guard let organization = self.organization else { return }
        
        self.cloudData.fetchAthletes(organization: organization) { (athletes, response) in
            guard response.success else { return }
            
            self.localData.save(context: response.currentThreadContext)
            
            let container = NSFlippedView()
            container.addSubview(self.buildOption(key: OROrganization.Fields.orgName.rawValue,
                                                value: self.organization?.orgName,
                                                 type: .Text,
                                         optionContainer: organization,
                                                title: "name"))
            container.addSubview(self.buildOption(key: OROrganization.Fields.orgDescription.rawValue,
                                                value: self.organization?.orgDescription,
                                                 type: .Text,
                                         optionContainer: organization,
                                                title: "description"))
//            container.addSubview(self.buildAthletesOptionView(key: OROrganization.Fields.athletes.rawValue,
//                                                         athletes: athletes,
//                                                     optionContainer: organization,
//                                                            title: "athletes"))
            
            let height =  (self.optionViewHeight + self.optionViewTopPadding) * CGFloat(self.optionNumber)
            container.frame = NSRect(origin: CGPointZero,
                                       size: CGSize(width: self.optionsScrollView.frame.width, height: height))
            
            runOnMainThread {
                self.optionsScrollView.documentView = container
            }
        }
    }
    
    func buildOption(key key: String, value: AnyObject?, type: OROptionType, optionContainer: NSManagedObject, title optionTitle: String? = nil) -> SetupOptionView {
        
        let option = SetupOption(key: key, value: value, holder: optionContainer)
        self.options[key] = option
        
        let origin = NSPoint(x: 0, y: ((self.optionViewHeight + self.optionViewTopPadding) * CGFloat(self.optionNumber)))
        let size = CGSize(width: self.optionsScrollView.frame.width, height: self.optionViewHeight)
        let frame = NSRect(origin: origin, size: size)
        
        let title = optionTitle != nil ? optionTitle! : key
        self.optionNumber += 1
        let optionView = SetupOptionView(frame: frame, title: title, option: option, type: type, organization: self.organization, value: value)
        optionView.parentController = self
        self.optionViews.append(optionView)
      
        return optionView
    }
    
    func buildAthletesOptionView(key key: String, athletes threadedAthletes: [Athlete], optionContainer: NSManagedObject, title optionTitle: String? = nil) -> SetupOptionView {
        
        let title = optionTitle != nil ? optionTitle! : key
        let optionView = self.buildOption(key: key, value: nil, type: .Custom, optionContainer: optionContainer, title: title)
        
        let container = NSFlippedView(frame: NSRect(origin: NSZeroPoint, size: NSSize(width: optionView.frame.width, height: 0 as CGFloat)))
        
        for (i, threadedAthlete) in threadedAthletes.enumerate() {
            let topSpacing = 5 as CGFloat
            let width = container.frame.width * (1/2)
            let height = 30 as CGFloat
            let x = 0 as CGFloat
            let y = (height + topSpacing) * CGFloat(i)
            
            let frame = NSRect(x: x, y: y, width: width, height: height)
            
            let individualContainer = ManagedAthleteView(frame: frame, athlete: threadedAthlete)
//            individualContainer.removeAthleteButton.clickHandlerClosure = {
//                guard let context = self.organization?.managedObjectContext else { return }
//                
//                let unthreadedAthlete = context.crossContextEquivalent(object: threadedAthlete)
//                let unthreadedOrganization = context.crossContextEquivalent(object: self.organization!)
//                unthreadedOrganization.athletes.remove(unthreadedAthlete)
//                self.localData.save(context: context)
//                
//                self.cloudData.syncronizeDataToCloudStore {
//                    print($0.success)
//                }
//            }
            
            container.addSubview(individualContainer)
        }
        
        optionView.optionValue = container
        return optionView
    }
    
    @IBAction func backPressed(sender: NSButton) {
        if let destination = self.fromViewController {
            self.parentVC.transitionFromViewController(self, toViewController: destination, options: .SlideRight, completionHandler: nil)
            
            for (key, option) in self.options {
                option.optionContainer[key] = option.newValue
            }
            
            self.localData.save()
            self.cloudData.syncronizeDataToCloudStore {
                guard $0.success else { return }
                print("updated settings")
            }
        }
    }
    
}

extension NSManagedObject {
    
    subscript(key: String) -> AnyObject? {
        get { return self.valueForKey(key) }
        set { self.setValue(newValue, forKey: key)}
    }
    
}

class SetupOption {
    
    var optionContainer: NSManagedObject
    var key: String
    private var _oldValue: AnyObject?
    var oldValue: AnyObject? { return self._oldValue }
    
    var newValue: AnyObject?
    
    init(key: String, value: AnyObject?, holder: NSManagedObject) {
        self.key = key
        self._oldValue = value
        self.optionContainer = holder
    }
    
}

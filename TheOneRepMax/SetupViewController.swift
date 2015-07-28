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
    
    var options = [SetupOptionView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initOptionItems()
    }
    
    func initOptionItems() {
        if let organization = self.organization {
            self.cloudData.fetchAthletes(organization: organization) { (response) -> () in
                
                if response.success {
                    let athletes = ORAthlete.athletes(records: response.objects)
                    self.localData.save()
                    
                    var container = NSFlippedView()
                    container.addSubview(self.buildOption(title: "name", type: .Text, value: self.organization?.orgName))
                    container.addSubview(self.buildOption(title: "description", type: .Text, value: self.organization?.orgDescription))
                    container.addSubview(self.buildAthletesOptionView(title: "athletes", athletes: athletes))
                    
                    var width = self.optionsScrollView.frame.width * (1/2)
                    var height =  (self.optionViewHeight + self.optionViewTopPadding) * CGFloat(self.optionNumber)
                    
                    container.frame = NSRect(origin: CGPointZero, size: CGSize(width: self.optionsScrollView.frame.width, height: height))
                    
                    runOnMainThread {
                        self.optionsScrollView.documentView = container
                    }
                }
            }
        }
    }
    
    func buildOption(title title: String, type: OROptionType, value: AnyObject?) -> SetupOptionView {
        let origin = NSPoint(x: 0, y: ((self.optionViewHeight + self.optionViewTopPadding) * CGFloat(self.optionNumber)))
        let size = CGSize(width: self.optionsScrollView.frame.width, height: self.optionViewHeight)
        let frame = NSRect(origin: origin, size: size)
        
        self.optionNumber += 1
        var option = SetupOptionView(frame: frame, title: title, type: type, organization: self.organization, value: value)
        option.parentController = self
        self.options.append(option)
        return option
    }
    
    func buildAthletesOptionView(title title: String, athletes: [ORAthlete]) -> SetupOptionView {
        let optionView = self.buildOption(title: title, type: .Custom, value: nil)
        var container = NSFlippedView(frame: NSRect(origin: NSZeroPoint, size: NSSize(width: optionView.frame.width, height: 0 as CGFloat)))
        
        for (i, athlete) in athletes.enumerate() {
            let topSpacing = 5 as CGFloat
            var width = container.frame.width * (1/2)
            var height = 30 as CGFloat
            var x = 0 as CGFloat
            var y = (height + topSpacing) * CGFloat(i)
            
            var individualContainer = NSFlippedView(frame: NSRect(x: x, y: y, width: width, height: height))
            
            width = individualContainer.frame.width * (7/10)
            height = individualContainer.frame.height
            x = 0 as CGFloat
            y = 0 as CGFloat
            var nameLabel = NSLabel(frame: NSRect(x: x, y: y, width: width, height: height))
            nameLabel.stringValue = athlete.fullName
            individualContainer.addSubview(nameLabel)
            
            
            width = individualContainer.frame.width - nameLabel.frame.width
            height = individualContainer.frame.height
            x = CGRectGetMaxX(nameLabel.frame)
            y = 0 as CGFloat
            var removeAthleteButton = NSClosureButton(frame: NSRect(x: x, y: y, width: width, height: height))
            removeAthleteButton.title = "remove"
            removeAthleteButton.bezelStyle = NSBezelStyle.RoundRectBezelStyle
            removeAthleteButton.clickHandlerClosure = {
                self.organization!.athletes.remove(athlete)
                
                let modifyRecordsOperation = CKModifyRecordsOperation(recordsToSave: [self.organization!.record], recordIDsToDelete: nil)
                modifyRecordsOperation.savePolicy = .ChangedKeys
                modifyRecordsOperation
                modifyRecordsOperation.completionBlock = {
                    
                }
                
                self.cloudData.database.addOperation(modifyRecordsOperation)
                
                self.cloudData.save(model: self.organization!) {
                    print($0.success)
                }
            }
            individualContainer.addSubview(removeAthleteButton)
            
            container.addSubview(individualContainer)
        }
        
        optionView.optionValue = container
        return optionView
    }
    
}

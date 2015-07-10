//
//  MessagesViewController.swift
//  TheOneRepMax
//
//  Created by Developer on 7/2/15.
//  Copyright (c) 2015 JwitApps. All rights reserved.
//

import Cocoa
import CloudKit
import ORMKit

class MessagesViewController: ORViewController {
    
    @IBOutlet weak var messagesScrollView: NSClipView!
    
    var messages = [ORMessage]()
    
    var organization: OROrganization {
        get { return self.representedObject as! OROrganization }
        set { self.representedObject = newValue }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear() {
        
        self.messages = Array(self.organization.messages)
        
        // Recent -> Old
        self.messages.sort { $0.createdDate.compare($1.createdDate) == .OrderedDescending }
        self.displayMessages(self.messages)
        
        
        
    }
    
    func displayMessages(messages: [ORMessage]) {
        self.messagesScrollView.documentView?.removeFromSuperview()
        var container = NSFlippedView(frame: self.messagesScrollView.frame)
        
        for (i, message) in enumerate(messages) {
            
            let topPadding = 15 as CGFloat
            let width = container.frame.width
            let height = 50 as CGFloat
            let x = 0 as CGFloat
            let y = (height + topPadding) * CGFloat(i)
            
            var item = MessagesListItem(frame: NSRect(x: x, y: y, width: width, height: height), message: message)
            
            item.clickHandler = { message in
                self.parentVC.viewMessageVC.message = message
                self.parentVC.viewMessageVC.editing = false
                
                if self.parentVC.viewMessageVC.presentingViewController == nil {
                    self.presentViewController(self.parentVC.viewMessageVC, asPopoverRelativeToRect: self.view.frame, ofView: self.view, preferredEdge: NSMaxXEdge, behavior: NSPopoverBehavior.Transient)
                }
            }
            
            container.addSubview(item)
            container.frame = NSRect(x: 0, y: 0, width: container.frame.width, height: CGRectGetMaxY(item.frame))
        }
        
        self.messagesScrollView.documentView = container
    }
    
    @IBAction func newMessagePressed(newMessageButton: NSButton) {
        self.parentVC.viewMessageVC.message = ORMessage()
        self.parentVC.viewMessageVC.editing = true
        
        if self.parentVC.viewMessageVC.presentingViewController == nil {
            self.presentViewController(self.parentVC.viewMessageVC, asPopoverRelativeToRect: self.parentVC.viewMessageVC.view.frame, ofView: newMessageButton, preferredEdge: NSMaxXEdge, behavior: NSPopoverBehavior.Transient)
        }
    }
    
    @IBAction func backPressed(sender: NSButton) {
        self.parentVC.transitionFromViewController(self, toViewController: self.parentVC.ormVC, options: NSViewControllerTransitionOptions.SlideRight, completionHandler: nil)
    }
    
}

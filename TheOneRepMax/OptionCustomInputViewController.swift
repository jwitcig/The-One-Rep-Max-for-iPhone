//
//  OptionCustomInputViewController.swift
//  TheOneRepMax
//
//  Created by Developer on 7/17/15.
//  Copyright (c) 2015 JwitApps. All rights reserved.
//

import Cocoa

class OptionCustomInputViewController: NSViewController {
    
    @IBOutlet weak var customViewContainer: NSScrollView!
    
    var customView: NSView! {
        didSet {
            
            var maxY = 0 as CGFloat
            for subview in self.customView.subviews {
                let y = CGRectGetMaxY(subview.frame)
                
                if y > maxY {
                    maxY = y
                }
            }
            
            let width = self.customViewContainer.frame.width
            let height = maxY
            self.customView.frame = NSRect(origin: NSZeroPoint, size: NSSize(width: width, height: height))
            self.customViewContainer.documentView = self.customView
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

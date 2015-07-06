//
//  OptionTextInputController.swift
//  TheOneRepMax
//
//  Created by Developer on 7/5/15.
//  Copyright (c) 2015 JwitApps. All rights reserved.
//

import Cocoa

class OptionTextInputViewController: NSViewController, NSTextViewDelegate {
    
    @IBOutlet var textView: NSTextView!
    
    var baseTextField: NSTextField!
    
    var textValue: String {
        get {
            if let text = self.textView.string {
                return text
            }
            return ""
        }
        set { self.textView.string = newValue }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func textDidChange(notification: NSNotification) {
        self.baseTextField.stringValue = self.textValue
    }
    
}
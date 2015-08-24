//
//  OptionTextInputController.swift
//  TheOneRepMax
//
//  Created by Developer on 7/5/15.
//  Copyright (c) 2015 JwitApps. All rights reserved.
//

import Cocoa

@IBDesignable
class OptionTextInputViewController: NSViewController, NSTextViewDelegate {
    
    @IBOutlet var textView: NSTextView!
    
    var option: SetupOption!

    var baseTextField: NSLabel!
    
    var textValue: String {
        get {
            if let text = self.textView.string {
                return text
            }
            return ""
        }
        set { self.textView.string = newValue }
    }
    
    func textDidChange(notification: NSNotification) {
        self.baseTextField.stringValue = self.textValue
    }
    
    override func viewDidDisappear() {
        super.viewDidDisappear()
        self.option.newValue = self.textView.string
    }
    
}
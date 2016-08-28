//
//  NewLiftFormView.swift
//  TheOneRepMax
//
//  Created by Developer on 8/24/16.
//  Copyright © 2016 JwitApps. All rights reserved.
//

import UIKit

class NewLiftFormView: UIView {
    
    var saveMaxViewController: SaveMaxViewController? {
        didSet {
            createButton.addTarget(saveMaxViewController, action: #selector(SaveMaxViewController.saveNewLiftPressed(_:)), forControlEvents: .TouchUpInside)
        }
    }
    
    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont(name: textField.font!.fontName, size: 24)
        textField.placeholder = "lift name"
        return textField
    }()
    
    lazy var createButton: UIButton = {
        let createButton = UIButton()
        let attributedString = NSAttributedString(string: "create", attributes: [NSFontAttributeName: UIFont.systemFontOfSize(24)])
        createButton.setAttributedTitle(attributedString, forState: .Normal)
        createButton.translatesAutoresizingMaskIntoConstraints = false
        createButton.setTitle("create", forState: .Normal)
        return createButton
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(textField)
        self.addSubview(createButton)

        NSLayoutConstraint.activateConstraints([
            heightAnchor.constraintEqualToConstant(44),
            
            textField.leadingAnchor.constraintEqualToAnchor(self.leadingAnchor, constant: 20),
            textField.trailingAnchor.constraintEqualToAnchor(self.createButton.leadingAnchor, constant: -20),
            
            createButton.trailingAnchor.constraintEqualToAnchor(self.trailingAnchor, constant: -20),
            
            textField.topAnchor.constraintEqualToAnchor(self.topAnchor),
            createButton.topAnchor.constraintEqualToAnchor(self.topAnchor),
            
            createButton.widthAnchor.constraintEqualToConstant(80),
            
            textField.heightAnchor.constraintEqualToAnchor(self.heightAnchor),
            createButton.heightAnchor.constraintEqualToAnchor(self.heightAnchor),
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

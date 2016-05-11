//
//  ORViewController.swift
//  TheOneRepMax
//
//  Created by Developer on 9/28/15.
//  Copyright © 2015 JwitApps. All rights reserved.
//

import UIKit

public class ORViewController: UIViewController, ORUserDataChangeDelegate {

    var session: ORSession!
    
    let backgroundImageView = UIImageView()
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        self.session = ORSession.currentSession
        self.session.currentViewController = self
        
        session.addUserDataChangeDelegate(self)
        
        let image = UIImage(named: "BackgroundBlur")
        if let backgroundImage = image {
            backgroundImageView.image = backgroundImage
            backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
            self.view.insertSubview(backgroundImageView, atIndex: 0)
            
            NSLayoutConstraint.activateConstraints([
                self.view.leadingAnchor.constraintEqualToAnchor(backgroundImageView.leadingAnchor),
                self.view.trailingAnchor.constraintEqualToAnchor(backgroundImageView.trailingAnchor),
                self.view.topAnchor.constraintEqualToAnchor(backgroundImageView.topAnchor),
                self.view.bottomAnchor.constraintEqualToAnchor(backgroundImageView.bottomAnchor)
            ])
        }
        
    }
    
    func enableTransparentBackground() {
        if backgroundImageView.superview != nil {
            backgroundImageView.removeFromSuperview()
        }
    }
    
    func disableTransparentBackground() {
        if backgroundImageView.superview == nil {
            self.view.insertSubview(backgroundImageView, atIndex: 0)
        }
    }
    
    public func dataWasChanged() { }
    
}

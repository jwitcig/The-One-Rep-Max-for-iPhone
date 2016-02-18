//
//  ORViewController.swift
//  TheOneRepMax
//
//  Created by Developer on 9/28/15.
//  Copyright © 2015 JwitApps. All rights reserved.
//

import UIKit
import ORMKitiOS

public class ORViewController: UIViewController {

    var session: ORSession!
    var localData: ORLocalData!
    
    let backgroundImageView = UIImageView()
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        self.session = ORSession.currentSession
        self.session.currentViewController = self

        self.localData = session.localData
        
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
    
    public override func viewWillAppear(animated: Bool) {
        self.view.backgroundColor = UIColor(red: 147/255, green: 174/255, blue: 255/255, alpha: 1)
    }
    
}

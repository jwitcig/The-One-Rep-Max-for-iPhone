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
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.session = ORSession.currentSession
        self.session.currentViewController = self

        self.localData = session.localData
        
        let image = UIImage(named: "BackgroundBlur")
        if let backgroundImage = image {
            let imageView = UIImageView(image: backgroundImage)
            imageView.frame = self.view.bounds
            
            self.view.insertSubview(imageView, atIndex: 0)
        }
        
    }
    
    public override func viewWillAppear(animated: Bool) {
        self.view.backgroundColor = UIColor(red: 147/255, green: 174/255, blue: 255/255, alpha: 1)
    }
    
}

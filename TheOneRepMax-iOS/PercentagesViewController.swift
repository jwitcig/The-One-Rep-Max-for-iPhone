//
//  PercentagesViewController.swift
//  TheOneRepMax
//
//  Created by Developer on 12/18/15.
//  Copyright © 2015 JwitApps. All rights reserved.
//

import UIKit

protocol NumberScrollerDelegate {
    func numberSelected(percentageView percentageView: PercentageView)
}

class PercentagesViewController: UIViewController {
    
    var homeViewController: HomeViewController {
        return self.parentViewController! as! HomeViewController
    }
    
    var max: Int { return homeViewController.oneRepMax }
    
    @IBOutlet weak var percentageLabel: UILabel!
    @IBOutlet weak var percentLabel: UILabel!
    @IBOutlet weak var wheelContainer: UIView!
    
    var percentageWheel = PercentagesWheel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PercentagesViewController.oneRepMaxDidChange(_:)), name: OneRepMaxNotificationType.OneRepMax.OneRepMaxDidChange.rawValue, object: nil)
        
        homeViewController.controlSwitcherScrollView.userInteractionEnabled = true
        
        percentageWheel.translatesAutoresizingMaskIntoConstraints = false
        percentageWheel.backgroundColor = UIColor.clearColor()
        wheelContainer.addSubview(percentageWheel)
        NSLayoutConstraint.activateConstraints([
            percentageWheel.topAnchor.constraintEqualToAnchor(wheelContainer.topAnchor),
            percentageWheel.bottomAnchor.constraintEqualToAnchor(wheelContainer.bottomAnchor),
            percentageWheel.leadingAnchor.constraintEqualToAnchor(wheelContainer.leadingAnchor),
            percentageWheel.trailingAnchor.constraintEqualToAnchor(wheelContainer.trailingAnchor),
        ])
        
        percentageWheel.percentChangedBlock = { percent in
            self.updatePercentageInfo(percent: percent)
        }
    }

    func oneRepMaxDidChange(notification: NSNotification) {
        updatePercentageInfo(percent: percentageWheel.percent)
    }
    
    func updatePercentageInfo(percent percent: CGFloat) {
        print(percent)
        percentLabel.text = "\(Int(percent*100))%"
        percentageLabel.text = "\(Int(percent * CGFloat(self.max))) lbs."
    }
    
}

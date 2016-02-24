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
    
    @IBOutlet weak var mainStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        populateMainStackView()
        
        mainStackView.spacing = 10
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "oneRepMaxDidChange:", name: OneRepMaxNotificationType.OneRepMax.OneRepMaxDidChange.rawValue, object: nil)
    }
    
    func populateMainStackView() {
        let percentages = [5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60, 65, 70, 75, 80, 85, 90, 95, 100]
        
        for percentage in percentages {
            mainStackView.addArrangedSubview(createPercentageStackView(percentage: percentage))
        }
    }
    
    func createPercentageStackView(percentage percentage: Int) -> UIStackView {
        let percentageFraction = CGFloat(percentage) / 100
        let max = CGFloat(homeViewController.oneRepMax)
        
        let percent = Int(percentageFraction * max)
        
        let percentageLabel = UILabel()
        percentageLabel.textAlignment = .Right
        percentageLabel.text = "\(percentage)%:"
        
        let percentLabel = UILabel()
        percentLabel.textAlignment = .Left
        percentLabel.text = "\(percent)"
        
        let stackView = UIStackView(arrangedSubviews: [percentageLabel, percentLabel])
        stackView.axis = .Horizontal
        stackView.alignment = .Center
        stackView.distribution = .FillEqually
        stackView.spacing = 30
        
        return stackView
    }
    
    func oneRepMaxDidChange(notification: NSNotification) {
        for view in mainStackView.arrangedSubviews {
            view.removeFromSuperview()
        }
        populateMainStackView()
    }
    
}

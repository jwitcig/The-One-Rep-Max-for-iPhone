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

class PercentagesViewController: UIViewController, NumberScrollerDelegate {
    
    var homeViewController: HomeViewController {
        return self.parentViewController! as! HomeViewController
    }
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var percentagesChooserView: PercentageScrollerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        percentagesChooserView = PercentageScrollerView(max: homeViewController.oneRepMax)
        
        
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        
        
        percentagesChooserView.spacing = 10
        percentagesChooserView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(percentagesChooserView)
        
        percentagesChooserView.addDelegate(self)
        
        contentView.addSubview(percentagesChooserView)
        
            
        let viewsDictionary = ["contentView": contentView, "percentagesChooserView": percentagesChooserView]
        
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[percentagesChooserView]-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDictionary))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[percentagesChooserView(55)]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDictionary))
        
        
        scrollView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[contentView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDictionary))
        scrollView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[contentView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDictionary))

    }
    
    func numberSelected(percentageView percentageView: PercentageView) {
        let newPercentageView = PercentageView(percentage: percentageView.percentage, max: percentageView.max, displayResult: true)
        newPercentageView.translatesAutoresizingMaskIntoConstraints = false
        newPercentageView.frame = percentageView.frame
        
        newPercentageView.hidden = true


      
        UIView.animateWithDuration(1.0) {
            newPercentageView.hidden = false
        }
        
        
    }
    
}

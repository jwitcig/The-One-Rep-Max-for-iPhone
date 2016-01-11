//
//  HomeViewController.swift
//  TheOneRepMax
//
//  Created by Developer on 10/21/15.
//  Copyright © 2015 JwitApps. All rights reserved.
//

import UIKit
import ORMKitiOS
import CoreData

class HomeViewController: ORViewController, OneRepMaxDelegate, UITextFieldDelegate, UIScrollViewDelegate {
    
    @IBOutlet weak var ormLabel: UILabel!
    
    @IBOutlet weak var controlScrollView: UIScrollView!
    var controlScrollViewContentView: UIView!
    
    var ormControlsViewController: ORMControlsViewController!
    var percentagesViewController: PercentagesViewController!

    @IBOutlet weak var saveMaxButton: UIButton!
    var saveMaxButtonHiddenConstraint: NSLayoutConstraint!
    var saveMaxButtonVisibleConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var controlSwitcherScrollView: UIScrollView!
    @IBOutlet weak var controlSwitcherScrollViewContentView: UIView!
    
    @IBOutlet var toPercentagesButton: UIButton!
    @IBOutlet var toOneRepMaxButton: UIButton!
    
    var viewControllerSwitcherButtonsConstraintsCollection = [UIButton: NSLayoutConstraint]()
    
    var oneRepMax: Int {
        return ormControlsViewController.oneRepMax
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        saveMaxButtonVisibleConstraint = NSLayoutConstraint(item: self.view, attribute: .CenterX, relatedBy: .Equal, toItem: saveMaxButton, attribute: .CenterX, multiplier: 1, constant: 0)
        
        saveMaxButtonHiddenConstraint = NSLayoutConstraint(item: self.view, attribute: .Trailing, relatedBy: .Equal, toItem: saveMaxButton, attribute: .Trailing, multiplier: 1, constant: -80)
        
        self.view.addConstraint(saveMaxButtonHiddenConstraint)
        
        
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        ormControlsViewController = storyboard.instantiateViewControllerWithIdentifier("ORMControlsViewController") as! ORMControlsViewController
        
        
        percentagesViewController = storyboard.instantiateViewControllerWithIdentifier("PercentagesViewController") as! PercentagesViewController
        
        self.addChildViewController(ormControlsViewController)
        self.addChildViewController(percentagesViewController)
        
        let view = ormControlsViewController.view
        view.translatesAutoresizingMaskIntoConstraints = false
        
        percentagesViewController.view.translatesAutoresizingMaskIntoConstraints = false
        controlScrollViewContentView = UIView()
        

        controlScrollViewContentView.translatesAutoresizingMaskIntoConstraints = false
        controlScrollView.addSubview(controlScrollViewContentView)

        
        
        
        controlScrollView.translatesAutoresizingMaskIntoConstraints = false
        controlScrollViewContentView.translatesAutoresizingMaskIntoConstraints = false
        
        let viewsDictionary = ["controlScrollView": controlScrollView, "contentView": controlScrollViewContentView, "view": view, "duplicate": percentagesViewController.view]
        
        
        controlScrollView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[contentView]|", options: .DirectionLeadingToTrailing, metrics: nil, views:viewsDictionary))
        controlScrollView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[contentView]|", options: .DirectionLeadingToTrailing, metrics: nil, views: viewsDictionary))

        self.addChildViewController(ormControlsViewController)
        controlScrollViewContentView.addSubview(view)
        
        controlScrollView.addConstraint(NSLayoutConstraint(item: controlScrollViewContentView, attribute: .Width, relatedBy: .GreaterThanOrEqual, toItem: controlScrollView, attribute: .Width, multiplier: 1, constant: 0))
        controlScrollView.addConstraint(NSLayoutConstraint(item: controlScrollViewContentView, attribute: .Height, relatedBy: .Equal, toItem: controlScrollView, attribute: .Height, multiplier: 1, constant: 0))

        
        
        controlScrollViewContentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[view]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDictionary))

        
        self.addChildViewController(percentagesViewController)
        controlScrollViewContentView.addSubview(percentagesViewController.view)
        
        let metrics = ["controlPanelWidth": self.view.frame.width]
        controlScrollViewContentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[view(controlPanelWidth)]-0-[duplicate(controlPanelWidth)]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: viewsDictionary))
        
        
        controlScrollViewContentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[duplicate]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDictionary))
        
        ormControlsViewController.addDelegate(self)
        
    
        
        
        
        
        
        let frameSize = controlSwitcherScrollView.bounds.size
        let thinBorderWidth = 1 as CGFloat
        let regularBorderWidth = 2 as CGFloat
        let borderColor = UIColor.blackColor()
        let bottomBorderView = UIView(frame: CGRect(x: 0 as CGFloat, y: frameSize.height - borderWidth, width: frameSize.width*2, height: regularBorderWidth))
        let topBorderView = UIView(frame: CGRect(x: 0, y: 0, width: frameSize.width*2, height: thinBorderWidth))

        topBorderView.backgroundColor = borderColor
        bottomBorderView.backgroundColor = borderColor
        
        
        controlSwitcherScrollView.addSubview(topBorderView)
        controlSwitcherScrollView.addSubview(bottomBorderView)

    }
    
    func updateSaveButtonStatus(oneRepMax: Int) {
        let valid = oneRepMax != 0
        
        saveMaxButton.translatesAutoresizingMaskIntoConstraints = false

        
        if valid {
            self.saveMaxButton.enabled = true
            
            self.view.removeConstraint(saveMaxButtonHiddenConstraint)
            self.view.addConstraint(saveMaxButtonVisibleConstraint)

        } else {
            self.saveMaxButton.enabled = false

            self.view.removeConstraint(saveMaxButtonVisibleConstraint)
            self.view.addConstraint(saveMaxButtonHiddenConstraint)
    
        }
        
        self.saveMaxButton.needsUpdateConstraints()

        UIView.animateWithDuration(1.0) {
            self.saveMaxButton.layoutIfNeeded()
        }
    }
    
    @IBAction func saveMaxPressed(sender: UIButton) {
        
    }
    
    @IBAction func switchSubviewController(button: UIButton) {
        
        var contentOffset: CGPoint!
        
        switch button {
            case toPercentagesButton:
                
            contentOffset = CGPoint(x: controlScrollView.frame.width, y: 0)
            
            case toOneRepMaxButton:
            
            contentOffset = CGPoint(x: 0, y: 0)
            
            
        default:
            fatalError("Fatal Error: Unimplemented")
        }
        
        UIView.animateWithDuration(0.4) {
            self.controlScrollView.contentOffset = contentOffset
            self.controlSwitcherScrollView.contentOffset = contentOffset
        }
    }
    
    func updateORMDisplay(oneRepMax oneRepMax: Int) {
        self.updateSaveButtonStatus(oneRepMax)
        self.ormLabel.text = "\(oneRepMax)"
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SaveMaxSegue" {
            let saveMaxViewController = segue.destinationViewController as! SaveMaxViewController
            
            saveMaxViewController.weightLifted = ormControlsViewController.weightLifted
            saveMaxViewController.reps = ormControlsViewController.reps
        }
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 10
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(row)"
    }
    
    func oneRepMaxDidChange(oneRepMax: Int, weightLifted: Int, reps: Int) {
        updateORMDisplay(oneRepMax: oneRepMax)
        
        updateSaveButtonStatus(oneRepMax)
    }
    
    func enableControlScrollView() {
        controlScrollView.scrollEnabled = true
    }
    
    func disableControlScrollView() {
        controlScrollView.scrollEnabled = false
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        controlScrollView.contentOffset = controlSwitcherScrollView.contentOffset
    }
    
}

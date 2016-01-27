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
    
    @IBOutlet weak var toolbar: UIToolbar!
    var saveToolbar: PullableToolbar!
        
    var viewControllerSwitcherButtonsConstraintsCollection = [UIButton: NSLayoutConstraint]()
    
    var oneRepMax: Int {
        return ormControlsViewController.oneRepMax
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "The One Rep Max"
        
        saveToolbar = PullableToolbar()
        saveToolbar.translatesAutoresizingMaskIntoConstraints = false
        saveToolbar.activationBlock = {
            self.performSegueWithIdentifier("SaveMaxSegue", sender: self)
        }
        
        let instructionLabel = UILabel()
        instructionLabel.text = "pull to save"
        instructionLabel.sizeToFit()
        instructionLabel.textColor = UIColor.grayColor()

        let barItem = UIBarButtonItem(customView: instructionLabel)
        
        let space = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)

        saveToolbar.setItems([space, barItem], animated: false)
        
        self.view.addSubview(saveToolbar)

        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[saveToolbar]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["saveToolbar": saveToolbar]))
        
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[saveToolbar(toolbarHeight)][toolbar(toolbarHeight)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: ["toolbarHeight": toolbar.frame.height], views: ["saveToolbar": saveToolbar, "toolbar": toolbar]))
        
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
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        updateORMDisplay(oneRepMax: oneRepMax)
    }
    
    func updateSaveButtonStatus(oneRepMax: Int) {
        let valid = oneRepMax != 0
        
        
        if valid {

        } else {
            
        }
        

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

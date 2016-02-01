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
    
    @IBOutlet weak var mainStackView: UIStackView!
    @IBOutlet weak var recentMaxStackView: UIStackView!
    @IBOutlet weak var contentStackView: UIStackView!
    
    var viewControllerSwitcherButtonsConstraintsCollection = [UIButton: NSLayoutConstraint]()
    
    let saveToolbarAnimationTime = 0.5
    
    var oneRepMax: Int {
        return ormControlsViewController.oneRepMax
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "The One Rep Max"
        
        saveToolbar = PullableToolbar()
        saveToolbar.activationDirection = .Right
        saveToolbar.translatesAutoresizingMaskIntoConstraints = false
        saveToolbar.activationBlock = {
            self.performSegueWithIdentifier("SaveMaxSegue", sender: self)
        }
        
        let instructionLabel = UILabel()
        instructionLabel.text = "pull to save"
        instructionLabel.sizeToFit()
        instructionLabel.textColor = UIColor.grayColor()
        
        saveToolbar.setItems([
            UIBarButtonItem(customView: instructionLabel),
            UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        ], animated: false)
        
        NSLayoutConstraint.activateConstraints([
            saveToolbar.heightAnchor.constraintLessThanOrEqualToConstant(44)
        ])
        
        if let index = mainStackView.arrangedSubviews.indexOf(toolbar) {
            mainStackView.insertArrangedSubview(saveToolbar, atIndex: index)
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        ormControlsViewController = storyboard.instantiateViewControllerWithIdentifier("ORMControlsViewController") as! ORMControlsViewController
        
        percentagesViewController = storyboard.instantiateViewControllerWithIdentifier("PercentagesViewController") as! PercentagesViewController
        
        self.addChildViewController(ormControlsViewController)
        self.addChildViewController(percentagesViewController)
        
        ormControlsViewController.view.translatesAutoresizingMaskIntoConstraints = false
        percentagesViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        controlScrollViewContentView = UIView()
        controlScrollViewContentView.translatesAutoresizingMaskIntoConstraints = false

        controlScrollView.translatesAutoresizingMaskIntoConstraints = false
        controlScrollView.addSubview(controlScrollViewContentView)
        
        self.addChildViewController(ormControlsViewController)
        self.addChildViewController(percentagesViewController)

        controlScrollViewContentView.addSubview(ormControlsViewController.view)
        controlScrollViewContentView.addSubview(percentagesViewController.view)
        
        NSLayoutConstraint.activateConstraints([
            controlScrollView.topAnchor.constraintEqualToAnchor(controlScrollViewContentView.topAnchor),
            controlScrollView.bottomAnchor.constraintEqualToAnchor(controlScrollViewContentView.bottomAnchor),
            controlScrollView.leadingAnchor.constraintEqualToAnchor(controlScrollViewContentView.leadingAnchor),
            controlScrollView.trailingAnchor.constraintEqualToAnchor(controlScrollViewContentView.trailingAnchor),
            
            controlScrollViewContentView.heightAnchor.constraintEqualToAnchor(controlScrollView.heightAnchor),
            
            controlScrollViewContentView.topAnchor.constraintEqualToAnchor(ormControlsViewController.view.topAnchor),
            controlScrollViewContentView.bottomAnchor.constraintEqualToAnchor(ormControlsViewController.view.bottomAnchor),

            controlScrollViewContentView.topAnchor.constraintEqualToAnchor(percentagesViewController.view.topAnchor),
            controlScrollViewContentView.bottomAnchor.constraintEqualToAnchor(percentagesViewController.view.bottomAnchor),
        
            ormControlsViewController.view.leadingAnchor.constraintEqualToAnchor(controlScrollViewContentView.leadingAnchor),
            ormControlsViewController.view.trailingAnchor.constraintEqualToAnchor(percentagesViewController.view.leadingAnchor),
            percentagesViewController.view.trailingAnchor.constraintEqualToAnchor(controlScrollViewContentView.trailingAnchor),
            
            ormControlsViewController.view.widthAnchor.constraintEqualToAnchor(controlScrollView.widthAnchor),
            percentagesViewController.view.widthAnchor.constraintEqualToAnchor(ormControlsViewController.view.widthAnchor)
        ])
        
        ormControlsViewController.addDelegate(self)
        
        populateRecentMaxStackView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        updateORMDisplay(oneRepMax: oneRepMax)
    }
    
    func populateRecentMaxStackView() {
        let (templates, response) = session.localData.fetchAll(model: ORLiftTemplate.self)
        
        guard response.success else { print("Error fetching LiftTemplates: \(response.error)"); return }
        
        var latestEntries = [ORLiftEntry]()
        for template in templates {
            let predicate = NSPredicate(key: ORLiftEntry.Fields.liftTemplate.rawValue, comparator: .Equals, value: template)
            let options = ORDataOperationOptions()
            options.fetchLimit = 1
            
            let (entries, response) = session.localData.fetchObjects(model: ORLiftEntry.self, predicates: [predicate], options: options)
            
            guard response.success else { print("Error fetching LiftEntry: \(response.error)"); return }
            
            guard let latestEntry = entries.last else { continue }
            latestEntries.append(latestEntry)
        }
        
        for entry in latestEntries {
            let label = UILabel()
            label.text = entry.max.stringValue
            label.sizeToFit()
            
            recentMaxStackView.addArrangedSubview(label)
        }
        
    }
    
    func updateSaveButtonStatus(oneRepMax: Int) {
        let valid = oneRepMax != 0
        
        if valid {
            UIView.animateWithDuration(saveToolbarAnimationTime) {
                self.saveToolbar.hidden = false
                self.saveToolbar.alpha  = 1
            }
        } else {
            UIView.animateWithDuration(saveToolbarAnimationTime) {
                self.saveToolbar.hidden = true
                self.saveToolbar.alpha  = 0
            }
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

//
//  ChartsViewController.swift
//  TheOneRepMax
//
//  Created by Developer on 2/29/16.
//  Copyright © 2016 JwitApps. All rights reserved.
//

import UIKit



class ChartsViewController: ORViewController, DataViewerDelegate {

    var dataViewerViewController: DataViewerViewController!
    
    var simpleHistoryGraphViewController: SimpleHistoryGraphViewController!
    
    @IBOutlet weak var mainStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        simpleHistoryGraphViewController = storyboard.instantiateViewControllerWithIdentifier("SimpleHistoryGraphViewController") as! SimpleHistoryGraphViewController
        simpleHistoryGraphViewController.dataViewerViewController = self.dataViewerViewController
        dataViewerViewController.addDelegate(simpleHistoryGraphViewController)
        
        addChildViewController(simpleHistoryGraphViewController)

        mainStackView.addArrangedSubview(simpleHistoryGraphViewController.view)
    }
    
    func selectedLiftDidChange(liftTemplate liftTemplate: LiftTemplate?, liftEntries: [LiftEntry]) {
        
        
        
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SimpleGraphSegue" {
            guard let graphViewController = segue.destinationViewController as? SimpleHistoryGraphViewController else {
                print("'SimpleGraphSegue' identifier used on ViewController class other than SimpleHistoryGraphViewController!")
                return
            }
            simpleHistoryGraphViewController = graphViewController
            
            dataViewerViewController.addDelegate(graphViewController)
        }
    
    }

}

//
//  ChartsViewController.swift
//  TheOneRepMax
//
//  Created by Developer on 2/29/16.
//  Copyright © 2016 JwitApps. All rights reserved.
//

import UIKit

import RealmSwift

class ChartsViewController: ORViewController, DataViewerDelegate {

    var dataViewerViewController: DataViewerViewController!
    
    @IBOutlet weak var mainStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func selectedLiftDidChange(liftEntries liftEntries: Results<LocalEntry>) {
        
        
        
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     
    }

}

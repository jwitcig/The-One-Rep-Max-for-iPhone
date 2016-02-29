//
//  FocusResizingLabel.swift
//  TheOneRepMax
//
//  Created by Developer on 12/22/15.
//  Copyright © 2015 JwitApps. All rights reserved.
//

import UIKit

// THIS CLASS IS NOT IN USE
class FocusResizingLabel: UILabel {
    
    var isMagnified = false
    
    let magnificationTime = 0.2
    
    let focusMagnification = 1.6 as CGFloat
    
    var focusDemagnification: CGFloat {
        return 1.0 / focusMagnification
    }
    
    init() {
        super.init(frame: CGRect.zero)
        
        self.userInteractionEnabled = false
        
        self.font = UIFont(name: "Avenir Book", size: 24)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func magnify() {
        guard !self.isMagnified else { return }
        
        self.isMagnified = true
    
        UIView.animateWithDuration(magnificationTime, animations: {
            
            self.transform = CGAffineTransformScale(self.transform, self.focusMagnification, self.focusMagnification)
            
        }) { (bool) -> Void in
            self.demagnify()
        }
    }
        
    func demagnify() {
        guard self.isMagnified else { return }
        
        self.isMagnified = false
        UIView.animateWithDuration(magnificationTime) {
            self.transform = CGAffineTransformScale(self.transform, self.focusDemagnification, self.focusDemagnification)
        }
    }
    
    func toggleMagnification() {
        if isMagnified {
            demagnify()
        } else {
            magnify()
        }
    }

    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
}

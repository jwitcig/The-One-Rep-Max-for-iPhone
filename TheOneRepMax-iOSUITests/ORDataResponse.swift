//
//  ORCloudResponse.swift
//  ORMKit
//
//  Created by Developer on 6/16/15.
//  Copyright (c) 2015 JwitApps. All rights reserved.
//

#if os(iOS)
    import UIKit
#elseif os(OSX)
    import Cocoa
#endif

import SwiftTools

public class ORDataResponse {
    
    var request: ORDataRequest
    
    public var error: NSError? {
        didSet {
            if let err = self.error {
                print(err)
            }
        }
    }
        
    public var success: Bool { return self.error == nil }
    
    public var failed: Bool { return !self.success }
    
    public var timestamp = NSDate()
    
    init(request: ORDataRequest, error: NSError? = nil) {
        self.request = request
        self.error = error            
    }
    
    public var elapsedTimeSinceResponse: NSTimeInterval {
        return self.timestamp.timeIntervalSinceNow
    }
    
    public var elapsedTimeBetweenRequestAndResponse: NSTimeInterval {
        return self.timestamp.timeIntervalSinceDate(self.request.timestamp)
    }
    
}
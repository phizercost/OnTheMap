//
//  Global.swift
//  OnTheMap
//
//  Created by Phizer Cost on 11/1/18.
//  Copyright © 2018 Phizer Cost. All rights reserved.
//

import UIKit

class Global: NSObject {
    
    var session = URLSession.shared

    override init() {
        super.init()
    }
    
    var sessionId = ""
    var uniqueKey = ""
    var firstName = ""
    var lastName = ""
    
    class func shared() -> Global {
        struct Element {
            static var shared = Global()
        }
        return Element.shared
    }
}

//
//  AppUtilities.swift
//  OnTheMap
//
//  Created by Phizer Cost on 8/2/18.
//  Copyright © 2018 Phizer Cost. All rights reserved.
//

import UIKit

class AppUtilities:UIViewController {
    
    func raiseAlert(title:String, notification:String) {
        let alert  = UIAlertController(title: title, message: notification, preferredStyle:UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(action) in alert.dismiss(animated: true, completion: nil)}))
        
        self.present(alert, animated: true, completion: nil)
        
    }
}

//
//  TabViewController.swift
//  OnTheMap
//
//  Created by Phizer Cost on 8/7/18.
//  Copyright © 2018 Phizer Cost. All rights reserved.
//

import UIKit

class TabViewController: UITabBarController {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadStudentsLocations()
    }
    
    @IBAction func logout(_ sender: Any) {
        
        _ = Global.shared().globalDELETEMethod(deleteCompletionHandler: {(result, error) in
            guard (error == nil) else {
                self.raiseAlert(title: "ERROR", notification:"Unable to logout")
                return
            }
            if result! {
                self.dismiss(animated: true, completion: nil)
            } else {
                self.raiseAlert(title: "ERROR", notification:"Unable to logout")
            }
        })
    }
    
    @IBAction func reloadInfo(_ sender: Any) {
        loadStudentsLocations()
    }
    
    @IBAction func addLocation(_ sender: Any) {
        let locationView = storyboard?.instantiateViewController(withIdentifier: "LocationViewController") as! LocationViewController
        navigationController?.pushViewController(locationView, animated: true)
    }
    
    @objc private func loadStudentsLocations() {
        Global.shared().fetchStudentsLocation() { (locations, error) in
            DispatchQueue.main.async {
                StudentLocations.shared.studentLocations = locations!
            }
        }
    }
    
    func raiseAlert(title:String, notification:String) {
        let alert  = UIAlertController(title: title, message: notification, preferredStyle:UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(action) in alert.dismiss(animated: true, completion: nil)}))
        self.present(alert, animated: true, completion: nil)
    }
}

//
//  TableViewController.swift
//  OnTheMap
//
//  Created by Phizer Cost on 8/1/18.
//  Copyright © 2018 Phizer Cost. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    

    @IBOutlet weak var grayActivityIndicator: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadStudentsLocations()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StudentLocations.shared.studentLocations.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationViewCell", for:indexPath) as! TableViewCell
        let studentLocation = StudentLocations.shared.studentLocations[(indexPath as NSIndexPath).row]
        cell.populateInfo(studentLocation)
        return cell
    }
    
    @objc private func loadStudentsLocations() {
        Global.shared().fetchStudentsLocation() { (locations, error) in
            DispatchQueue.main.async {
                StudentLocations.shared.studentLocations = locations!
                self.tableView.reloadData()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let student = StudentLocations.shared.studentLocations[(indexPath as NSIndexPath).row]
        let url = student.mediaURL
        
        guard !url.isEmpty, UIApplication.shared.canOpenURL(URL(string: url)!) else {
            self.raiseAlert(title: "ERROR", notification:"Invalid link pressed")
            return
        }
        UIApplication.shared.open(URL(string: url)!, options: [:], completionHandler: nil)
    }
    func raiseAlert(title:String, notification:String) {
        let alert  = UIAlertController(title: title, message: notification, preferredStyle:UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(action) in alert.dismiss(animated: true, completion: nil)}))
        self.present(alert, animated: true, completion: nil)
    }

}


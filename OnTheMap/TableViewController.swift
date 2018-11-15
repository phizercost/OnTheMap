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

}


//
//  TableViewCell.swift
//  OnTheMap
//
//  Created by Phizer Cost on 10/19/18.
//  Copyright © 2018 Phizer Cost. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
     
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelURL: UILabel!
    
    func populateInfo(_ info: StudentLocation) {
        labelName.text = "\(info.firstName), \(" ")\(info.lastName)"
        labelURL.text = info.mediaURL
    }
}

//
//  Location.swift
//  OnTheMap
//
//  Created by Phizer Cost on 11/1/18.
//  Copyright © 2018 Phizer Cost. All rights reserved.
//

import Foundation

struct Location: Codable {
    let firstName: String?
    let lastName: String?
    let mapString: String?
    let mediaURL: String?
    let latitude: Double?
    let longitude: Double?
}


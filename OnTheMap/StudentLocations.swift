//
//  StudentLocations.swift
//  OnTheMap
//
//  Created by Phizer Cost on 8/7/18.
//  Copyright © 2018 Phizer Cost. All rights reserved.
//

import Foundation

struct StudentLocations {
    static var shared = StudentLocations()
    private init() {}
    var studentLocations = [StudentLocation]()
}

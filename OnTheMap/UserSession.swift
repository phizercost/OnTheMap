//
//  Session.swift
//  OnTheMap
//
//  Created by Phizer Cost on 11/15/18.
//  Copyright © 2018 Phizer Cost. All rights reserved.
//

import Foundation

struct UserSession: Codable {
    let account: Account?
    let session: Session?
}

struct Account: Codable {
    let registered: Bool
    let key: String
}

struct Session: Codable {
    let id: String
    let expiration: String
}

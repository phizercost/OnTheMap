//
//  UserInfoDetails.swift
//  OnTheMap
//
//  Created by Phizer Cost on 11/12/18.
//  Copyright © 2018 Phizer Cost. All rights reserved.
//

import Foundation

struct UserInfoDetails: Codable {
    let nickname: String
    enum CodingKeys: String, CodingKey {
        case nickname = "nickname"
    }
}

//
//  Constants.swift
//  OnTheMap
//
//  Created by Phizer Cost on 10/6/18.
//  Copyright © 2018 Phizer Cost. All rights reserved.
//


import Foundation

struct Constants {
    
    struct Methods {
        static let post = "POST"
        static let get = "GET"
        static let delete = "DELETE"
    }
    
    struct Header {
        static let accept = "Accept"
        static let contentType = "Content-Type"
        static let contentValue = "application/json"
    }
    
    struct ParseParameters {
        static let key = "X-Parse-REST-API-Key"
        static let id = "X-Parse-Application-Id"
        static let keyValue = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        static let idValue = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
    }
    
    struct Udacity {
        static let signUpUrl = "https://auth.udacity.com/sign-up?next=https%3A%2F%2Fclassroom.udacity.com%2Fauthenticated"
        static let sessionApiUrl = "https://www.udacity.com/api/session"
        static let studentsURL = "https://parse.udacity.com/parse/classes/StudentLocation?limit=100&order=-updatedAt"
        static let userApiURL = "https://www.udacity.com/api/users"
        static let studentPostURL = "https://parse.udacity.com/parse/classes/StudentLocation"
        static let deleteURL = "https://www.udacity.com/api/session"
    }
}

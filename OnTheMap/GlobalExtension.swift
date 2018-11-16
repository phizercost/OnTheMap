//
//  GlobalExtension.swift
//  OnTheMap
//
//  Created by Phizer Cost on 11/15/18.
//  Copyright © 2018 Phizer Cost. All rights reserved.
//

import Foundation

extension Global {
    
    func loginFunction(email: String, password: String, completionHandler: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        let json = "{\"udacity\": {\"username\": \"\(email)\", \"password\": \"\(password)\"}}"
        let url = Constants.Udacity.sessionApiUrl
        _ = globalPOSTMethod(jsonBody: json, url: url, postCompletionHandler: {(data, error) in
            guard (error == nil) else {
                completionHandler(false, error!.localizedDescription)
                return
            }
            DispatchQueue.main.sync {
                do {
                    let jsonDecoder = JSONDecoder()
                    let parsedDataJSON = try jsonDecoder.decode( UserSession.self, from: data!)
                    
                    guard (parsedDataJSON.account!.registered) else {
                        completionHandler(false, "Incorrect username or/and password")
                        return
                    }
                    self.uniqueKey = (parsedDataJSON.account!.key)
                    self.sessionId = (parsedDataJSON.session!.id)
                    completionHandler(true, nil)
                    
                } catch {
                    completionHandler(false, "Incorrect username or/and password")
                }
            }
        })
    }
    
    func fetchStudentsLocation(completionHandler:@escaping ([StudentLocation]?, Error?)->Void){
        _ = globalGETMethod(url: Constants.Udacity.studentsURL, getCompletionHandler: {(data, error) in
            do {
                let jsonData = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String : AnyObject]
                if let resultsDictionary = jsonData["results"] as? [[String: AnyObject]] {
                    var studentLocations = [StudentLocation]()
                    for location in resultsDictionary {
                        studentLocations.append(StudentLocation(location))
                    }
                    completionHandler(studentLocations, nil)
                    return
                }
            } catch {
                completionHandler(nil, error)
            }
        })
    }
    
    func getUdacityUserInfo(completionHandler:@escaping (_ result: Bool, Error?)->Void) {
        _ = globalGETMethod(url: Constants.Udacity.userApiURL + "/\(Global.shared().uniqueKey)", getCompletionHandler: {(data, error) in
            if let data = data {
                let range = (5..<data.count)
                let newData = data.subdata(in: range)
                let user = try! JSONDecoder().decode(UserInfo.self, from: newData)
                self.firstName = (user.user.nickname)
                completionHandler  (true, nil)
            } else {
                completionHandler  (false, error)
            }
        })
    }
    
    func globalPOSTMethod(jsonBody: String, url:String, postCompletionHandler: @escaping (_ result: Data?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = Constants.Methods.post
        request.addValue(Constants.Header.contentValue, forHTTPHeaderField: Constants.Header.accept)
        request.addValue(Constants.Header.contentValue, forHTTPHeaderField: Constants.Header.contentType)
        request.addValue(Constants.ParseParameters.keyValue, forHTTPHeaderField: Constants.ParseParameters.key)
        request.addValue(Constants.ParseParameters.idValue, forHTTPHeaderField: Constants.ParseParameters.id)
        request.httpBody = jsonBody.data(using: String.Encoding.utf8)
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            guard (error == nil) else {
                let userInfo = [NSLocalizedDescriptionKey : error?.localizedDescription]
                postCompletionHandler(nil, NSError(domain: "globalPOSTMethod", code: 101, userInfo: userInfo as [String : Any]))
                return
            }
            let range = (5..<data!.count)
            let newData = data!.subdata(in: range)
            postCompletionHandler(newData, nil)
            
        }
        task.resume()
        
        return task
    }
    
    func globalGETMethod(url:String, getCompletionHandler: @escaping (_ result: Data?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        var request = URLRequest(url: URL(string: url)!)
        request.addValue(Constants.ParseParameters.keyValue, forHTTPHeaderField: Constants.ParseParameters.key)
        request.addValue(Constants.ParseParameters.idValue, forHTTPHeaderField: Constants.ParseParameters.id)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            guard error == nil  else {
                getCompletionHandler(nil, error! as NSError)
                return
            }
            getCompletionHandler(data, nil)
        }
        task.resume()
        return task
    }
    
    func globalDELETEMethod(deleteCompletionHandler: @escaping (_ result: Bool?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        var request = URLRequest(url: URL(string: Constants.Udacity.deleteURL)!)
        request.httpMethod = Constants.Methods.delete
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            guard (error == nil) else {
                deleteCompletionHandler(false, error! as NSError)
                return
            }
            Global.shared().uniqueKey = ""
            Global.shared().sessionId = ""
            deleteCompletionHandler(true, nil)
        }
        task.resume()
        return task
    }
    

}

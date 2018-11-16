//
//  LocationViewController.swift
//  OnTheMap
//
//  Created by Phizer Cost on 10/31/18.
//  Copyright © 2018 Phizer Cost. All rights reserved.
//
import UIKit
import CoreLocation

class LocationViewController: UIViewController {
    
    
    @IBOutlet weak var locationTxt: UITextField!
    @IBOutlet weak var websiteTxt: UITextField!
    @IBOutlet weak var locationFindBtn: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var geocode = CLGeocoder()
    var locationID: String?
    
    @IBAction func findLocation(_ sender: Any) {
        
        if locationTxt.text!.isEmpty || websiteTxt.text!.isEmpty{
            DispatchQueue.main.async {
                let ac = UIAlertController(title: "Error", message: "Please provide location and website", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(ac, animated: true)
            }
            return
        }
        geocode(location: locationTxt.text!)
    }
    
    private func geocode(location: String) {
        activityIndicator.startAnimating()
        geocode.geocodeAddressString(location) { (placemarkers, error) in
            
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
            }
            if error != nil {
                
                 DispatchQueue.main.async {
                    let ac = UIAlertController(title: "Error", message: "An error occured, try again later", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(ac, animated: true)
                }
            } else {
                var location: CLLocation?
                
                if let placemarks = placemarkers, placemarks.count > 0 {
                    location = placemarks.first?.location
                }
                if let location = location {
                    let viewController = self.storyboard?.instantiateViewController(withIdentifier: "MapPinController") as! MapPinController
                    viewController.studentLocation = self.fetchStudentLocation(location.coordinate)
                    self.navigationController?.pushViewController(viewController, animated: true)
                } else {
                    let ac = UIAlertController(title: "Error", message: "Location not found", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(ac, animated: true)
                }
            }
        }
    }
    
    private func fetchStudentLocation(_ coordinate: CLLocationCoordinate2D) -> StudentLocation {
        var studentLocation = [
            "uniqueKey": Global.shared.uniqueKey as AnyObject,
            "firstName": Global.shared.firstName,
            "lastName": "",
            "mapString": locationTxt.text!,
            "mediaURL": websiteTxt.text!,
            "latitude": coordinate.latitude,
            "longitude": coordinate.longitude,
            ] as [String: AnyObject]
        
        if let locationID = locationID {
            studentLocation["objectId"] = locationID as AnyObject
        }
        return StudentLocation(studentLocation)
    }
}

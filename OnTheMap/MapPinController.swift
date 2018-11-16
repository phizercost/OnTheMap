//
//  MapPinController.swift
//  OnTheMap
//
//  Created by Phizer Cost on 11/1/18.
//  Copyright © 2018 Phizer Cost. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapPinController: UIViewController, MKMapViewDelegate {
    
    
    @IBOutlet weak var mapViewPin: MKMapView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var finishBtn: UIButton!
    var studentLocation: StudentLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapViewPin.delegate = self
        if let student = studentLocation {
            let location = Location(
                firstName: student.firstName,
                lastName: student.lastName,
                mapString: student.mapString,
                mediaURL: student.mediaURL,
                latitude: student.latitude,
                longitude: student.longitude
            )
            mapViewPin.removeAnnotations(mapViewPin.annotations)
            if let coordinate = getLocationCoordinates(location: location) {
                let annotation = MKPointAnnotation()
                annotation.title = "\(String(describing: location.firstName)), \(String(describing: location.firstName))"
                annotation.subtitle = location.mediaURL ?? ""
                annotation.coordinate = coordinate
                mapViewPin.addAnnotation(annotation)
                mapViewPin.showAnnotations(mapViewPin.annotations, animated: true)
            }
        }
    }
    
    private func getLocationCoordinates(location: Location) -> CLLocationCoordinate2D? {
        if let lat = location.latitude, let lon = location.longitude {
            return CLLocationCoordinate2DMake(lat, lon)
        }
        return nil
    }
    
    @IBAction func finish(_ sender: Any) {
        
        let json = "{\"uniqueKey\": \"\(studentLocation!.uniqueKey)\", \"firstName\": \"\(studentLocation!.firstName)\", \"lastName\": \"\(studentLocation!.firstName)\",\"mapString\": \"\(studentLocation!.mapString)\", \"mediaURL\": \"\(studentLocation!.mediaURL)\",\"latitude\": \(studentLocation!.latitude), \"longitude\": \(studentLocation!.longitude)}"
        let url = Constants.Udacity.studentPostURL
        
        _ = Global.shared.globalPOSTMethod(jsonBody: json, url: url, postCompletionHandler: {(data, error) in
            guard (error == nil) else {
                self.raiseAlert(title: "ERROR", notification:"Unable to post student location")
                return
            }
            self.raiseAlert(title: "SUCCESS", notification:"New Location posted succesfully")
        })
        DispatchQueue.main.async {
            let viewController = self.storyboard?.instantiateViewController(withIdentifier: "TabViewController") as! TabViewController
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
}

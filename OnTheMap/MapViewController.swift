//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Phizer Cost on 8/1/18.
//  Copyright © 2018 Phizer Cost. All rights reserved.
//

import UIKit
import MapKit


class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var grayActivityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.grayActivityIndicator.startAnimating()
        self.mapView.alpha = 0.5
        Global.shared.getUdacityUserInfo() { (data, error)  in
        }
        mapView.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadStudentsLocations()
        
    }
    
    @objc func reloadCompleted() {
        DispatchQueue.main.async {
            self.processAnnotations(StudentLocations.shared.studentLocations)
        }
    }
    
    private func processAnnotations(_ studentsLocation: [StudentLocation]) {
        self.mapView.removeAnnotations(mapView.annotations)
        for location in studentsLocation {
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            annotation.title = "\(location.firstName), \(location.lastName)"
            annotation.subtitle = location.mediaURL
            self.mapView.addAnnotation(annotation)
        }
        self.mapView.showAnnotations(mapView.annotations, animated: true)
    }
    
    @objc private func loadStudentsLocations() {
        Global.shared.fetchStudentsLocation() { (locations, error) in
            DispatchQueue.main.async {
                StudentLocations.shared.studentLocations = locations!
                self.grayActivityIndicator.stopAnimating()
                self.mapView.alpha = 1
                self.processAnnotations(StudentLocations.shared.studentLocations)
            }
        }
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let identifier = "annotation"
        var view: MKPinAnnotationView
        
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        
        return view
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            guard let url = view.annotation?.subtitle!, !url.isEmpty, UIApplication.shared.canOpenURL(URL(string: url)!)  else {
                self.raiseAlert(title: "ERROR", notification:"Invalid link pressed")
                return
            }
            UIApplication.shared.open(URL(string: url)!, options: [:], completionHandler: nil)
        }
    }
}


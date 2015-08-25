//
//  MapViewController.swift
//  On the map
//
//  Created by Andreas Pfister on 22/08/15.
//  Copyright (c) 2015 iOS Development Blog. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    var annotations = [MKPointAnnotation]()
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet var loadIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //exchange reload button
        let reload = UIBarButtonItem(barButtonSystemItem: .Refresh, target: self, action: "reloadData")
        self.tabBarController!.navigationItem.rightBarButtonItems?.removeAtIndex(0)
        self.tabBarController!.navigationItem.rightBarButtonItems?.insert(reload, atIndex: 0)
        
        mapView.removeAnnotations(mapView.annotations)
        loadStudentLocations()
    }
    
    
    func loadStudentLocations() {
        loadIndicator.startAnimating()
        parseClient.sharedInstance().getStudentLocationAnnotations { annotations, error in
            if let annotations = annotations {
                self.annotations = annotations
                dispatch_async(dispatch_get_main_queue()) {
                    self.mapView.addAnnotations(self.annotations)
                    self.loadIndicator.stopAnimating()
                }
            } else {
                var alert = UIAlertView(title: nil, message: error?.localizedDescription, delegate: self, cancelButtonTitle: "Dismiss")
                alert.show()
                self.loadIndicator.stopAnimating()
            }
        }
    }
    
    func reloadData() {
        mapView.removeAnnotations(mapView.annotations)
        loadStudentLocations()
    }
    
    // how to we want to show the annotation, here is the place to influence this !!
    // TODO Future: use different pincolor i.e. .Purple for own location
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinColor = .Red
            pinView!.rightCalloutAccessoryView = UIButton.buttonWithType(.DetailDisclosure) as! UIButton
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    // goto URL stored in subtitle
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {

        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.sharedApplication()
            app.openURL(NSURL(string: view.annotation.subtitle!)!)
        }
        
    }
    
}
//
//  PostInformationViewController.swift
//  On the map
//
//  Created by Andreas Pfister on 23/08/15.
//  Copyright (c) 2015 iOS Development Blog. All rights reserved.
//

import Foundation
import UIKit
import MapKit


class PostInformationViewController: UIViewController, MKMapViewDelegate, UITextFieldDelegate {
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var findButton: BorderedButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var middleBlueArea: UIView!
    @IBOutlet weak var searchText: UITextField!
    @IBOutlet weak var linkText: UITextField!
    @IBOutlet weak var topWebView: UIView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var bottomWebView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var blurEffect: UIVisualEffectView!
    
    var localSearchResponse: MKLocalSearchResponse? = nil
    var tapRecognizer: UITapGestureRecognizer? = nil
    
    @IBAction func cancelPost(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        configureUI()
        //no interaction
        mapView.userInteractionEnabled = false
        tapRecognizer = UITapGestureRecognizer(target: self, action: "handleSingleTap:")
        tapRecognizer?.numberOfTapsRequired = 1
        self.searchText.delegate = self;
        self.linkText.delegate = self;
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    @IBAction func submitPosition(sender: AnyObject) {
        if let link = linkText.text {
            if !UIApplication.sharedApplication().canOpenURL(NSURL(string: linkText.text)!) {
                var alert = UIAlertView(title: nil, message: "Please provide a valid URL", delegate: self, cancelButtonTitle: "Ok")
                alert.show()
                return
            }
        } else {
            return
        }
        
        blurEffect.hidden = false
        activityIndicator.startAnimating()
        let myMinLocationInfo = udacityClient.sharedInstance().userLocation!
        if let myLocation = udacityClient.sharedInstance().userLocation?.objectId {
            // does have a location already, put an update !
          
            let newLocationInformation: [String:AnyObject] = [
                parseClient.JSONResponseKeys.UniqueKey : myMinLocationInfo.uniqueKey,
                parseClient.JSONResponseKeys.FirstName : myMinLocationInfo.firstName,
                parseClient.JSONResponseKeys.LastName  : myMinLocationInfo.lastName,
                parseClient.JSONResponseKeys.MapString : searchText.text,
                parseClient.JSONResponseKeys.MediaURL : linkText.text,
                parseClient.JSONResponseKeys.Latitude : Double(self.localSearchResponse!.boundingRegion.center.latitude),
                parseClient.JSONResponseKeys.Longitude : Double(self.localSearchResponse!.boundingRegion.center.longitude)
            ]
            
            parseClient.sharedInstance().putStudentLocation(newLocationInformation) { error in
                if let error = error {
                    var alert = UIAlertView(title: nil, message: "Error updating your location\nError: \(error)", delegate: self, cancelButtonTitle: "Dismiss")
                    alert.show()
                }
                self.dismissViewControllerAnimated(true, completion: nil)
            }
            
        } else {
            // post a new location
            let newLocationInformation: [String:AnyObject] = [
                parseClient.JSONResponseKeys.UniqueKey : udacityClient.sharedInstance().userID as String!,
                parseClient.JSONResponseKeys.FirstName : udacityClient.sharedInstance().userLocation?.firstName as String!,
                parseClient.JSONResponseKeys.LastName  : udacityClient.sharedInstance().userLocation?.lastName as String!,
                parseClient.JSONResponseKeys.MapString : searchText.text,
                parseClient.JSONResponseKeys.MediaURL : linkText.text,
                parseClient.JSONResponseKeys.Latitude : Double(self.localSearchResponse!.boundingRegion.center.latitude),
                parseClient.JSONResponseKeys.Longitude : Double(self.localSearchResponse!.boundingRegion.center.longitude)
            ]
            
            parseClient.sharedInstance().postStudentLocation(newLocationInformation) { error in
                if let error = error {
                    var alert = UIAlertView(title: nil, message: "Error adding your location\nError: \(error)", delegate: self, cancelButtonTitle: "Dismiss")
                    alert.show()
                }
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }
    
    @IBAction func findOnTheMap(sender: AnyObject) {
        
        //remove existing annotations
        if mapView.annotations.count != 0{
            self.mapView.removeAnnotations(self.mapView.annotations)
        }
        
        blurEffect.hidden = false
        activityIndicator.startAnimating()
        
        var localSearchRequest = MKLocalSearchRequest()
        localSearchRequest.naturalLanguageQuery = searchText.text
        var localSearch = MKLocalSearch(request: localSearchRequest)
        localSearch.startWithCompletionHandler { (localSearchResponse, error) -> Void in
            if localSearchResponse == nil{
                //nothing found, show alert
                var alert = UIAlertView(title: nil, message: "Place not found", delegate: self, cancelButtonTitle: "Try again")
                alert.show()
                self.blurEffect.hidden = true
                self.activityIndicator.stopAnimating()
                return
            } else {
                //place found, zoom to location and place annotation
                //also show top text field to be able to enter a link
                self.linkText.becomeFirstResponder()
                self.localSearchResponse = localSearchResponse
                var pointAnnotation = MKPointAnnotation()
                pointAnnotation.title = self.searchText.text
                pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: localSearchResponse.boundingRegion.center.latitude, longitude:     localSearchResponse.boundingRegion.center.longitude)
                var pinAnnotationView = MKPinAnnotationView(annotation: pointAnnotation, reuseIdentifier: nil)
                self.mapView.centerCoordinate = pointAnnotation.coordinate
                self.mapView.addAnnotation(pinAnnotationView.annotation)
                let span = MKCoordinateSpanMake(1, 1)
                let region = MKCoordinateRegionMake(pointAnnotation.coordinate, span)
                self.mapView.setRegion(region, animated: true)

                self.middleBlueArea.hidden = true
                
                self.topLabel.hidden = true
                
                self.topWebView.backgroundColor = self.middleBlueArea.backgroundColor
                self.linkText.hidden = false
                
                self.findButton.hidden = true
                self.submitButton.hidden = false
                
                self.bottomWebView.alpha = CGFloat(0.1)
                self.cancelButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
                self.blurEffect.hidden = true
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    func handleSingleTap(recognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}

extension PostInformationViewController {
    
    func configureUI() {
        var attributedText = NSMutableAttributedString(string:"")
        var attrs = [NSFontAttributeName : UIFont(name: "Roboto-Thin", size: 26)!,NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType]
        var attrsB = [NSFontAttributeName : UIFont(name: "Roboto-Regular", size: 28)!,NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType]
        
        attributedText.appendAttributedString(NSMutableAttributedString(string:"Where you are\n", attributes:attrs))
        attributedText.appendAttributedString(NSMutableAttributedString(string:"studying\n", attributes:attrsB))
        attributedText.appendAttributedString(NSMutableAttributedString(string:"today ?", attributes:attrs))
        topLabel.attributedText = attributedText
        topLabel.textColor = middleBlueArea.backgroundColor
        
        searchText.font = UIFont(name: "Roboto-Regular", size: 20.0)
        searchText.textColor = UIColor.whiteColor()
        searchText.attributedPlaceholder = NSAttributedString(string: searchText.placeholder!, attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
        
        linkText.font = UIFont(name: "Roboto-Regular", size: 20.0)
        linkText.textColor = UIColor.whiteColor()
        linkText.attributedPlaceholder = NSAttributedString(string: linkText.placeholder!, attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
        
        findButton.sizeToFit()
    }
    
}
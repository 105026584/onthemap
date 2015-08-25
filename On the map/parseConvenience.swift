//
//  parseConvenience.swift
//  On the map
//
//  Created by Andreas Pfister on 22/08/15.
//  Copyright (c) 2015 iOS Development Blog. All rights reserved.
//

import Foundation
import MapKit

extension parseClient {
    
    
    func getStudentLocations(completionHandler: (result: [parseStudentLocation]?, error: NSError?) -> Void) {
        
        // specify parameters
        var parameters = [parseClient.ParameterKeys.Order:parseClient.ParameterStaticValues.OrderByUpdatedDESC]
        var mutableMethod : String = ""
        
        // get 
        taskForGETMethod(mutableMethod, parameters: parameters) { JSONResult, error in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandler(result: nil, error: error)
            } else {
                if let results = JSONResult.valueForKey(parseClient.JSONResponseKeys.LocationResults) as? [[String : AnyObject]] {
                    self.studentLocations = parseStudentLocation.locationsFromResults(results)
                    completionHandler(result: self.studentLocations, error: nil)
                } else {
                    completionHandler(result: nil, error: NSError(domain: "getStudentLocations parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getStudentLocations"]))
                }
            }
        }
    }
    
    func getStudentLocationAnnotations(completionHandler: (result: [MKPointAnnotation]?, error: NSError?) -> Void) {
    
        getStudentLocations() { (locations, error ) in
            if let locations = locations {
                //if all went well convert studentLocations into annotations
                var annotations = parseStudentLocation.convertStudentLocationsToAnnotations(locations)
                completionHandler(result: annotations, error: nil)
            } else {
                completionHandler(result: nil, error: error)
            }
        }
    }
    
    func postStudentLocation(studentLocation: [String:AnyObject], completionHandler: (error: NSError?) -> Void) {
        //specify parameters
        var parameters = [String: AnyObject]()
        var mutableMethod : String = parseClient.Methods.PostLocation
        
        //execute
        taskForPOSTorPUTMethod("POST", method: mutableMethod, parameters: parameters, jsonBody: studentLocation) { JSONResult, error in
            if let error = error {
                completionHandler(error: error)
            } else {
                completionHandler(error: nil)
            }
        }

    }
    
    func putStudentLocation(studentLocation: [String:AnyObject], completionHandler: (error: NSError?) -> Void) {
        //specify parameters
        var parameters = [String:AnyObject]()
        var mutableMethod : String = parseClient.Methods.PutLocation + udacityClient.sharedInstance().userLocation!.objectId!
        
        //execute
        taskForPOSTorPUTMethod("PUT", method: mutableMethod, parameters: parameters, jsonBody: studentLocation) { JSONResult, error in
            if let error = error {
                completionHandler(error: error)
            } else {
                completionHandler(error: nil)
            }
        }
        
    }
}
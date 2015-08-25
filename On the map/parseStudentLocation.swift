//
//  parseStudentLocation.swift
//  On the map
//
//  Created by Andreas Pfister on 22/08/15.
//  Copyright (c) 2015 iOS Development Blog. All rights reserved.
//

import Foundation
import MapKit

struct parseStudentLocation {
    
    var objectId: String? = nil
    var uniqueKey = ""
    var firstName = ""
    var lastName = ""
    var mapString = ""
    var mediaURL: String? = nil
    var latitude = 0.0
    var longitude = 0.0
    var createdAt = ""
    var updatedAt: String? = nil
    
    init(dictionary: [String : AnyObject?]) {
           
        objectId = dictionary[parseClient.JSONResponseKeys.ObjectId] as? String
        uniqueKey = dictionary[parseClient.JSONResponseKeys.UniqueKey] as! String
        firstName = dictionary[parseClient.JSONResponseKeys.FirstName] as! String
        lastName = dictionary[parseClient.JSONResponseKeys.LastName] as! String
        mapString = dictionary[parseClient.JSONResponseKeys.MapString] as! String
        mediaURL = dictionary[parseClient.JSONResponseKeys.MediaURL] as? String
        latitude = dictionary[parseClient.JSONResponseKeys.Latitude] as! Double
        longitude = dictionary[parseClient.JSONResponseKeys.Longitude] as! Double
        createdAt = dictionary[parseClient.JSONResponseKeys.CreatedAt] as! String
        updatedAt = dictionary[parseClient.JSONResponseKeys.UpdatedAt] as? String
    }

    static func convertStudentLocationsToAnnotations(results: [parseStudentLocation]) -> [MKPointAnnotation] {
        var annotations = [MKPointAnnotation]()
        
        for result in results {
            var annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(result.latitude), longitude: CLLocationDegrees(result.longitude))
            annotation.title = "\(result.firstName) \(result.lastName)"
            annotation.subtitle = result.mediaURL
            annotations.append(annotation)
        }
        
        return annotations
    }
    
    static func locationsFromResults(results: [[String : AnyObject]]) -> [parseStudentLocation] {
        var locations = [parseStudentLocation]()
        
        for result in results {
            locations.append(parseStudentLocation(dictionary: result))
        }
        
        return locations
    }
    
    
}
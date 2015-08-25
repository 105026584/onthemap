//
//  udacityConstants.swift
//  On the map
//
//  Created by Andreas Pfister on 16/08/15.
//  Inspired by Jarrod Parkes.
//  Copyright (c) 2015 iOS Development Blog. All rights reserved.
//

extension parseClient {
    
    // MARK: - Constants
    struct Constants {
        
        // MARK: parse Header information
        // Parse header keys
        static let applicationIdKey : String = "X-Parse-Application-Id"
        static let apiKeyKey : String = "X-Parse-REST-API-Key"
        // Parse header values
        static let applicationIdValue : String = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let apiKeyValue : String = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        
        // MARK: URLs
        static let BaseURL : String = "https://api.parse.com/1/classes/StudentLocation"
    }
    
    // MARK: - Methods
    struct Methods {
        
        // MARK: Post & Put Location
        static let PostLocation = ""
        static let PutLocation = "/"
        
    }
    
    // MARK: - URL Keys
    struct URLKeys {
        
        static let UserID = "id"
        
    }
    
    // MARK: - Parameter Keys
    struct ParameterKeys {
        
        // MARK: - General
        static let WhereCondition = "where"
        static let Order = "order"
        static let UniqueKey = "uniqueKey"
        
    }
    
    // MARK: - Parameter Values
    struct ParameterStaticValues {
        static let OrderByUpdatedASC = "updatedAt"
        static let OrderByUpdatedDESC = "-updatedAt"
    }
    
    // MARK: - JSON Body Keys
    struct JSONBodyKeys {
        
        
    }
    
    // MARK: - JSON Response Keys
    struct JSONResponseKeys {
        
        // MARK: General
        static let StatusMessage = "status_message"
        static let StatusCode = "status_code"
        
        // MARK: Locations
        static let ObjectId = "objectId"
        static let UniqueKey = "uniqueKey"
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let MapString = "mapString"
        static let MediaURL = "mediaURL"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
        static let CreatedAt = "createdAt"
        static let UpdatedAt = "updatedAt"
        static let LocationResults = "results"
        
        
    }
}
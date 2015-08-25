//
//  udacityConstants.swift
//  On the map
//
//  Created by Andreas Pfister on 16/08/15.
//  Inspired by Jarrod Parkes.
//  Copyright (c) 2015 iOS Development Blog. All rights reserved.
//

extension udacityClient {
    
    // MARK: - Constants
    struct Constants {
        
        // MARK: FacebookAPI Key (is configured in info.plist anyway, but store it here, just in case)
        static let fbAppId : String = "365362206864879"
        
        // MARK: URLs
        static let BaseURL : String = "https://www.udacity.com/api/"
        //static let AuthorizationURL : String = "https://www.themoviedb.org/authenticate/"
        
        static let SignUpURL : String = "https://www.udacity.com/account/auth#!/signup"
        
    }
    
    // MARK: - Methods
    struct Methods {
        
        // MARK: Account
        static let PublicUserData = "users/{user_id}"
        
        // MARK: Authentication
        static let AuthenticationSession = "session"
        
    }
    
    // MARK: - URL Keys
    struct URLKeys {
        
        static let UserID = "user_id"
        
    }
    
    // MARK: - JSON Body Keys
    struct JSONBodyKeys {
        
        static let CredentialContainer = "udacity"
        static let Username = "username"
        static let Password = "password"
        
        // MARK: - Facebook Token Login
        static let FBCredentialContainer = "facebook_mobile"
        static let FBTokenKey = "access_token"
        
    }
    
    // MARK: - JSON Response Keys
    struct JSONResponseKeys {
        
        // MARK: General
        static let StatusCode = "status"
        static let ErrorMessage = "error"
        static let ErrorParameter = "parameter"
        
        // MARK: Authorization
        static let SessionContainer = "session"
        static let SessionID = "id"
        
        // MARK: Account
        static let AccountContainer = "account"
        static let UserID = "key"
        
        // MARK: User Information
        static let UserInfoContainer = "user"
        static let firstName = "first_name"
        static let lastName = "last_name"
        
    }
}
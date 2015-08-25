//
//  udacityConvenience.swift
//  On the map
//
//  Created by Andreas Pfister on 21/08/15.
//  Copyright (c) 2015 iOS Development Blog. All rights reserved.
//

import Foundation
import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

extension udacityClient {
    
    // MARK: - Authentication (POST) Methods
    /*
    Steps for Authentication... quite easy for this one ;-)
    
    Step 1: Create a new session request
    Step 2: Store userID
    Step 2a: check if parseInfo for user is available, if yes, store it
    Step 2b: if no parseInfo, fill up studentLocation object with firstName and LastName to allow posting of location later on (only applies if no location posted yet)
    */
    func authenticateWithLoginViewController(hostViewController: LoginViewController, isFacebookLogin: Bool, completionHandler: (success: Bool, errorString: String?) -> Void) {
        
        createSession(hostViewController.usernameTextField.text, password: hostViewController.passwordTextField.text, isFacebookLogin: isFacebookLogin) { (success, userID, errorString ) in
            
            if success {
                //if all went well store the userID and pull current userLocation information, if available !
                self.userID = userID
                self.getParseUserInformation() {
                    success, errorString in
                    if success {
                        //parseInfo already available, nothing to do anymore
                        completionHandler(success: success, errorString: errorString)
                    } else {
                        // in case no parseInfo available yet, get firstName and lastName from udacityProfile, to be able to make the first parsePost
                        self.getUserInformation() {
                            success, firstName, lastName, errorString in
                            if success {
                                self.userLocation?.firstName = firstName!
                                self.userLocation?.lastName = lastName!
                            }
                            completionHandler(success: success, errorString: errorString)
                        }
                    }
                }
            } else {
                completionHandler(success: false, errorString:errorString )
            }
        }
    }
    
    func getParseUserInformation(completionHandler: (success: Bool, errorString: String?) -> Void) {
        
        /* define params & URL*/
        var parameters = [parseClient.ParameterKeys.WhereCondition:"{\"\(parseClient.ParameterKeys.UniqueKey)\":\"\(self.userID!)\"}"]
        
        /* execute */
        parseClient.sharedInstance().taskForGETMethod("", parameters: parameters) { JSONResult, error in
            if let results = JSONResult.valueForKey(parseClient.JSONResponseKeys.LocationResults) as? [[String : AnyObject]] {
                // if all went well, store information in current userLocation member
                let studentLocation = parseStudentLocation.locationsFromResults(results)
                self.userLocation = studentLocation[0] as parseStudentLocation
                completionHandler(success: true, errorString: "")
            } else {
                completionHandler(success: false, errorString: "not able to retrieve parse Information")
            }
        }
    }
    
    func getUserInformation(completionHandler: (success: Bool, firstName: String?, lastName: String?, errorString: String?) -> Void) {
        
        /* 2. Define parameters */
        var parameters = [String: AnyObject]()
        var mutableMethod : String = Methods.PublicUserData
        mutableMethod = udacityClient.subtituteKeyInMethod(mutableMethod, key: URLKeys.UserID, value: String(self.userID!))!
        
        /* 2. Make the request */
        self.taskForGETMethod(mutableMethod, parameters: parameters) { JSONResult, error in
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandler(success: false, firstName: nil, lastName: nil, errorString: "not able to retrieve public user profile.")
            } else {
                if let firstname = JSONResult.valueForKey(udacityClient.JSONResponseKeys.UserInfoContainer)?.valueForKey(udacityClient.JSONResponseKeys.firstName) as? String {
                    
                    completionHandler(success: true, firstName: JSONResult.valueForKey(udacityClient.JSONResponseKeys.UserInfoContainer)?.valueForKey(udacityClient.JSONResponseKeys.firstName) as? String, lastName: JSONResult.valueForKey(udacityClient.JSONResponseKeys.UserInfoContainer)?.valueForKey(udacityClient.JSONResponseKeys.lastName) as? String, errorString: nil)
                    
                } else {
                    completionHandler(success: false, firstName: nil, lastName: nil, errorString: "No values on public user profile.")
                }
            }
        }
    }

    
    func destroySession(completionHandler: (success: Bool, errorString: String?) -> Void) {
        
        //Specify parameters
        var parameters = [String: AnyObject]()
        
        //execute
        let task = taskForDELETEMethod(udacityClient.Methods.AuthenticationSession, parameters: parameters){
            result, error in
            if let error = error {
                completionHandler(success: false, errorString: error.localizedDescription)
            } else {
                if udacityClient.sharedInstance().isFBLogin {
                    udacityClient.sharedInstance().FBLoginManager?.logOut()
                }
                completionHandler(success: true, errorString: nil)
            }
        }
    }
    
    func createSession(username : String?, password : String?, isFacebookLogin : Bool, completionHandler: (success: Bool, userID: String?, errorString: String?) -> Void) {
        
        //Specify parameters
        var parameters = [String: AnyObject]()
        var jsonBody   = [String: AnyObject]()
        //specify jsonBody for post request
        if isFacebookLogin {
            jsonBody = [ udacityClient.JSONBodyKeys.FBCredentialContainer :
                [
                    udacityClient.JSONBodyKeys.FBTokenKey: FBSDKAccessToken.currentAccessToken().tokenString
                ]
            ]
        } else {
            jsonBody = [ udacityClient.JSONBodyKeys.CredentialContainer :
                [
                    udacityClient.JSONBodyKeys.Username: username!,
                    udacityClient.JSONBodyKeys.Password: password!
                ]
            ]
        }
        //make request
        let task = taskForPOSTMethod(udacityClient.Methods.AuthenticationSession, parameters: parameters, jsonBody: jsonBody) { JSONResult, error in
            
            // determine how to use completion handler by checking on certain circumstances - i.e. if there is something in error, most likely connection went wrong, if no error something got returned ... by checking if there is an errormessage in the JSONResult it's determined if there was something wrong with credentials
            if let error = error {
                completionHandler(success: false, userID: nil, errorString: error.localizedDescription)
            } else {
                if let error = JSONResult.valueForKey(udacityClient.JSONResponseKeys.ErrorMessage) as? String {
                    completionHandler(success: false, userID: nil, errorString: JSONResult.valueForKey(udacityClient.JSONResponseKeys.ErrorMessage) as? String)
                } else {
                    var userID = JSONResult.valueForKey(udacityClient.JSONResponseKeys.AccountContainer)?.valueForKey(udacityClient.JSONResponseKeys.UserID) as! String
                    let userIDInt = userID.toInt()
                    completionHandler(success: true, userID: userID, errorString: nil)
                }
            }
        }
    }
}
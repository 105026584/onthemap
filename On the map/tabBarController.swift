//
//  tabBarController.swift
//  On the map
//
//  Created by Andreas Pfister on 23/08/15.
//  Copyright (c) 2015 iOS Development Blog. All rights reserved.
//

import Foundation
import UIKit

class tabBarController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        
        let pin = UIBarButtonItem(image:UIImage(named:"pin"), style:.Plain, target:self, action:"pin")
        let spacer = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        let logout = UIBarButtonItem(title: "Logout", style: .Plain, target: self, action: "logout")
        
        //initial setup, put a spacer, this one will be replaced in the child viewcontrollers by their respective reload function
        self.navigationItem.rightBarButtonItems = [spacer,pin]
        self.navigationItem.leftBarButtonItem = logout
        self.navigationItem.title = "On The Map"
        self.navigationItem.hidesBackButton = false
    }
    
    func pin() {
        if let existingObject = udacityClient.sharedInstance().userLocation?.objectId {
            var alert = UIAlertView(title: nil, message: "You already posted a location!\nIf you go ahead the existing one will be overwritten, if you do not want to do that, you can cancel this action on the appearing screen", delegate: self, cancelButtonTitle: "Ok")
            alert.show()
        }
        let controller = self.storyboard!.instantiateViewControllerWithIdentifier("postInformationView") as! PostInformationViewController
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    func logout() {
        
        udacityClient.sharedInstance().destroySession() { result, error in
            if let error = error {
                var alert = UIAlertView(title: nil, message: "Logout unsuccessful", delegate: self, cancelButtonTitle: "Ok")
                alert.show()
            } else {
                let controller = self.storyboard!.instantiateViewControllerWithIdentifier("UILogin") as! LoginViewController
                self.presentViewController(controller, animated: true, completion: nil)
            }
        }
    }
}
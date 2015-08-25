//
//  ViewController.swift
//  On the map
//
//  Created by Andreas Pfister on 16/08/15.
//  Copyright (c) 2015 iOS Development Blog. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class LoginViewController: KeyboardSensitiveUIViewController {
    
    var backgroundGradient: CAGradientLayer? = nil
    @IBOutlet weak var headerTextLabel: UILabel!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var debugTextLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var blurEffect: UIVisualEffectView!
    @IBOutlet weak var loadIndicator: UIActivityIndicatorView!
    @IBOutlet weak var udacityLogo: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureUI()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        debugTextLabel.text = ""
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }

    @IBAction func loginFB(sender: AnyObject) {
        udacityClient.sharedInstance().FBLoginManager = FBSDKLoginManager()
        udacityClient.sharedInstance().FBLoginManager!.logInWithReadPermissions(["public_profile", "email"]) { (result, error) in
            if let error = error {
                self.displayError(error.localizedDescription)
            } else {
                if let result = result {
                    //We have a token now, let's ask the udacity Client to finish the logon with it
                    self.blurEffect.hidden = false
                    self.loadIndicator.startAnimating()
                    udacityClient.sharedInstance().authenticateWithLoginViewController(self, isFacebookLogin: true) { (success, errorString) in
                        if success {
                            self.completeLogin()
                        } else {
                            self.displayError(errorString)
                        }
                    }
                } else {
                    self.displayError("Could not authenticate, please try again later !")
                }
            }
        }
    }
    
    @IBAction func login(sender: UIButton) {
        self.blurEffect.hidden = false
        self.loadIndicator.startAnimating()
        udacityClient.sharedInstance().authenticateWithLoginViewController(self, isFacebookLogin: false) { (success, errorString) in
            if success {
                self.completeLogin()
            } else {
                self.displayError(errorString)
            }
        }
    }
    
    @IBAction func signupLink(sender: AnyObject) {
        let app = UIApplication.sharedApplication()
        app.openURL(NSURL(string: udacityClient.Constants.SignUpURL)!)
    }
    
    func completeLogin() {
        dispatch_async(dispatch_get_main_queue(), {
            self.debugTextLabel.text = ""
            let controller = self.storyboard!.instantiateViewControllerWithIdentifier("mapAndTableViewController") as! UINavigationController
            self.presentViewController(controller, animated: true, completion: nil)
            
        })
    }
    
    func displayError(errorString: String?) {
        dispatch_async(dispatch_get_main_queue(), {
            
            self.blurEffect.hidden = true
            self.loadIndicator.hidden = true
            
            if let errorString = errorString {
                self.debugTextLabel.text = errorString

                let boundsUser = self.usernameTextField.bounds
                let boundsPwd = self.passwordTextField.bounds
                
                UIView.animateWithDuration(1.5, delay: 0.0, usingSpringWithDamping: 0.2, initialSpringVelocity: 10, options: nil, animations: {
                    self.usernameTextField.bounds = CGRect(x: boundsUser.origin.x - 20, y: boundsUser.origin.y, width: boundsUser.size.width + 60, height: boundsUser.size.height)
                }, completion: nil )
                
                UIView.animateWithDuration(1.5, delay: 0.2, usingSpringWithDamping: 0.2, initialSpringVelocity: 10, options: nil, animations: {
                    self.passwordTextField.bounds = CGRect(x: boundsPwd.origin.x - 20, y: boundsPwd.origin.y, width: boundsPwd.size.width + 60, height: boundsPwd.size.height)
                    }, completion: nil )
            }
        })
    }
    
    
}


// MARK: - Helper

extension LoginViewController {
    
    //TODO: check on Udacity Orange Colors and adapt values below
    
    func configureUI() {
        
        // 255, 177, 0 = 1 , 0.694, 0
        // 254, 199, 83 = 1 , 0.780, 0.325
        
        // 255, 151, 33
        
        /* Configure background gradient */
        self.view.backgroundColor = UIColor.clearColor()
        //let colorTop = UIColor(red: 0.345, green: 0.839, blue: 0.988, alpha: 1.0).CGColor
        let colorTop = UIColor(red: 1, green: 0.680, blue: 0.225, alpha: 1.0).CGColor
        //let colorBottom = UIColor(red: 0.023, green: 0.569, blue: 0.910, alpha: 1.0).CGColor
        let colorBottom = UIColor(red: 1, green: 0.594, blue: 0.128, alpha: 1.0).CGColor
        self.backgroundGradient = CAGradientLayer()
        self.backgroundGradient!.colors = [colorTop, colorBottom]
        self.backgroundGradient!.locations = [0.0, 1.0]
        self.backgroundGradient!.frame = view.frame
        self.view.layer.insertSublayer(self.backgroundGradient, atIndex: 0)
        
        /* Configure header text label */
        headerTextLabel.font = UIFont(name: "Roboto-Medium", size: 16.0)
        headerTextLabel.textColor = UIColor.whiteColor()
        
        /* Configure email textfield */
        let emailTextFieldPaddingViewFrame = CGRectMake(0.0, 0.0, 13.0, 0.0);
        let emailTextFieldPaddingView = UIView(frame: emailTextFieldPaddingViewFrame)
        usernameTextField.leftView = emailTextFieldPaddingView
        usernameTextField.leftViewMode = .Always
        usernameTextField.font = UIFont(name: "Roboto-Regular", size: 17.0)
        usernameTextField.backgroundColor = UIColor(red: 1, green: 0.7, blue: 0, alpha:1.0)
        usernameTextField.textColor = UIColor.whiteColor()
        usernameTextField.attributedPlaceholder = NSAttributedString(string: usernameTextField.placeholder!, attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
        usernameTextField.tintColor = UIColor(red: 0.0, green:0.502, blue:0.839, alpha: 1.0)
        
        /* Configure password textfield */
        let passwordTextFieldPaddingViewFrame = CGRectMake(0.0, 0.0, 13.0, 0.0);
        let passwordTextFieldPaddingView = UIView(frame: passwordTextFieldPaddingViewFrame)
        passwordTextField.leftView = passwordTextFieldPaddingView
        passwordTextField.leftViewMode = .Always
        passwordTextField.font = UIFont(name: "Roboto-Medium", size: 17.0)
        passwordTextField.backgroundColor = UIColor(red: 1, green: 0.7, blue: 0, alpha:1.0)
        passwordTextField.textColor = UIColor.whiteColor()
        passwordTextField.attributedPlaceholder = NSAttributedString(string: passwordTextField.placeholder!, attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
        passwordTextField.tintColor = UIColor(red: 0.0, green:0.502, blue:0.839, alpha: 1.0)
        
        /* Configure signup text label */
        signUpButton.titleLabel?.font = UIFont(name: "Roboto-Medium", size: 18)
        signUpButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        
        /* Configure debug text label */
        debugTextLabel.font = UIFont(name: "Roboto-Regular", size: 12)
        debugTextLabel.textColor = UIColor.redColor()
        udacityLogo.highlighted = true
        
    }
}

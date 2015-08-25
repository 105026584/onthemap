//
//  TableViewController.swift
//  On the map
//
//  Created by Andreas Pfister on 23/08/15.
//  Copyright (c) 2015 iOS Development Blog. All rights reserved.
//

import Foundation
import UIKit

class TableViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet weak var locationsTableView: UITableView!
    @IBOutlet weak var loadIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //exchange reload button
        let reload = UIBarButtonItem(barButtonSystemItem: .Refresh, target: self, action: "reloadData")
        self.tabBarController!.navigationItem.rightBarButtonItems?.removeAtIndex(0)
        self.tabBarController!.navigationItem.rightBarButtonItems?.insert(reload, atIndex: 0)
        
        reloadData()
    }
    
    func reloadData() {
        loadIndicator.startAnimating()
        parseClient.sharedInstance().getStudentLocations { locations, error in
            if let locations = locations {
                dispatch_async(dispatch_get_main_queue()) {
                    self.locationsTableView.reloadData()
                    self.loadIndicator.stopAnimating()
                }
            } else {
                var alert = UIAlertView(title: nil, message: error?.localizedDescription, delegate: self, cancelButtonTitle: "Dismiss")
                alert.show()
                self.loadIndicator.stopAnimating()
            }
        }

    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parseClient.sharedInstance().studentLocations.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let CellReuseId = "locationCell"
        let location = parseClient.sharedInstance().studentLocations[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier(CellReuseId) as! UITableViewCell
        
        /* Set cell defaults */
        cell.textLabel!.text = "\(location.lastName) \(location.firstName)"
        cell.imageView!.image = UIImage(named: "pin")
        cell.imageView!.contentMode = UIViewContentMode.ScaleAspectFit
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let location = parseClient.sharedInstance().studentLocations[indexPath.row]
        let app = UIApplication.sharedApplication()
        app.openURL(NSURL(string: location.mediaURL!)!)
    }

}
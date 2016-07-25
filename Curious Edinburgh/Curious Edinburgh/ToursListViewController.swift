//
//  ToursListViewController.swift
//  Curious Edinburgh
//
//  Created by Ian Fieldhouse on 22/07/2016.
//  Copyright © 2016 Edina. All rights reserved.
//

import UIKit


class ToursListViewController: UITableViewController {
    let defaults = NSUserDefaults.standardUserDefaults()
    var tours: [String]? {
        get {
            if let array = self.defaults.arrayForKey(Constants.UseDefaults.tours) as? [String] {
                return array
            } else {
                return []
            }
        }
    }
    
    func dismissViewController() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let tours = self.tours {
            return tours.count
        } else {
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell
        var label = self.tours![indexPath.row]
        label = label.stringByReplacingOccurrencesOfString("_stop", withString: "")
        label = label.stringByReplacingOccurrencesOfString("_", withString: " ")
        label = label.capitalizedString
        cell.textLabel?.text = label
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.defaults.setObject(self.tours![indexPath.row], forKey: Constants.UseDefaults.tour)
        NSNotificationCenter.defaultCenter().postNotificationName(Constants.Notifications.TourSelected, object: nil)
        self.dismissViewController()
    }
}
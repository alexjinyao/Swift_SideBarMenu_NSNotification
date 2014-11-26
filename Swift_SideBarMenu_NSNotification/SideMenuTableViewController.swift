//
//  SideMenuTableViewController.swift
//  Swift_SideBarMenu_NSNotification
//
//  Created by Jin on 11/25/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

import UIKit

class SideMenuTableViewController: UITableViewController {
    
    // The array of content view's name will display in the sidebar's table view
    var menuTitles:NSArray!

    override func viewDidLoad() {
        super.viewDidLoad()

        // init the menuTitles array
        menuTitles = ["Tab", "Table", "Green"]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuTitles.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as UITableViewCell

        cell.textLabel?.text = menuTitles.objectAtIndex(indexPath.row) as? String
        
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // when user select row post a notification to the notification center which carry a property "selectRow": rownumber
        let notification:NSNotification = NSNotification(name: "didSelectRow", object: self, userInfo: ["selectRow":indexPath.row])
        NSNotificationCenter.defaultCenter().postNotification(notification)
    }
    
}

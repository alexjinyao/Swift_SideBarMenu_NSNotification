//
//  YellowViewController.swift
//  Swift_SideBarMenu_NSNotification
//
//  Created by Jin on 11/25/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

import UIKit

class YellowViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func menuButtonTouched(sender: AnyObject) {
        // when the menu button touched
        // send the menu button touched notification to the notification center
        var notification:NSNotification = NSNotification(name: "menuButtonTouched", object: self)
        NSNotificationCenter.defaultCenter().postNotification(notification)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

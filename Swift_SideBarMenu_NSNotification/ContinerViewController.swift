//
//  ContinerViewController.swift
//  Swift_SideBarMenu_NSNotification
//
//  Created by Jin on 11/25/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

import UIKit

class ContinerViewController: UIViewController {
    
    // The array contain all viewcontrollers
    var viewControllers:NSArray!
    
    // side menu viewcontrollers
    var sideMenuViewController:UITableViewController!
    
    // the index of the current visible view controller
    var indexOfVisibleController:NSInteger!
    
    // if true side menu is on screen, false side menu is hidden
    var isMenuVisible:Bool!
    
    var swipRightGesture:UISwipeGestureRecognizer!
    var swipLeftGesture:UISwipeGestureRecognizer!
    
    // the blur effect view when sidebar menu is visible add it to the content view
    var blurEffect:UIVisualEffectView!
    
    func initViewControllers(){
        let storyBoard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let greenController:UINavigationController = storyBoard.instantiateViewControllerWithIdentifier("GreenNa") as UINavigationController
        
        viewControllers = [greenController]
        
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        indexOfVisibleController = 0;
        isMenuVisible = false;
        
        // get the sidemenuVC from the storyboard
        var storyBoard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        sideMenuViewController = storyBoard.instantiateViewControllerWithIdentifier("SideMenuVC") as UITableViewController
        
        // set sidemenuVC frame as continerVC's frame
        sideMenuViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
        
        // add sidemenu viewcontroller and view to continerVC
        self.addChildViewController(sideMenuViewController)
        self.view.addSubview(sideMenuViewController.view)
        
        // init the viewcontrollers array
        self.initViewControllers()
        
        // init the current view as the first view in the viewcontrollers array
        var visibleViewController:UINavigationController = viewControllers[0] as UINavigationController
        
        visibleViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
        
        // add the controller to continer view
        self.addChildViewController(visibleViewController)
        self.view.addSubview(visibleViewController.view)
        
        
        // add self as teh recever of menuButtonTouched notification
        var center:NSNotificationCenter = NSNotificationCenter.defaultCenter()
        center.addObserver(self, selector: "handleMenuButtonTouched", name: "menuButtonTouched", object: nil)
        
        // init and add the swip right gesture
        swipRightGesture = UISwipeGestureRecognizer()
        swipRightGesture.direction = UISwipeGestureRecognizerDirection.Right
        swipRightGesture.numberOfTouchesRequired = 1
        swipRightGesture.addTarget(self, action: "handleSwipeGesture:")
        self.view.addGestureRecognizer(swipRightGesture)
        
        // init and add the swip left gesture
        swipLeftGesture = UISwipeGestureRecognizer()
        swipLeftGesture.direction = UISwipeGestureRecognizerDirection.Left
        swipLeftGesture.numberOfTouchesRequired = 1
        swipLeftGesture.addTarget(self, action: "handleSwipeGesture:")
        self.view.addGestureRecognizer(swipLeftGesture)
        
        // init the blur effect view
        var blur:UIBlurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
        blurEffect = UIVisualEffectView(effect: blur)
    }
    
    func handleSwipeGesture(gesture:UISwipeGestureRecognizer){
        
        if (gesture == swipLeftGesture){
            // if currently the sidebar menu is visible, then user swip left will close the sied bar menu
            if(isMenuVisible == true){
                handleMenuButtonTouched()
            }
        }
        
        if(gesture == swipRightGesture){
            //if currently the side bar menu is not visible, then user swip roght will open the side bar menu
            if(isMenuVisible == false){
                handleMenuButtonTouched()
            }
        }
    }
    
    
    func handleMenuButtonTouched(){
        let visibleViewController:UIViewController = viewControllers[indexOfVisibleController] as UIViewController
        
        // if currently the menu bar is showing on, then we move the visibleViewController to left to hidden the sidebar menu
        if (isMenuVisible==true){
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                visibleViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
                
            })
            
            visibleViewController.view.addSubview(self.blurEffect)
            // after hidden the menu bar we change isMenuVisible to false
            isMenuVisible = !isMenuVisible
            
            
            
        }else{
            // if currently the menu bar is hidden, then we move the visibleViewController to right to show the sidebar menu
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                visibleViewController.view.frame = CGRectMake(self.view.frame.size.width/3, 0, self.view.frame.size.width, self.view.frame.size.height)
                
            })
            
            self.blurEffect.removeFromSuperview()
            // after show the menu bar on screen we change the value to true
            isMenuVisible = !isMenuVisible
            
            
            // if side menu is on screen add the blur effect to the content view, since it's lost the focuse
            
        
        }
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

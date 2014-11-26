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
    
    func initViewControllers(){
        let storyBoard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let greenController:UINavigationController = storyBoard.instantiateViewControllerWithIdentifier("GreenNa") as UINavigationController
        let navController:UINavigationController = storyBoard.instantiateViewControllerWithIdentifier("TableNa") as UINavigationController
        
        let tabController:UITabBarController = storyBoard.instantiateViewControllerWithIdentifier("TabBarNa") as UITabBarController
        
        viewControllers = [ tabController, navController, greenController]
        
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
        // cause we have different type of VCs so define the visibleViewController as uiviewcontroller
        var visibleViewController:UIViewController = viewControllers[indexOfVisibleController] as UIViewController
        
        visibleViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
        
        // add the controller to continer view
        self.addChildViewController(visibleViewController)
        self.view.addSubview(visibleViewController.view)
        
        
        // add self as teh recever of menuButtonTouched notification and didSelectRow notification
        var center:NSNotificationCenter = NSNotificationCenter.defaultCenter()
        center.addObserver(self, selector: "handleMenuButtonTouched", name: "menuButtonTouched", object: nil)
        center.addObserver(self, selector: "handleDidSelectRow:", name: "didSelectRow", object: nil)
        
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

    }
    
    func handleDidSelectRow(paramNotification:NSNotification){
        let temp:[NSObject: AnyObject] = paramNotification.userInfo!
        let incommingVCIndex:Int = temp["selectRow"] as Int
        replaceVisibleViewControllerWithViewControllerAtIndex(incommingVCIndex)
        
    }
    
    func replaceVisibleViewControllerWithViewControllerAtIndex(index:Int){
        // if select row equals to current visible viewcontroller
        // we call handleMenuTouched func to move it back
        println("The incomming vc's index is \(index)")
        if(index == indexOfVisibleController){
            handleMenuButtonTouched()
            return
        }
        
        // else we move the incomming viewcontroller in and move the current viewcontroller out
        var incommingViewController:UIViewController = viewControllers[index] as UIViewController
        incommingViewController.view.frame = CGRectMake(self.view.bounds.size.width, 0, self.view.frame.size.width, self.view.frame.size.height)
        
        var outgoingViewController:UIViewController = viewControllers[indexOfVisibleController] as UIViewController
        
        outgoingViewController.willMoveToParentViewController(nil)
        
        self.addChildViewController(incommingViewController)
        
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        
        self.transitionFromViewController(outgoingViewController, toViewController: incommingViewController, duration: 0.5, options: nil, animations: { () -> Void in
            outgoingViewController.view.frame = CGRectMake(self.view.bounds.size.width, 0, self.view.bounds.size.width, self.view.bounds.size.height)
        }) { (Bool) -> Void in
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                outgoingViewController.view.removeFromSuperview()
                self.view.addSubview(incommingViewController.view)
                incommingViewController.view.frame = self.view.bounds
                UIApplication.sharedApplication().endIgnoringInteractionEvents()
                
                self.isMenuVisible = false
                self.indexOfVisibleController = index
            })
        }
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
            // after hidden the menu bar we change isMenuVisible to false
            isMenuVisible = !isMenuVisible
            
        }else{
            // if currently the menu bar is hidden, then we move the visibleViewController to right to show the sidebar menu
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                visibleViewController.view.frame = CGRectMake(self.view.frame.size.width/3, 0, self.view.frame.size.width, self.view.frame.size.height)
                
            })
            
            // after show the menu bar on screen we change the value to true
            isMenuVisible = !isMenuVisible
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

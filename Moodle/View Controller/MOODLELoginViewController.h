/*
 *  MOODLELoginViewController.h
 *  Moodle
 *
 *  Created by Simon Gaus on 03.06.17.
 *  Copyright © 2017 Simon Gaus. All rights reserved.
 *
 */

@import UIKit;



///-----------------------
/// @name CONSTANTS
///-----------------------



/**
 The storyboard identifier for this view controller.
 */
static NSString *MOODLELoginViewControllerIdentifier = @"MOODLELoginViewControllerIdentifier";
/**
 The notification that is posted when successfully logged in.
 */
static NSString *MOODLEDidLoginNotification = @"MOODLEDidLoginNotification";



/**
 
 The `MOODLELoginViewController` is responsible for presenting a login form to the user.
 
 */

NS_ASSUME_NONNULL_BEGIN

@interface MOODLELoginViewController : UIViewController
@end
NS_ASSUME_NONNULL_END

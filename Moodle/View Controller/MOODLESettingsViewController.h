/*
 *  MOODLESettingsViewController.h
 *  Moodle
 *
 *  Created by Simon Gaus on 03.06.17.
 *  Copyright © 2017 Simon Gaus. All rights reserved.
 *
 */

@import UIKit;

NS_ASSUME_NONNULL_BEGIN



///-----------------------
/// @name CONSTANTS
///-----------------------



/**
 The notification that is posted when the user wants to logout.
 */
static NSString *MOODLEShouldLogoutNotification = @"MOODLEShouldLogoutNotification";



/**
 
 The `MOODLESettingsViewController` is responsible for presenting the app settings to the user. 
 Here the user can manage and unhide Moodle courses he previously set hidden.
 
 */

@interface MOODLESettingsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@end
NS_ASSUME_NONNULL_END

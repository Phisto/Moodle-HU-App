/*
 *
 *  MOODLEProgressViewController.h
 *  Moodle
 *
 *  Copyright © 2017 Simon Gaus. All rights reserved.
 *
 */

@import UIKit;

NS_ASSUME_NONNULL_BEGIN



///-----------------------
/// @name CONSTANTS
///-----------------------



/**
 The storyboard identifier for this view controller.
 */
static NSString *MOODLEProgressViewControllerIdentifier = @"MOODLEProgressViewControllerIdentifier";



/**
 
 The `MOODLESettingsViewController` is responsible for showing a undetermined progress indicator to the user.
 
 */

@interface MOODLEProgressViewController : UIViewController
#pragma mark - Properties
///--------------------
/// @name Properties
///--------------------

/**
 Boolean indicating if the re-login label should be visible.
 */
@property (nonatomic, readwrite) BOOL shouldShowReloginLabel;

@end
NS_ASSUME_NONNULL_END

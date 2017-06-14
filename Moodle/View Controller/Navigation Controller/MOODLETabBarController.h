/*
 *  MOODLETabBarController.h
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
static NSString *MOODLETabBarControllerIdentifier = @"MOODLETabBarControllerIdentifier";



/**
 
 The `MOODLETabBarController` is a custom tab bar controller. It does change some behaviour andd appereance of the standart tab bar controller.
 
 */

NS_ASSUME_NONNULL_BEGIN

@interface MOODLETabBarController : UITabBarController <UITabBarControllerDelegate>
@end
NS_ASSUME_NONNULL_END

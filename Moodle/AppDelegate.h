/*
 *
 *  AppDelegate.h
 *  Moodle
 *
 *  Copyright © 2017 Simon Gaus. All rights reserved.
 *
 */

@import UIKit;

/**
 
 The delegate of the app object.
 
 */

NS_ASSUME_NONNULL_BEGIN

@interface AppDelegate : UIResponder <UIApplicationDelegate>
#pragma mark - Properties
///--------------------
/// @name Properties
///--------------------

/**
 The window object of the app.
 */
@property (nonatomic, strong) UIWindow *window;

@end
NS_ASSUME_NONNULL_END


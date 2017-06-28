/*
 *  UIColor+Moodle.h
 *  Moodle
 *
 *  Created by Simon Gaus on 03.06.17.
 *  Copyright © 2017 Simon Gaus. All rights reserved.
 *
 */

@import UIKit;

/**
 
 A convenient UIColor category to give easy access to custom colors spezific to the Moodle app.
 
 */

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (Moodle)
#pragma mark - Methodes
///---------------------------
/// @name Custom Colors
///---------------------------

/**
 The blue color used for the Moodle app.
 */
+ (instancetype)moodle_blueColor;
/**
 The color used for the table view cell unhide action.
 */
+ (instancetype)moodle_unhideActionColor;
/**
 The color used for the table view cell hide action.
 */
+ (instancetype)moodle_hideActionColor;
/**
 The color used for the table view cell favorite action.
 */
+ (instancetype)moodle_favoriteActionColor;
/**
 The brownish color used for the Moodle app.
 */
+ (instancetype)moodle_brownColor;

@end
NS_ASSUME_NONNULL_END

/*
 *  MOODLEActivityView.h
 *  Moodle
 *
 *  Created by Simon Gaus on 03.06.17.
 *  Copyright © 2017 Simon Gaus. All rights reserved.
 *
 */

@import UIKit;

/**
 
 This is a convenient UIView to display a darkish translucent
 hud view with an undetermined progress indicator and an optional label.
 
 */

NS_ASSUME_NONNULL_BEGIN

@interface MOODLEActivityView : UIView
#pragma mark - Inititalization
///---------------------------
/// @name Inititalization
///---------------------------

/**
 
 Creates and returns a configured labeled activity view.
 
 @param text The text of the label.
 
 @return A labeled activit view.
 
 */
+ (instancetype)activityViewWithText:(NSString *)text;
/**
 
 Creates and returns a configured activity view.
 
 @return An unlabeled activit view.
 
 */
+ (instancetype)activityView;

@end
NS_ASSUME_NONNULL_END

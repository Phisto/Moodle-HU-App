/*
 *
 *  HUProgressIndicator.h
 *  Moodle
 *
 *  Copyright © 2017 Simon Gaus. All rights reserved.
 *
 */

@import UIKit;


NS_ASSUME_NONNULL_BEGIN


/**
 
 The style of the indicator. This will determin the size of the indicator.
 
 */
typedef NS_ENUM(NSInteger, HUProgressIndicatorStyle) {
    /// The default style.
    HUProgressIndicatorStyleDefault = 0,
    /// The style for a small indicator (width: 80 heigth: 80). The default style.
    HUProgressIndicatorStyleSmall = HUProgressIndicatorStyleDefault,
    /// The style for a large indicator (width: 120 heigth: 120). The default style.
    HUProgressIndicatorStyleLarge = 1,
};


/**
 
 A view that shows that a task is in progress.
 
 ## Overview
 
 The HUProgressIndicator comes in two sizes, width/heigth 80 or width/heigth 120.
 You control when an activity indicator animates 
 by calling the startAnimating and stopAnimating methods.
 To automatically hide the activity indicator when animation stops, 
 set the hidesWhenStopped property to YES.
 
 You can set the color of the activity indicator by using the color property.
 
 */


IB_DESIGNABLE


@interface HUProgressIndicator : UIView
#pragma mark - Properties
///---------------------------
/// @name Properties
///---------------------------

/**
 A Boolean value indicating whether the activity indicator is currently running its animation.
 */
@property (nonatomic, readwrite) IBInspectable HUProgressIndicatorStyle style;
/**
 A Boolean value indicating whether the activity indicator is currently running its animation.
 */
@property (nonatomic, readwrite, getter=isAnimating) IBInspectable BOOL animating;
/**
 A Boolean value that controls whether the receiver is hidden when the animation is stopped.
 */
@property (nonatomic, readwrite) IBInspectable BOOL hidesWhenStopped;
/**
 The color of the activity indicator.
 */
@property (nonatomic, strong) IBInspectable UIColor *color;

#pragma mark - Methodes
///---------------------------
/// @name Animation
///---------------------------

/**
 Starts the animation of the progress indicator.
 */
- (void)startAnimating;
/**
 Stops the animation of the progress indicator.
 */
- (void)stopAnimating;

@end
NS_ASSUME_NONNULL_END

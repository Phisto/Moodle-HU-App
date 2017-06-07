//
//  HUProgressIndicator.h
//  HUProgressIndicator
//
//  Created by Simon Gaus on 05.06.17.
//  Copyright © 2017 Simon Gaus. All rights reserved.
//

@import UIKit;


NS_ASSUME_NONNULL_BEGIN


typedef NS_ENUM(NSInteger, HUProgressIndicatorStyle) {
    
    HUProgressIndicatorStyleDefault = 1,
    HUProgressIndicatorStyleSmall = 1,
    HUProgressIndicatorStyleLarge = 2,
};


/**
 
 A view that shows that a task is in progress.
 
 ## Overview
 
 You control when an activity indicator animates by calling the startAnimating and stopAnimating methods. 
 To automatically hide the activity indicator when animation stops, set the hidesWhenStopped property to YES.
 
 You can set the color of the activity indicator by using the color property.
 
 */


IB_DESIGNABLE


@interface HUProgressIndicator : UIView

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

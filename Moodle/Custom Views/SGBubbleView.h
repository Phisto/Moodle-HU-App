//
//  SGBubbleView.h
//  Moodle
//
//  Created by Simon Gaus on 07.07.17.
//  Copyright © 2017 Simon Gaus. All rights reserved.
//

@import UIKit;

/**
 
 
 An UIView subclass drawing as a 'bubble'.
 
 
 */

NS_ASSUME_NONNULL_BEGIN

IB_DESIGNABLE

@interface SGBubbleView : UIView

/**
 The color of the bubble.
 */
@property (nonatomic, strong) IBInspectable UIColor *bubbleColor;

@end
NS_ASSUME_NONNULL_END

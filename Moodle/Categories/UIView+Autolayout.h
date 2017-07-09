/*
 *
 *  UIView+Autolayout.h
 *  Moodle
 *
 *  Copyright © 2017 Simon Gaus. All rights reserved.
 *
 */

@import UIKit;

/**
 
 This category is a convenient categorie to install autolayout contraints on view's.
 
 */

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Autolayout)

/**
 
 This method will create and activate constraints that will pin the view to its superview with the given margins via autolayout.
 
 @param superview The superview.
 
 @param leading The leading margin.
 
 @param trailing The trailing margin.
 
 @param top The top margin.
 
 @param bottom The bottom margin.
 
 @return YES if the constraints are installed successfully, otherwise NO.
 
 */
- (BOOL)makeAutolayoutToFitSuperview:(UIView *)superview leadingMargin:(CGFloat)leading trailingMargin:(CGFloat)trailing topMargin:(CGFloat)top bottomMargin:(CGFloat)bottom;


@end
NS_ASSUME_NONNULL_END

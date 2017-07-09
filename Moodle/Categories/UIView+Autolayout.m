/*
 *
 *  UIView+Autolayout.h
 *  Moodle
 *
 *  Copyright © 2017 Simon Gaus. All rights reserved.
 *
 */

#import "UIView+Autolayout.h"

///-----------------------
/// @name IMPLEMENTATION
///-----------------------



@implementation UIView (Autolayout)
#pragma mark - Autolayout Methodes


- (BOOL)makeAutolayoutToFitSuperview:(UIView *)superview leadingMargin:(CGFloat)leading trailingMargin:(CGFloat)trailing topMargin:(CGFloat)top bottomMargin:(CGFloat)bottom {

    if (![self isDescendantOfView:superview]) {
        
        NSLog(@"makeAutolayout... view is not subview of superview.");
        return NO;
    }
    
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.leadingAnchor constraintEqualToAnchor:superview.leadingAnchor constant:leading].active = YES;
    [self.trailingAnchor constraintEqualToAnchor:superview.trailingAnchor constant:-trailing].active = YES;
    [self.topAnchor constraintEqualToAnchor:superview.topAnchor constant:top].active = YES;
    [self.bottomAnchor constraintEqualToAnchor:superview.bottomAnchor constant:-bottom].active = YES;
    
    return YES;
}


#pragma mark -
@end

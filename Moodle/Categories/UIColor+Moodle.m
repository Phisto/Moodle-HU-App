/*
 *
 *  UIColor+Moodle.m
 *  Moodle
 *
 *  Copyright © 2017 Simon Gaus. All rights reserved.
 *
 */

#import "UIColor+Moodle.h"

///-----------------------
/// @name IMPLEMENTATION
///-----------------------



@implementation UIColor (Moodle)
#pragma mark - Custom Colors


+ (instancetype)moodle_unhideActionColor {
    
    return [UIColor colorWithRed:(231.0f/255.0f)
                           green:(76.0f/255.0f)
                            blue:(60.0f/255.0f)
                           alpha:1.0f];
}


+ (instancetype)moodle_hideActionColor {
    
    return [UIColor colorWithRed:(231.0f/255.0f)
                           green:(76.0f/255.0f)
                            blue:(60.0f/255.0f)
                           alpha:1.0f];
}


+ (instancetype)moodle_favoriteActionColor {
    
    return [UIColor colorWithRed:(189.0f/255.0f)
                           green:(195.0f/255.0f)
                            blue:(199.0f/255.0f)
                           alpha:1.0f];
}


+ (instancetype)moodle_blueColor {
    
    /*
    return [UIColor colorWithRed:(3.0f/255.0f)
                           green:(102.0f/255.0f)
                            blue:(148.0f/255.0f)
                           alpha:1.0f];
    */
    
    return [UIColor colorWithRed:(2.0f/255.0f)
                           green:(123.0f/255.0f)
                            blue:(161.0f/255.0f)
                           alpha:1.0f];
}


+ (instancetype)moodle_brownColor {
    
    return [UIColor colorWithRed:(204.0f/255.0f)
                           green:(204.0f/255.0f)
                            blue:(153.0f/255.0f)
                           alpha:1.0f];
}


#pragma mark -
@end

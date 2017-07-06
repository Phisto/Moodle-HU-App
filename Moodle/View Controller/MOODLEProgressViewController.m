/*
 *
 *  MOODLEProgressViewController.m
 *  Moodle
 *
 *  Copyright © 2017 Simon Gaus. All rights reserved.
 *
 */

#import "MOODLEProgressViewController.h"

#import "HUProgressIndicator.h"

///-----------------------
/// @name CATEGORIES
///-----------------------



@interface MOODLEProgressViewController (/* Private */)

// UI
@property (nonatomic, strong) IBOutlet HUProgressIndicator *activityIndicatorHU;
@property (nonatomic, strong) IBOutlet UILabel *reloginLabel;

@end



///-----------------------
/// @name IMPLEMENTATION
///-----------------------



@implementation MOODLEProgressViewController
#pragma mark - View Controller Methodes


- (void)viewDidAppear:(BOOL)animated {
    
    // call super
    [super viewDidAppear:animated];
    
    self.reloginLabel.hidden = !self.shouldShowReloginLabel;
}


- (void)viewDidDisappear:(BOOL)animated {
    
    // call super
    [super viewDidDisappear:animated];
    
    [self.activityIndicatorHU stopAnimating];
}


#pragma mark -
@end

/*
 *  MOODLEProgressViewController.m
 *  Moodle
 *
 *  Created by Simon Gaus on 03.06.17.
 *  Copyright © 2017 Simon Gaus. All rights reserved.
 *
 */

#import "MOODLEProgressViewController.h"

#import "HUProgressIndicator.h"

@interface MOODLEProgressViewController (/* Private */)

@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activityIndicator;

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
    [self.activityIndicator startAnimating];
}

- (void)viewDidDisappear:(BOOL)animated {
    
    // call super
    [super viewDidDisappear:animated];
    
    [self.activityIndicator stopAnimating];
}

#pragma mark -
@end

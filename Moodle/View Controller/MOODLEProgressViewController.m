/*
 *  MOODLEProgressViewController.m
 *  Moodle
 *
 *  Created by Simon Gaus on 03.06.17.
 *  Copyright © 2017 Simon Gaus. All rights reserved.
 *
 */

#import "MOODLEProgressViewController.h"

@interface MOODLEProgressViewController (/* Private */)

@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) IBOutlet UILabel *reloginLabel;

@end



///-----------------------
/// @name IMPLEMENTATION
///-----------------------



@implementation MOODLEProgressViewController

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

@end

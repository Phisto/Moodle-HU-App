/*
 *  MOODLEProgressViewController.m
 *  MOODLE
 *
 *  Copyright © 2017 Simon Gaus <simon.cay.gaus@gmail.com>
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU Lesser General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU Lesser General Public License for more details.
 *
 *  You should have received a copy of the GNU Lesser General Public License
 *  along with this programm.  If not, see <http://www.gnu.org/licenses/>.
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

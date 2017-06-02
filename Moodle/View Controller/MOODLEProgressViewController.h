/*
 *  MOODLEProgressViewController.h
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

@import UIKit;

NS_ASSUME_NONNULL_BEGIN



///-----------------------
/// @name CONSTANTS
///-----------------------



/**
 The storyboard identifier for this view controller.
 */
static NSString *MOODLEProgressViewControllerIdentifier = @"MOODLEProgressViewControllerIdentifier";



/**
 
 The `MOODLESettingsViewController` is responsible for showing a undetermined progress indicator to the user.
 
 */

@interface MOODLEProgressViewController : UIViewController
#pragma mark - Properties
///--------------------
/// @name Properties
///--------------------

/**
 Boolean indicating if the re-login label should be visible.
 */
@property (nonatomic, readwrite) BOOL shouldShowReloginLabel;

@end
NS_ASSUME_NONNULL_END

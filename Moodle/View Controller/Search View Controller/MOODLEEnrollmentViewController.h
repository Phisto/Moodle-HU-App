/*
 *  MOODLEEnrollmentViewController.h
 *  Moodle
 *
 *  Created by Simon Gaus on 03.06.17.
 *  Copyright © 2017 Simon Gaus. All rights reserved.
 *
 */

@import UIKit;

/**
 
 The MOODLEEnrollmentViewController is responsible for presenting the enrollment web page to the user.
 
 */

NS_ASSUME_NONNULL_BEGIN

@interface MOODLEEnrollmentViewController : UIViewController <UIWebViewDelegate>
#pragma mark - Properties
///--------------------
/// @name Properties
///--------------------


/**
 The url of the enrollment web page.
 */
@property (nonatomic, strong) NSURL *enrollementURL;


@end
NS_ASSUME_NONNULL_END

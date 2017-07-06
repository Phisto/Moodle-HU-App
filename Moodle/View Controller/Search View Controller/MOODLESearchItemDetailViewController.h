/*
 *
 *  MOODLESearchItemDetailViewController.h
 *  Moodle
 *
 *  Copyright © 2017 Simon Gaus. All rights reserved.
 *
 */

@import UIKit;

@class MOODLECourse;

/**
 
 The MOODLESearchItemDetailViewController is responsible for presenting a `MOODLECourse` object to the user.
 
 */

NS_ASSUME_NONNULL_BEGIN

@interface MOODLESearchItemDetailViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
#pragma mark - Properties
///--------------------
/// @name Properties
///--------------------

/**
 The MOODLECourse to present.
 */
@property (nonatomic, strong) MOODLECourse *item;

@end
NS_ASSUME_NONNULL_END

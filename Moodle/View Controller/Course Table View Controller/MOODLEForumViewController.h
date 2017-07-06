/*
 *
 *  MOODLEForumViewController.h
 *  Moodle
 *
 *  Copyright © 2017 Simon Gaus. All rights reserved.
 *
 */

@import UIKit;

@class MOODLECourse;

/**
 
 The `MOODLEForumViewController` is responsible for presenting the `MOODLEForum` object associated with a given moodle course to the user.
 
 */

NS_ASSUME_NONNULL_BEGIN

@interface MOODLEForumViewController : UIViewController

/**
 The course object the forum is associated with.
 */
@property (nonatomic, strong) MOODLECourse *course;

@end
NS_ASSUME_NONNULL_END

/*
 *  MOODLECourseSectionDetailViewController.h
 *  Moodle
 *
 *  Created by Simon Gaus on 03.06.17.
 *  Copyright © 2017 Simon Gaus. All rights reserved.
 *
 */

@import UIKit;

@class MOODLECourseSection;

/**
 
 The `MOODLECourseSectionDetailViewController` is responsible for presenting a `MOODLECourseSection` object to the user.
 
 */

NS_ASSUME_NONNULL_BEGIN

@interface MOODLECourseSectionDetailViewController : UIViewController
#pragma mark - Properties
///--------------------
/// @name Properties
///--------------------

/**
 The MOODLECourseSection to present.
 */
@property (nonatomic, strong) MOODLECourseSection *section;

@end
NS_ASSUME_NONNULL_END

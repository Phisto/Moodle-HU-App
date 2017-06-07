/*
 *  MOODLECourseViewController.h
 *  Moodle
 *
 *  Created by Simon Gaus on 03.06.17.
 *  Copyright © 2017 Simon Gaus. All rights reserved.
 *
 */

@import UIKit;

@class MOODLEDataModel;

/**
 
 The `MOODLECourseViewController` is responsible for presenting an array of `MOODLECourse` objects to the user.
 
 */

NS_ASSUME_NONNULL_BEGIN

@interface MOODLECourseViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@end
NS_ASSUME_NONNULL_END

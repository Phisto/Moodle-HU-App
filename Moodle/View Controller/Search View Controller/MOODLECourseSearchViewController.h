/*
 *
 *  MOODLECourseSearchViewController.h
 *  Moodle
 *
 *  Copyright © 2017 Simon Gaus. All rights reserved.
 *
 */

@import UIKit;

/**
 
 The MOODLECourseSearchViewController is responsible for presenting a search bar to search for MOODLE courses and displaying the results.
 
 */

NS_ASSUME_NONNULL_BEGIN

@interface MOODLECourseSearchViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>
@end
NS_ASSUME_NONNULL_END

/*
 *
 *  MOODLECourseTableViewCell.h
 *  Moodle
 *
 *  Copyright © 2017 Simon Gaus. All rights reserved.
 *
 */

@import UIKit;

NS_ASSUME_NONNULL_BEGIN



///-----------------------
/// @name CONSTANTS
///-----------------------



/**
 The cell identifier for this table view cell.
 */
static NSString *MOODLECourseTableViewCellIdentifier = @"MOODLECourseTableViewCellIdentifier";



/**

 This class is a custom `UITableViewCell` subclass, which is designed to show all relevant information about a MOODLE course.
 
 */

@interface MOODLECourseTableViewCell : UITableViewCell
#pragma mark - IBOutlets
///-----------------
/// @name IBOutlets
///-----------------

/**
 The label to display the course title.
 */
@property (nonatomic, strong) IBOutlet UILabel *courseTitleLabel;
/**
 The label to display the course moodle title.
 */
@property (nonatomic, strong) IBOutlet UILabel *moodleTitleLabel;
/**
 The label to display the course semester.
 */
@property (nonatomic, strong) IBOutlet UILabel *semesterLabel;

@end
NS_ASSUME_NONNULL_END

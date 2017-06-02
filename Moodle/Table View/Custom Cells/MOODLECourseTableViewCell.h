/*
 *  MOODLECourseTableViewCell.h
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

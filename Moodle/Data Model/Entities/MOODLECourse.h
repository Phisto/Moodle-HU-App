/*
 *  MOODLECourse.h
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

@import Foundation;

@class MOODLECourseSection, MOODLEDataModel;

/**
 
 A MOODLECourse object represents a MOODLE course.
 
 */

NS_ASSUME_NONNULL_BEGIN

@interface MOODLECourse : NSObject
#pragma mark - Properties
///--------------------
/// @name Properties
///--------------------

/**
 The title of the course.
 */
@property (nonatomic, strong) NSString *courseTitle;
/**
 The MOODLE title of the course.
 */
@property (nonatomic, strong) NSString *moodleTitle;
/**
 The url of the course.
 */
@property (nonatomic, strong) NSURL *url;
/**
 The MOODLE ID of the course.
 */
@property (nonatomic, readwrite) NSInteger moodleCourseID;
/**
 The semester of the course.
 */
@property (nonatomic, strong) NSString *semester;
/**
 An array of course sections.
 */
@property (nonatomic, strong) NSArray<MOODLECourseSection *> *courseSections;
/**
 The data model in which the course is stored in.
 */
@property (nonatomic, weak) MOODLEDataModel *dataModel;
/**
 Boolean indicating if the course is flagged as favorit.
 */
@property (nonatomic, readwrite) BOOL isFavourite;
/**
 Boolean indicating if the course is flagged as hidden.
 */
@property (nonatomic, readwrite) BOOL isHidden;
/**
 Integer indicating the priority (e.g. how far at the top) with which the ourse will be displayed in a table view.
 */
@property (nonatomic, readwrite) NSInteger orderingWeight;

@end
NS_ASSUME_NONNULL_END

/*
 *  MOODLESearchItem.h
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

/**
 
 A MOODLESearchItem object represents a search result from a MOODLE course search.
 
 */

NS_ASSUME_NONNULL_BEGIN

@interface MOODLESearchItem : NSObject
#pragma mark - Properties
///--------------------
/// @name Properties
///--------------------

/**
 The title of the search item.
 */
@property (nonatomic, strong) NSString *title;
/**
 An array of responsible persons for the search item.
 */
@property (nonatomic, strong, nullable) NSArray<NSString *> *teacher;
/**
 The course description of the search item.
 */
@property (nonatomic, strong, nullable) NSString *courseDescription;
/**
 The attributed course description of the search item.
 */
@property (nonatomic, readonly, nullable) NSMutableAttributedString *attributedCourseDescription;
/**
 The semester of the search item.
 */
@property (nonatomic, strong, nullable) NSString *semester;
/**
 The course category of the search item.
 */
@property (nonatomic, strong, nullable) NSString *courseCategory;
/**
 Boolean indicating if the user can subsribe to the course.
 */
@property (nonatomic, readonly) BOOL canSubscribe;
/**
 Boolean indicating if the user can subsribe to the course as a guest.
 */
@property (nonatomic, readwrite) BOOL guestSubscribe;
/**
 Boolean indicating if the user can subsribe to the course.
 */
@property (nonatomic, readwrite) BOOL selfSubscribe;
/**
 The url of the search item.
 */
@property (nonatomic, strong) NSURL *courseURL;

@end
NS_ASSUME_NONNULL_END

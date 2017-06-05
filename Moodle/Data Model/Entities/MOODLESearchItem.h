/*
 *  MOODLESearchItem.h
 *  Moodle
 *
 *  Created by Simon Gaus on 03.06.17.
 *  Copyright © 2017 Simon Gaus. All rights reserved.
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

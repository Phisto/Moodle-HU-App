/*
 *
 *  MOODLEForum.h
 *  Moodle
 *
 *  Copyright © 2017 Simon Gaus. All rights reserved.
 *
 */

@import Foundation;

@class MOODLEForumEntry;

/**
 
 A MOODLEForum object represents a forum associated with a MOODLE course.
 
 */

NS_ASSUME_NONNULL_BEGIN

@interface MOODLEForum : NSObject

/**
 The url to the forum.
 */
@property (nonatomic, strong) NSURL *forumURL;
/**
 The threads of the forum.
 */
@property (nonatomic, strong) NSArray<MOODLEForumEntry *> *entries;
/**
 Boolean indicating if the forum has any threads.
 */
@property (nonatomic, readonly) BOOL hasEntries;

@end
NS_ASSUME_NONNULL_END

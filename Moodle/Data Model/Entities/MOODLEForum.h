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
 
 
 
 
 
 */

NS_ASSUME_NONNULL_BEGIN

@interface MOODLEForum : NSObject

/**
 
 */
@property (nonatomic, strong) NSURL *forumURL;
/**
 
 */
@property (nonatomic, strong) NSArray<MOODLEForumEntry *> *entries;
/**
 
 */
@property (nonatomic, readonly) BOOL hasEntries;

@end
NS_ASSUME_NONNULL_END

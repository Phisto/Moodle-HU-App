/*
 *
 *  MOODLEForumEntry.h
 *  Moodle
 *
 *  Copyright © 2017 Simon Gaus. All rights reserved.
 *
 */

@import Foundation;

@class MOODLEForumPost;

/**
 
 
 
 
 
 */

NS_ASSUME_NONNULL_BEGIN

@interface MOODLEForumEntry : NSObject

/**
 
 */
@property (nonatomic, strong) NSString *title;
/**
 
 */
@property (nonatomic, strong) NSString *author;
/**
 
 */
@property (nonatomic, readwrite) NSInteger replies;
/**
 
 */
@property (nonatomic, readwrite) NSInteger unreadReplies;
/**
 
 */
@property (nonatomic, strong) NSArray<MOODLEForumPost *> *posts;
/**
 
 */
@property (nonatomic, strong) NSURL *entryURL;

@end
NS_ASSUME_NONNULL_END

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
 
 A MOODLEForumEntry object represents an entry associated with a forum.
 
 */

NS_ASSUME_NONNULL_BEGIN

@interface MOODLEForumEntry : NSObject

/**
 The title of the entry.
 */
@property (nonatomic, strong) NSString *title;
/**
 The authors name of the entry.
 */
@property (nonatomic, strong) NSString *author;
/**
 The number of replies to the entry.
 */
@property (nonatomic, readwrite) NSInteger replies;
/**
 The number of unread replies to the entry.
 */
@property (nonatomic, readwrite) NSInteger unreadReplies;
/**
 An array with all posts in the forum entry.
 */
@property (nonatomic, strong) NSArray<MOODLEForumPost *> *posts;
/**
 The url of the entry.
 */
@property (nonatomic, strong) NSURL *entryURL;

@end
NS_ASSUME_NONNULL_END

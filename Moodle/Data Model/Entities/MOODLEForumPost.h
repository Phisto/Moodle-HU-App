/*
 *
 *  MOODLEForumPost.h
 *  Moodle
 *
 *  Copyright © 2017 Simon Gaus. All rights reserved.
 *
 */

@import Foundation;

@class MOODLECourseSectionItem;

/**
 
 A MOODLEForumPost object represents an post associated with a forum entry.
 
 */

NS_ASSUME_NONNULL_BEGIN

@interface MOODLEForumPost : NSObject

/**
 The title of the post.
 */
@property (nonatomic, strong) NSString *title;
/**
 The author of the post.
 */
@property (nonatomic, strong) NSString *author;
/**
 The content of the post.
 */
@property (nonatomic, readonly) NSAttributedString *content;
/**
 The raw html content of the post.
 */
@property (nonatomic, strong) NSString *rawContent;
///!!!: I dont like that property, maybe rename it or put the logic somewhere else ...
/**
 The indention level of the post.
 */
@property (nonatomic, readwrite) NSUInteger postIndention;
/**
 Boolean indicating if the post is from the forum entry author.
 */
@property (nonatomic, readwrite) BOOL isOP;
/**
 Boolean indicating if the post has an attachment.
 */
@property (nonatomic, readwrite) BOOL hasAttachments;
/**
 An array of attachments.
 */
@property (nonatomic, strong) NSArray<MOODLECourseSectionItem *> *attachments;

@end
NS_ASSUME_NONNULL_END

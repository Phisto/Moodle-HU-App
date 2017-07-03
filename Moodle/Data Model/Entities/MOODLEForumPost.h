//
//  MOODLEForumPost.h
//  Moodle
//
//  Created by Simon Gaus on 30.06.17.
//  Copyright © 2017 Simon Gaus. All rights reserved.
//

@import Foundation;

@class MOODLECourseSectionItem;

/**
 
 
 
 
 
 */

NS_ASSUME_NONNULL_BEGIN

@interface MOODLEForumPost : NSObject

/**
 
 */
@property (nonatomic, strong) NSString *title;
/**
 
 */
@property (nonatomic, strong) NSString *author;
/**
 
 */
@property (nonatomic, readonly) NSAttributedString *content;
/**
 
 */
@property (nonatomic, strong) NSString *rawContent;
/**
 
 */
@property (nonatomic, readwrite) BOOL isOP;
/**
 
 */
@property (nonatomic, readwrite) BOOL hasAttachments;
/**
 
 */
@property (nonatomic, strong) NSArray<MOODLECourseSectionItem *> *attachments;

@end
NS_ASSUME_NONNULL_END

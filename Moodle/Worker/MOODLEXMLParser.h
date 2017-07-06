/*
 *
 *  MOODLEXMLParser.h
 *  Moodle
 *
 *  Copyright © 2017 Simon Gaus. All rights reserved.
 *
 */

@import Foundation;

@class MOODLEDataModel, MOODLECourse, MOODLECourseSection, MOODLEForum, MOODLEForumPost;

/**
 
 The MOODLEXMLParser class is used to parse HTML data to create MOODLE Entities. 
 
 ## Discussion
 This class uses the Hpple framework to parse the HTML string.
 
 */

NS_ASSUME_NONNULL_BEGIN

@interface MOODLEXMLParser : NSObject
#pragma mark - Methodes
///----------------------
/// @name Methodes
///----------------------

/**

 Creates a HTML string from data and parses the string searching for the session key.

 @param data The data to parse.

 @return The session key or nil.

*/
- (nullable NSString *)sessionKeyFromData:(NSData *)data;
/**
 
 Creates a HTML string from data and parses the string searching for the HTML representation of MOODLE courses.
 
 @param data The data to parse.
 
 @return An array of course items or an empty array.
 
 */
- (NSArray<MOODLECourse *> *)createCourseItemsFromData:(NSData *)data;
/**
 
 Creates a HTML string from data and parses the string searching for the HTML representation of MOODLE course sections.
 
 @param data The data to parse.
 
 @return An array of course section items or an empty array.
 
 */
- (NSArray<MOODLECourseSection *> *)createCourseSectionsFromData:(NSData *)data;
/**
 
 Creates a HTML string from data and parses the string searching for the HTML representation of the MOODLE course section content. It will then populate the sections properties.
 
 @param data The data to parse.
 
 @param section The section to create the content for.
 
 @return YES if the content was loaded correctly, otherwise NO.
 
 */
- (BOOL)createContentForCourseSections:(MOODLECourseSection *)section fromData:(NSData *)data;
/**
 
 Creates a HTML string from data and parses the string searching for the HTML representation of MOODLE search item.
 
 @param data The data to parse.
 
 @return An array of search items or nil if no item was found.
 
 */
- (nullable NSArray<MOODLECourse *> *)searchResultsFromData:(NSData *)data;
/**
 
 Creates a HTML string from data and parses the string searching for forum.
 
 @param data The data to parse.
 
 @return The forum or nil.
 
 */
- (MOODLEForum *)forumFromData:(NSData *)data;
/**
 
 Creates a HTML string from data and parses the string searching for forum posts.
 
 @param data The data to parse.
 
 @return An array of forum posts or an empty array.
 
 */
- (NSArray<MOODLEForumPost *> *)forumEntryItemsFromData:(NSData *)data;



@end
NS_ASSUME_NONNULL_END

/*
 *  MOODLEXMLParser.h
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

@class MOODLEDataModel, MOODLECourse, MOODLECourseSection, MOODLESearchItem;

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
 
 @return YES if the content was loaded correctly, otherwise NO.
 
 */
- (BOOL)createContentForCourseSections:(MOODLECourseSection *)section fromData:(NSData *)data;
/**
 
 Creates a HTML string from data and parses the string searching for the HTML representation of MOODLE search item.
 
 @param data The data to parse.
 
 @return An array of search items or nil if no item was found.
 
 */
- (nullable NSArray<MOODLESearchItem *> *)searchResultsFromData:(NSData *)data;

@end
NS_ASSUME_NONNULL_END

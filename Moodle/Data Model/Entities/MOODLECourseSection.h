/*
 *  MOODLECourseSection.h
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

@class MOODLECourseSectionItem;

/**
 
 A MOODLECourseSection object represents a MOODLE course section.
 
 */

NS_ASSUME_NONNULL_BEGIN

@interface MOODLECourseSection : NSObject
#pragma mark - Properties
///--------------------
/// @name Properties
///--------------------

/**
 The title of the section.
 */
@property (nonatomic, strong) NSString *sectionTitle;
/**
 The description of the section.
 */
@property (nonatomic, strong) NSString *sectionDescription;
/**
 The attributed description of the section.
 */
@property (nonatomic, readonly) NSMutableAttributedString *attributedSectionDescription;
/**
 The url of the section.
 */
@property (nonatomic, strong) NSURL *sectionURL;
/**
 Boolean indicating if the sections content is loaded.
 
 @warning We need this to load setions that are not fully listend in the overview site
 */
@property (nonatomic, readwrite) BOOL hasContenLoaded;
/**
 Boolean indicating if the sections content is only accessible through a seperate section website.
 
 @warning We need this to load setions that are not fully listend in the overview site
 */
@property (nonatomic, readwrite) BOOL isIndependentSection;
/**
 Boolean indicating if the section has content.
 */
@property (nonatomic, readonly) BOOL hasContent;
/**
 Boolean indicating if the section has a description.
 */
@property (nonatomic, readonly) BOOL hasDescription;
/**
 Boolean indicating if the section has an assignment.
 */
@property (nonatomic, readonly) BOOL hasAssignment;
/**
 Boolean indicating if the section has a wiki.
 */
@property (nonatomic, readonly) BOOL hasWiki;
/**
 Boolean indicating if the section has documents.
 */
@property (nonatomic, readonly) BOOL hasDocuments;
/**
 Boolean indicating if the section has other section items.
 */
@property (nonatomic, readonly) BOOL hasOhterItems;
/**
 An array with resources of the type `MoodleItemTypeDocument`.
 */
@property (nonatomic, strong) NSArray<MOODLECourseSectionItem *> *documentItemArray;
/**
 An array with resources of the type `MoodleItemTypeAssignment`.
 */
@property (nonatomic, strong) NSArray<MOODLECourseSectionItem *> *assignmentsItemArray;
/**
 An array with resources of the type `MoodleItemTypeWiki`.
 */
@property (nonatomic, strong) NSArray<MOODLECourseSectionItem *> *wikisItemArray;
/**
 An array with resources of different types.
 */
@property (nonatomic, strong) NSArray<MOODLECourseSectionItem *> *otherItemArray;

@end
NS_ASSUME_NONNULL_END

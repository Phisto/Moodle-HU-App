/*
 *  MOODLECourseDocumentItem.h
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

NS_ASSUME_NONNULL_BEGIN



///-----------------------
/// @name ENUMERATIONS
///-----------------------



/**

 These constants defines the different types of course section resources.
 
 */
typedef NS_ENUM(NSInteger, MoodleItemType) {
    MoodleItemTypeDocument,
    MoodleItemTypeWiki,
    MoodleItemTypeComment,
    MoodleItemTypeAssignment,
    MoodleItemTypeURL,
    MoodleItemTypeForum,
    MoodleItemTypeGlossary,
    MoodleItemTypeGallery,
    MoodleItemTypeFolder,
    MoodleItemTypeOther
};

/**

 These constants defines the different MoodleItemTypeDocument subytypes.
 
 */
typedef NS_ENUM(NSInteger, MoodleDocumentType) {
    MoodleDocumentTypePDF,
    MoodleDocumentTypePPT,
    MoodleDocumentTypeWordDocument,
    MoodleDocumentTypeAudioFile,
    MoodleDocumentTypeOther
};

/**
 
 A MOODLECourseSectionItem object represents an resource from a MOODLE course section.
 
 */

@interface MOODLECourseSectionItem : NSObject
#pragma mark - Properties
///--------------------
/// @name Properties
///--------------------

/**
 The title of the resource.
 */
@property (nonatomic, strong, nullable) NSString *resourceTitle;
/**
 The url of the resource.
 */
@property (nonatomic, strong, nullable) NSURL *resourceURL;
/**
 The type of the resource.
 */
@property (nonatomic, readwrite) MoodleItemType itemType;
/**
 The type of the document if the resource is a document.
 */
@property (nonatomic, readwrite) MoodleDocumentType documentType;
/**
 The text of the resource. Only applies to `MoodleItemTypeComment`.
 */
@property (nonatomic, strong, nullable) NSString *text;

@end
NS_ASSUME_NONNULL_END

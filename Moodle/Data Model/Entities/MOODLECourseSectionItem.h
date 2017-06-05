/*
 *  MOODLECourseDocumentItem.h
 *  Moodle
 *
 *  Created by Simon Gaus on 03.06.17.
 *  Copyright © 2017 Simon Gaus. All rights reserved.
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

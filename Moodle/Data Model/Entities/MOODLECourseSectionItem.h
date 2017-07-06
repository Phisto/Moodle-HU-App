/*
 *
 *  MOODLECourseDocumentItem.h
 *  Moodle
 *
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
    /// A document item
    MoodleItemTypeDocument,
    /// A wiki item
    MoodleItemTypeWiki,
    /// A comment item
    MoodleItemTypeComment,
    /// An assignment item
    MoodleItemTypeAssignment,
    /// An url item
    MoodleItemTypeURL,
    /// A forum item
    MoodleItemTypeForum,
    /// A glossary item
    MoodleItemTypeGlossary,
    /// A gallery item
    MoodleItemTypeGallery,
    /// A folder item
    MoodleItemTypeFolder,
    /// A unknown item
    MoodleItemTypeOther
};

/**

 These constants defines the different MoodleItemTypeDocument subytypes.
 
 */
typedef NS_ENUM(NSInteger, MoodleDocumentType) {
    /// A PDF document
    MoodleDocumentTypePDF,
    /// A Powerpoint document
    MoodleDocumentTypePPT,
    /// A Word document
    MoodleDocumentTypeWordDocument,
    /// An audio document
    MoodleDocumentTypeAudioFile,
    /// An unknown document
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
@property (nonatomic, strong, nullable) NSString *textRaw;
/**
 The text of the resource. Only applies to `MoodleItemTypeComment`.
 */
@property (nonatomic, readonly, nullable) NSAttributedString *attributedText;

@end
NS_ASSUME_NONNULL_END

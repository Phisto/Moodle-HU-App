/*
 *  MOODLECourseSection.m
 *  Moodle
 *
 *  Created by Simon Gaus on 03.06.17.
 *  Copyright © 2017 Simon Gaus. All rights reserved.
 *
 */

@import UIKit;

#import "MOODLECourseSection.h"

///-----------------------
/// @name CATEGORIES
///-----------------------



@interface MOODLECourseSection (/* Private */)

@property (nonatomic, strong) NSMutableAttributedString *attributedSectionDescription;

@end



///-----------------------
/// @name IMPLEMENTATION
///-----------------------



@implementation MOODLECourseSection
#pragma mark - Getter


- (BOOL)hasContent {
    
    return (self.hasDescription || self.hasDocuments || self.hasAssignment  || self.hasWiki || self.hasOhterItems);
}


- (BOOL)hasDescription {
    
    return (self.sectionDescription != nil);
}


- (BOOL)hasAssignment {
    
    return (self.assignmentsItemArray != nil && self.assignmentsItemArray.count > 0) ? YES : NO;
}


- (BOOL)hasDocuments {
    
    return (self.documentItemArray != nil && self.documentItemArray.count > 0) ? YES : NO;
}


- (BOOL)hasWiki {
    
    return (self.wikisItemArray != nil && self.wikisItemArray.count > 0) ? YES : NO;
}


- (BOOL)hasOhterItems {
    
    return (self.otherItemArray != nil && self.otherItemArray.count > 0) ? YES : NO;
}


- (NSMutableAttributedString *)attributedSectionDescription {
    
    if (!_attributedSectionDescription) {
        
        _attributedSectionDescription = [[NSMutableAttributedString alloc] initWithString:(self.sectionDescription) ? self.sectionDescription : @""
                                                                               attributes:@{
                                                                                            NSDocumentTypeDocumentAttribute:
                                                                                                NSHTMLTextDocumentType
                                                                                            }];
    }
    
    
    return _attributedSectionDescription;
}


#pragma mark -
@end

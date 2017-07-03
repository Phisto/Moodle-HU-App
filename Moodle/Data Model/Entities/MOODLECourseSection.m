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

@property (nonatomic, strong) NSAttributedString *attributedSectionDescription;

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
    
    return (self.sectionDescriptionRaw != nil);
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


- (NSAttributedString *)attributedSectionDescription {
    
    if (!_attributedSectionDescription) {
        
        NSString *raw = (self.sectionDescriptionRaw) ? self.sectionDescriptionRaw : @"";
        NSString *rawHTML = [raw stringByAppendingString:@"<style>body{font-family: '.SFUIText'; font-size:16px;}</style>"];
        NSAttributedString *courseDescription = [[NSAttributedString alloc] initWithData:[rawHTML dataUsingEncoding:NSUnicodeStringEncoding]
                                                                                 options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType,
                                                                                           NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)}
                                                                      documentAttributes:NULL
                                                                                   error:nil];
        
        _attributedSectionDescription = courseDescription;
    }
    
    
    return _attributedSectionDescription;
}


#pragma mark -
@end

/*
 *  MOODLECourseSection.m
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

/* Frameworks */
@import UIKit;

/* Header */
#import "MOODLECourseSection.h"



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
    
    return [[NSMutableAttributedString alloc] initWithData:[self.sectionDescription dataUsingEncoding:NSUnicodeStringEncoding]
                                                   options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
                                        documentAttributes:nil
                                                     error:nil];
}

#pragma mark -
@end

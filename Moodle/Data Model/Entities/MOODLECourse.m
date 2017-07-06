/*
 *
 *  MOODLECourse.m
 *  Moodle
 *
 *  Copyright © 2017 Simon Gaus. All rights reserved.
 *
 */

@import UIKit; // For NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType

#import "MOODLECourse.h"

/* Data Model */
#import "MOODLEDataModel.h"
#import "MOODLEForum.h"

///-----------------------
/// @name CATEGORIES
///-----------------------



@interface MOODLECourse (/* Private */)

@property (nonatomic, strong) NSAttributedString *attributedCourseDescription;

@end



///-----------------------
/// @name IMPLEMENTATION
///-----------------------



@implementation MOODLECourse
#pragma mark - Custom Setter


///!!!: This is somehow ugly, dont use setter for something else
- (void)setIsHidden:(BOOL)isHidden {
    
    if (_isHidden != isHidden) {
        
        [self.dataModel setItem:self isHidden:isHidden];
        
        _isHidden = isHidden;
    }
}


///!!!: This is somehow ugly, dont use setter for something else
- (void)setIsFavourite:(BOOL)isFavourite {
    
    if (_isFavourite != isFavourite) {
        
        [self.dataModel setItem:self isFavorit:isFavourite];
        
        _isFavourite = isFavourite;
    }
}


#pragma mark - Custom Getter


- (BOOL)canSubscribe {
    
    return ((self.guestSubscribe || self.selfSubscribe ) && self.url);
}


- (NSAttributedString *)attributedCourseDescription {
    
    if (!_attributedCourseDescription) {
        
        NSString *raw = (self.courseDescriptionRaw) ? self.courseDescriptionRaw : @"";
        NSString *rawHTML = [raw stringByAppendingString:@"<style>body{font-family: '.SFUIText'; font-size:17px;}</style>"];
        NSAttributedString *courseDescription = [[NSAttributedString alloc] initWithData:[rawHTML dataUsingEncoding:NSUnicodeStringEncoding]
                                                                                 options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType,
                                                                                        NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)}
                                                                      documentAttributes:NULL
                                                                                   error:nil];
        
        _attributedCourseDescription = courseDescription;
    }
    return _attributedCourseDescription;
}


#pragma mark -
@end

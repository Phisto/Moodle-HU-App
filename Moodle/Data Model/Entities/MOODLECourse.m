/*
 *  MOODLECourse.m
 *  Moodle
 *
 *  Created by Simon Gaus on 03.06.17.
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

@property (nonatomic, strong) NSMutableAttributedString *attributedCourseDescription;

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


- (NSMutableAttributedString *)attributedCourseDescription {
    
    if (!_attributedCourseDescription) {
        
        _attributedCourseDescription = [[NSMutableAttributedString alloc] initWithString:(self.courseDescription) ? self.courseDescription : @""
                                                                              attributes:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }];
    }
    return _attributedCourseDescription;
}


#pragma mark -
@end

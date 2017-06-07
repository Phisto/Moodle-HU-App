/*
 *  MOODLESearchItem.m
 *  Moodle
 *
 *  Created by Simon Gaus on 03.06.17.
 *  Copyright © 2017 Simon Gaus. All rights reserved.
 *
 */

@import UIKit;

#import "MOODLESearchItem.h"

///-----------------------
/// @name CATEGORIES
///-----------------------



@interface MOODLESearchItem (/* Private */)

@property (nonatomic, strong) NSMutableAttributedString *attributedCourseDescription;

@end



///-----------------------
/// @name IMPLEMENTATION
///-----------------------



@implementation MOODLESearchItem
#pragma mark - Getter


- (BOOL)canSubscribe {
    
    return ((self.guestSubscribe || self.selfSubscribe ) && self.courseURL);
}


- (NSMutableAttributedString *)attributedCourseDescription {
    
    if (!_attributedCourseDescription) {
        
        _attributedCourseDescription = [[NSMutableAttributedString alloc] initWithString:(self.courseDescription) ? self.courseDescription : @""
                                                                               attributes:@{
                                                                                            NSDocumentTypeDocumentAttribute:
                                                                                                NSHTMLTextDocumentType
                                                                                            }];
    }
    return _attributedCourseDescription;
}


#pragma mark -
@end

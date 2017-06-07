/*
 *  MOODLECourse.m
 *  Moodle
 *
 *  Created by Simon Gaus on 03.06.17.
 *  Copyright © 2017 Simon Gaus. All rights reserved.
 *
 */

#import "MOODLECourse.h"

/* Data Model */
#import "MOODLEDataModel.h"

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


#pragma mark -
@end

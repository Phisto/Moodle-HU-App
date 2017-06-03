/*
 *  MOODLESearchItem.m
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

@import UIKit;

/* Header */
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

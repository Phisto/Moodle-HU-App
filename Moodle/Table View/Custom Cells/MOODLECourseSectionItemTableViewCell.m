/*
 *  MOODLECourseSectionItemTableViewCell.m
 *  Moodle
 *
 *  Created by Simon Gaus on 03.06.17.
 *  Copyright © 2017 Simon Gaus. All rights reserved.
 *
 */

#import "MOODLECourseSectionItemTableViewCell.h"

@implementation MOODLECourseSectionItemTableViewCell
@end



#pragma mark - ACCESSIBILITY
///-----------------------
/// @name ACCESSIBILITY
///-----------------------



@implementation MOODLECourseSectionItemTableViewCell (Accessibility)


- (NSString *)accessibilityHint {
    
    return NSLocalizedString(@"Zum aktivieren doppel tippen", @"table view cell selection hint");
}


@end

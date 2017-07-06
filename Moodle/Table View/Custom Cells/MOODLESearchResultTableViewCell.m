/*
 *
 *  MOODLESearchResultTableViewCell.m
 *  Moodle
 *
 *  Copyright © 2017 Simon Gaus. All rights reserved.
 *
 */

#import "MOODLESearchResultTableViewCell.h"

@implementation MOODLESearchResultTableViewCell
@end



#pragma mark - ACCESSIBILITY
///-----------------------
/// @name ACCESSIBILITY
///-----------------------



@implementation MOODLESearchResultTableViewCell (Accessibility)


- (NSString *)accessibilityHint {
    
    return NSLocalizedString(@"Zum aktivieren doppel tippen", @"table view cell selection hint");
}


@end

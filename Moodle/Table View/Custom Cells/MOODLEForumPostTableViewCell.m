/*
 *
 *  MOODLEForumPostTableViewCell.m
 *  Moodle
 *
 *  Copyright © 2017 Simon Gaus. All rights reserved.
 *
 */

#import "MOODLEForumPostTableViewCell.h"

@implementation MOODLEForumPostTableViewCell
#pragma mark - View Methodes


/**
 This is needed to enable the indentationLevel and indentationWidth for custom table view cells.
 */
- (void)layoutSubviews {
    // call super
    [super layoutSubviews];
    
    float indentPoints = self.indentationLevel * self.indentationWidth;
    
    self.contentView.frame = CGRectMake(indentPoints,
                                        self.contentView.frame.origin.y,
                                        self.contentView.frame.size.width - indentPoints,
                                        self.contentView.frame.size.height);
}


#pragma mark -
@end

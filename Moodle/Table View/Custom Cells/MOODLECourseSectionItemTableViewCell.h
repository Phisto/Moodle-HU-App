/*
 *  MOODLECourseSectionItemTableViewCell.h
 *  Moodle
 *
 *  Created by Simon Gaus on 03.06.17.
 *  Copyright © 2017 Simon Gaus. All rights reserved.
 *
 */

@import UIKit;

NS_ASSUME_NONNULL_BEGIN



///-----------------------
/// @name CONSTANTS
///-----------------------



/**
 The cell identifier for this table view cell.
 */
static NSString *MOODLECourseSectionItemTableViewCellIdentifier = @"MOODLECourseSectionItemTableViewCellIdentifier";



/**
 
 This class is a custom `UITableViewCell` subclass, which is designed to show all relevant information about a MOODLE course section item.
 
 */

@interface MOODLECourseSectionItemTableViewCell : UITableViewCell
#pragma mark - IBOutlets
///-----------------
/// @name IBOutlets
///-----------------

/**
 The image view to indicate the file type of the item.
 */
@property (nonatomic, strong) IBOutlet UIImageView *fileIconImageView;
/**
 The label to display the item title.
 */
@property (nonatomic, strong) IBOutlet UILabel *itemLabel;

@end
NS_ASSUME_NONNULL_END

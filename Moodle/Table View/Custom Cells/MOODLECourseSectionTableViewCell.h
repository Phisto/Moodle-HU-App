/*
 *  MOODLECourseSectionTableViewCell.h
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
static NSString *MOODLECourseSectionTableViewCellIdentifier = @"MOODLECourseSectionTableViewCellIdentifier";



/**
 
 This class is a custom `UITableViewCell` subclass, which is designed to show all relevant information about a MOODLE course section item.
 
 */

@interface MOODLECourseSectionTableViewCell : UITableViewCell
#pragma mark - IBOutlets
///-----------------
/// @name IBOutlets
///-----------------

/**
 The label to display the section title.
 */
@property (nonatomic, strong) IBOutlet UILabel *sectionTitleLabel;
/**
 The label to indicate to the user that the section has no content.
 */
@property (nonatomic, strong) IBOutlet UILabel *noContentLabel;
/**
 The image view to indicate to the user if there is a assignment for this section.
 */
@property (nonatomic, strong) IBOutlet UIImageView *assignmentImageView;
/**
 The image view to indicate to the user if there is a description for this section.
 */
@property (nonatomic, strong) IBOutlet UIImageView *descriptionImageView;
/**
 The image view to indicate to the user if there are documents for this section.
 */
@property (nonatomic, strong) IBOutlet UIImageView *dokumentImageView;

@end
NS_ASSUME_NONNULL_END

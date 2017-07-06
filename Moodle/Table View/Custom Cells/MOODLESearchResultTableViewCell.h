/*
 *
 *  MOODLESearchResultTableViewCell.h
 *  Moodle
 *
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
static NSString *MOODLESearchResultTableViewCellIdentifier = @"MOODLESearchResultTableViewCellIdentifier";



/**
 
 This class is a custom `UITableViewCell` subclass, which is designed to show all relevant information about a MOODLE search result.
 
 */

@interface MOODLESearchResultTableViewCell : UITableViewCell
#pragma mark - IBOutlets
///-----------------
/// @name IBOutlets
///-----------------

/**
 The label to display the search result title.
 */
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
/**
 The image view to indicate if the user can subsribe to the course.
 */
@property (nonatomic, strong) IBOutlet UIImageView *subscribeImageIcon;

@end
NS_ASSUME_NONNULL_END

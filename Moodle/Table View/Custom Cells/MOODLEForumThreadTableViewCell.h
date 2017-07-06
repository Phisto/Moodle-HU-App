/*
 *
 *  MOODLEForumThreadTableViewCell.h
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
static NSString *MOODLEForumThreadTableViewCellIdentifier = @"MOODLEForumThreadTableViewCellIdentifier";



/**
 
 
 This class is a custom `UITableViewCell` subclass, which is designed to show all relevant information about a forum thread.
 
 
 */

@interface MOODLEForumThreadTableViewCell : UITableViewCell
#pragma mark - IBOutlets
///-----------------
/// @name IBOutlets
///-----------------

/**
 The label to display the threads title.
 */
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
/**
 The label to display the name of the author.
 */
@property (nonatomic, strong) IBOutlet UILabel *authorLabel;
/**
 The label to display the number of unread/read replies in the thread.
 */
@property (nonatomic, strong) IBOutlet UILabel *repliesLabel;
/**
 The image view to display the authors profile picture.
 */
@property (nonatomic, strong) IBOutlet UIImageView *profileImageView;

@end
NS_ASSUME_NONNULL_END

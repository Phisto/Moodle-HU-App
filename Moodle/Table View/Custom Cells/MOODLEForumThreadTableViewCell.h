//
//  MOODLEForumThreadTableViewCell.h
//  Moodle
//
//  Created by Simon Gaus on 03.07.17.
//  Copyright © 2017 Simon Gaus. All rights reserved.
//

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
 
 
 
 
 
 */

@interface MOODLEForumThreadTableViewCell : UITableViewCell

/**
 
 */
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
/**
 
 */
@property (nonatomic, strong) IBOutlet UILabel *authorLabel;
/**
 
 */
@property (nonatomic, strong) IBOutlet UILabel *repliesLabel;
/**
 
 */
@property (nonatomic, strong) IBOutlet UIImageView *profileImageView;

@end
NS_ASSUME_NONNULL_END

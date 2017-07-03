//
//  MOODLEForumPostTableViewCell.h
//  Moodle
//
//  Created by Simon Gaus on 01.07.17.
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
static NSString *MOODLEForumPostTableViewCellIdentifier = @"MOODLEForumPostTableViewCellIdentifier";



/**
 
 
 
 
 */

@interface MOODLEForumPostTableViewCell : UITableViewCell
/**
 
 */
@property (nonatomic, strong) IBOutlet UIImageView *profileImageView;
/**
 
 */
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
/**
 
 */
@property (nonatomic, strong) IBOutlet UILabel *opLabel;
/**
 
 */
@property (nonatomic, strong) IBOutlet UILabel *authorLabel;
/**
 
 */
@property (nonatomic, strong) IBOutlet UITextView *textView;
/**
 
 */
@property (nonatomic, strong) IBOutlet UILabel *postRankLabel;








/**
 
 */
@property (nonatomic, strong) IBOutlet UIView *ressourceContainerView;
/**
 
 */
@property (nonatomic, strong) IBOutlet UILabel *ressourceTitleLabel;
/**
 
 */
@property (nonatomic, strong) IBOutlet UIImageView *ressourceIconImageView;
/**
 
 */
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *ressourceContainerHeightConstraint;

@end
NS_ASSUME_NONNULL_END

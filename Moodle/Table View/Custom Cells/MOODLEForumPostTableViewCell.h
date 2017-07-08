/*
 *
 *  MOODLEForumPostTableViewCell.h
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
static NSString * const MOODLEForumPostTableViewCellIdentifier = @"MOODLEForumPostTableViewCellIdentifier";



/**
 
 This class is a custom `UITableViewCell` subclass, which is designed to show all relevant information about a forum post.
 
 
 */

@interface MOODLEForumPostTableViewCell : UITableViewCell
#pragma mark - IBOutlets
///-----------------
/// @name IBOutlets
///-----------------

/**
 The image view to display the authors profile picture.
 */
@property (nonatomic, strong) IBOutlet UIImageView *profileImageView;
/**
 The label to display the posts title.
 */
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
/**
 The label to indicate if the post is from the thread starter.
 */
@property (nonatomic, strong) IBOutlet UILabel *opLabel;
/**
 The label to display the authors name.
 */
@property (nonatomic, strong) IBOutlet UILabel *authorLabel;
/**
 The label to display the time the post was registered.
 */
@property (nonatomic, strong) IBOutlet UILabel *timeLabel;
/**
 The teyt view to display the posts content.
 */
@property (nonatomic, strong) IBOutlet UITextView *textView;
/**
 The label to display the posts rank in the thread.
 */
@property (nonatomic, strong) IBOutlet UILabel *postRankLabel;



#pragma mark - Post Ressource Related IBOutlets
///---------------------------------------
/// @name Post Ressource Related IBOutlets
///---------------------------------------

/**
 The ressource container view.
 */
@property (nonatomic, strong) IBOutlet UIView *ressourceContainerView;
/**
 The label to display the ressource title.
 */
@property (nonatomic, strong) IBOutlet UILabel *ressourceTitleLabel;
/**
 The image view to display the ressource type icon.
 */
@property (nonatomic, strong) IBOutlet UIImageView *ressourceIconImageView;
/**
 The NSLayoutConstraint for the height of the ressourceContainerView.
 */
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *ressourceContainerHeightConstraint;

@end
NS_ASSUME_NONNULL_END

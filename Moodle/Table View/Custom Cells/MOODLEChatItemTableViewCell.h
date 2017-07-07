/*
 *
 *  MOODLEChatItemTableViewCell.h
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
static NSString *MOODLEChatItemTableViewCellIdentifier = @"MOODLEChatItemTableViewCellIdentifier";



/**
 
 
 This class is a custom `UITableViewCell` subclass, which is designed to show all relevant information about a forum thread.
 
 
 */
@interface MOODLEChatItemTableViewCell : UITableViewCell
#pragma mark - IBOutlets
///-----------------
/// @name IBOutlets
///-----------------

/**
 The label to display the chat partners name.
 */
@property (nonatomic, strong) IBOutlet UILabel *chatPartnerLabel;
/**
 The lable to diplay the time of the last message.
 */
@property (nonatomic, strong) IBOutlet UILabel *timeLabel;
/**
 The text view to display the preview text.
 */
@property (nonatomic, strong) IBOutlet UITextView *previewMessageView;
/**
 The profile image view.
 */
@property (nonatomic, strong) IBOutlet UIImageView *profileImagView;

@end
NS_ASSUME_NONNULL_END

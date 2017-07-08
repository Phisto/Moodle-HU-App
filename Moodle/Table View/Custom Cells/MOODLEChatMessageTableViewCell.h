/*
 *
 *  MOODLEChatMessageTableViewCell.h
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
static NSString * const MOODLEChatMessageTableViewCellIdentifierLEFT = @"MOODLEChatMessageTableViewCellIdentifierLEFT";
static NSString * const MOODLEChatMessageTableViewCellIdentifierRIGHT = @"MOODLEChatMessageTableViewCellIdentifierRIGHT";



/**
 
 
 This class is a custom `UITableViewCell` subclass, which is designed to show all relevant information about a chat message.
 
 
 */
@interface MOODLEChatMessageTableViewCell : UITableViewCell
#pragma mark - IBOutlets
///-----------------
/// @name IBOutlets
///-----------------

/**
 The label to display the time the message was registered.
 */
@property (nonatomic, strong) IBOutlet UILabel *timeLabel;
/**
 The text viw to display the message.
 */
@property (nonatomic, strong) IBOutlet UITextView *textView;

@end
NS_ASSUME_NONNULL_END

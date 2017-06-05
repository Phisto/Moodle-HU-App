/*
 *  MOODLECommentTableViewCell.h
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
static NSString *MOODLECommentTableViewCellIdentifier = @"MOODLECommentTableViewCellIdentifier";



/**
 
 This class is a custom `UITableViewCell` subclass, which is designed to show a comment inside a text view.
 
 */

@interface MOODLECommentTableViewCell : UITableViewCell
#pragma mark - IBOutlets
///-----------------
/// @name IBOutlets
///-----------------

/**
 The text view to display the comment.
 */
@property (nonatomic, strong) IBOutlet UITextView *textView;

@end
NS_ASSUME_NONNULL_END

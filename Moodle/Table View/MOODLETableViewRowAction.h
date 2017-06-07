/*
 *  MOODLETableViewRowAction.h
 *  Moodle
 *
 *  Created by Simon Gaus on 03.06.17.
 *  Copyright © 2017 Simon Gaus. All rights reserved.
 *
 */

@import UIKit;

/**
 
 A MOODLETableViewRowAction object defines a single action to present when the user swipes horizontally in a table row.
 
 ## Notes
 This solution was taken from stackoverflow thread: https://stackoverflow.com/questions/27740884/uitableviewrowaction-title-as-image-icon-instead-of-text
 
 ## Important
 This class uses '_setButton', which is private API.
 
 */

NS_ASSUME_NONNULL_BEGIN

@interface MOODLETableViewRowAction : UITableViewRowAction
#pragma mark - Properties
///-----------------
/// @name Properties
///-----------------

/**
 The font of the button label.
 */
@property (nonatomic, strong) UIFont *font;
/**
 The color of the button label and icon.
 */
@property (nonatomic, strong) UIColor *iconAndLabelColor;



#pragma mark - Object Life Cycle
///----------------------
/// @name Inititalization
///----------------------

/**
 
 Creates and returns a new table view row action object.
 The style and handler block you specify cannot be changed later.
 
 @param style The style characteristics to apply to the button. You use this value to apply default appearance characteristics to the button. For a list of possible style values, see `UITableViewRowActionStyle`.
 
 @param title The string to display in the button.
 
 @param icon The image to display in the button.
 
 @param handler The block to execute when the user taps the button associated with this action.
 
 @return A new table row action object that you can return from your table view’s delegate method.
 
 */
+ (instancetype)rowActionWithStyle:(UITableViewRowActionStyle)style title:(nullable NSString *)title icon:(nullable UIImage*)icon handler:(void (^)(UITableViewRowAction *action, NSIndexPath *indexPath))handler;

@end
NS_ASSUME_NONNULL_END

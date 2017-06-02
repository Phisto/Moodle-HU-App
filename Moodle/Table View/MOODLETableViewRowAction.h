/*
 *  MOODLETableViewRowAction.h
 *  MOODLE
 *
 *  Copyright © 2017 Simon Gaus <simon.cay.gaus@gmail.com>
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU Lesser General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU Lesser General Public License for more details.
 *
 *  You should have received a copy of the GNU Lesser General Public License
 *  along with this programm.  If not, see <http://www.gnu.org/licenses/>.
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

#pragma mark - Methodes
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

/*
 *  MOODLETableViewRowAction.m
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

#import "MOODLETableViewRowAction.h"

@interface MOODLETableViewRowAction (/* Private */)

@property (nonatomic, strong) UIImage *actionIcon;

@end



///-----------------------
/// @name IMPLEMENTATION
///-----------------------



@implementation MOODLETableViewRowAction

+ (instancetype)rowActionWithStyle:(UITableViewRowActionStyle)style title:(nullable NSString *)title icon:(nullable UIImage*)icon handler:(void (^)(UITableViewRowAction *action, NSIndexPath *indexPath))handler {
    
    if (title.length) title = [@"\n\n" stringByAppendingString:title]; // move title under centerline; icon will go above
    MOODLETableViewRowAction *action = (MOODLETableViewRowAction *)[super rowActionWithStyle:style
                                                                                       title:title
                                                                                     handler:handler];
    action.actionIcon = icon;
    return action;
}

//!!!: Private API Use - Not allowed in Apple Store.
- (void)_setButton:(UIButton*)button {
    
    if (self.font) button.titleLabel.font = self.font;
    if (self.iconAndLabelColor) button.titleLabel.textColor = self.iconAndLabelColor;
    if (self.actionIcon) {
        
        // render icon as template
        [button setImage:[self.actionIcon imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        button.tintColor = button.titleLabel.textColor;
        CGSize titleSize = [button.titleLabel.text sizeWithAttributes:@{NSFontAttributeName: button.titleLabel.font}];
        
        button.imageEdgeInsets = UIEdgeInsetsMake(-(titleSize.height/2.0f), 0.0f, 0.0f, -titleSize.width);
    }
}

@end

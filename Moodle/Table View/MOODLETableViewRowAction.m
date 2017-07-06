/*
 *
 *  MOODLETableViewRowAction.m
 *  Moodle
 *
 *  Copyright © 2017 Simon Gaus. All rights reserved.
 *
 */

#import "MOODLETableViewRowAction.h"

///-----------------------
/// @name CATEGORIES
///-----------------------



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


///!!!: Private API Use - Possibly not allowed in Apple Store.
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

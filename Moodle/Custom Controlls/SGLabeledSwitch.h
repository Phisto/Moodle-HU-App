/*
 *  SGLabeledSwitch.h
 *  LabeledSwitch-ObjC
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
 *  You should have received a copy of the GNU General Public License
 *  along with this programm.  If not, see <http://www.gnu.org/licenses/>.
 *
 */

@import UIKit;

NS_ASSUME_NONNULL_BEGIN

/**
 
 ## Overview
 
 You can use the SGLabeledSwitch class to create and manage the On/Off buttons used, for example,
 in the Settings app for options such as Airplane Mode and Bluetooth. 
 Compared to the regular UISwitch, it displays a label for a decription text.
 
 ## Features
 
 - Most settings are inspectable and designable in the Interface Builder
 
 - Easy accessibility support
 
 ## Discussion
 
 The main advantage of the SGLabeledSwitch is its accessibility behavior.
 With VoiceOver enabled the whole control (switch and label) will funktion as a switch.
 No need to configure accessibility label, traits or hint.
 
 */

IB_DESIGNABLE

@interface SGLabeledSwitch : UIControl
#pragma mark - Switch Properties
///------------------------
/// @name Switch Properties
///------------------------

/**
 A Boolean value that determines the off/on state of the switch.
 */
@property (nonatomic, readwrite) IBInspectable BOOL value;
/**
 The color used to tint the appearance of the switch when it is turned on.
 */
@property (nonatomic, strong) IBInspectable UIColor *onTint;
/**
 The color used to tint the appearance of the thumb.
 */
@property (nonatomic, strong) IBInspectable UIColor *thumbTint;
/**
 Boolean indication if the switch should be on the right side.
 */
@property (nonatomic, readwrite) IBInspectable BOOL rightSwitch;

#pragma mark - Label Properties
///------------------------
/// @name Label Properties
///------------------------

/**
 The current text that is displayed by the label.
 This property is 'Label' by default.
 */
@property (nonatomic, strong) IBInspectable NSString *text;
/**
 The color of the text.
 */
@property (nonatomic, strong) IBInspectable UIColor *textColor;
/**
 The maximum number of lines to use for rendering text. Default is 1.
 */
@property (nonatomic, readwrite) IBInspectable NSInteger lines;
/**
 The space between switch and label in points.
 */
@property (nonatomic, readwrite) IBInspectable CGFloat textPadding;
/**
 The font size to use for the label.
 */
@property (nonatomic, readwrite) IBInspectable CGFloat fontSize;
#pragma mark - Not inspectable
/**
 The technique to use for aligning the text.
 */
@property (nonatomic, readwrite) IBInspectable NSTextAlignment textAlignment;
/**
 The font of the text.
 */
@property (nonatomic, strong) IBInspectable UIFont *font;


#pragma mark -
@end
NS_ASSUME_NONNULL_END

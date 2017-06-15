/*
 *  SGAccessibleSlider.h
 *  AccessibleSlider-ObjC
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
 
 A visual control used to select a single value from a continuous range of values.
 As you move the thumb of a slider, it passes its updated value to any actions attached to it.
 
 ## Features
 
 - All settings are inspectable in the Interface Builder
 
 - Easy accessibility support
 
 ## Discussion
 
 The main advantage of the SGAccessibleSlider is its accessibility behavior.
 Instead of the default percentage value it will return the actual value that is currently set suffixed with the specified unit.
 
 All other behaviour is inherited from the UISlider class.
 
 */

IB_DESIGNABLE

@interface SGAccessibleSlider : UISlider
#pragma mark - Switch Properties
///-------------------------------
/// @name Accessibility Properties
///-------------------------------

/**
 The name of the unit to measure with the slider. (e.g. "Megabyte", "Litre", "Search results")
 */
@property (nullable, nonatomic, strong) IBInspectable NSString *unit;
/**
 Boolean value indicating if the range of the slider is a integer (1-10) or float (0.0-1.0) range.
 */
@property (nonatomic, readwrite, getter=usesIntegerRange) IBInspectable BOOL integerRange;
/**
 The amount to increment or decrement the value.
 */
@property (nonatomic, readwrite) IBInspectable NSUInteger amount;

@end
NS_ASSUME_NONNULL_END

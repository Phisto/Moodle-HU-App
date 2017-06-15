/*
 *  SGAccessibleSlider.m
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

#import "SGAccessibleSlider.h"

///------------------------
/// @name IMPLEMENTATION
///------------------------



@implementation SGAccessibleSlider
#pragma mark - Object Life Cycle


- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        // set defaults
        _amount = 5;
        _integerRange = YES;
        _unit = @"Unit unknown";
    }
    return self;
}


- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        // set defaults
        _amount = 5;
        _integerRange = YES;
        _unit = @"Unit unknown";
    }
    return self;
}


#pragma mark - Accessibility Methodes


- (NSString *)accessibilityLabel {
    
    return [super accessibilityLabel];
}


- (void)accessibilityIncrement {
    
    self.value = self.value + 5;
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}


- (void)accessibilityDecrement {
    
    self.value = self.value - 5;
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}


- (NSString *)accessibilityValue {
    
    NSString *number = [NSNumberFormatter localizedStringFromNumber:@(self.value) numberStyle:(self.usesIntegerRange) ? NSNumberFormatterNoStyle : NSNumberFormatterDecimalStyle];
    return [NSString stringWithFormat:@"%@ %@, %@", number, self.unit, [super accessibilityValue]];
}


#pragma mark -
@end

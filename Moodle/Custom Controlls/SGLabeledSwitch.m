/*
 *  SGLabeledSwitch.m
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

#import "SGLabeledSwitch.h"


///------------------------
/// @name CUSTOM CLASSES
///------------------------

/**
 
 A little UISwitch subclass to extend the frame on which VoiceOver will set focus to the switch.
 
 */
@interface SGSwitch : UISwitch
@end
@implementation SGSwitch
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    // if the switch is already in focus or VoiceOver isn't running we want the default implementation.
    if (self.accessibilityElementIsFocused || !UIAccessibilityIsVoiceOverRunning()) { return [super pointInside:point withEvent:event]; }
    // else we use the accessibility frame (wich we can greatly change without changing the looks) to calculate the result.
    else { return CGRectContainsPoint(self.accessibilityFrame, [self convertPoint:point toView:nil]); }
}
@end



///------------------------
/// @name CATEGORIES
///------------------------



@interface SGLabeledSwitch (/* Private */)

@property (nonatomic, strong) SGSwitch *switchControl;
@property (nonatomic, strong) UILabel *switchLabel;

@end



@interface SGLabeledSwitch (Accessibility)

- (void)accessibility_setSwitchesAccessibility;

@end



///------------------------
/// @name IMPLEMENTATION
///------------------------



@implementation SGLabeledSwitch
#pragma mark - Synthesize

@synthesize selected = _selected;

#pragma mark - Object Life Cycle


- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
    
        [self setDefaults];
        
        // create subviews
        // switch
        SGSwitch *aSwitch = [[SGSwitch alloc] initWithFrame:CGRectZero];
        [aSwitch addTarget:self action:@selector(switchValueChanged) forControlEvents:UIControlEventValueChanged];
        [self addSubview:aSwitch];
        self.switchControl = aSwitch;
        // label
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        [self addSubview:label];
        self.switchLabel = label;
        
        [self setSubviewProperties];
    }
    return self;
}


- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        [self setDefaults];
        
        // create subviews
        // switch
        SGSwitch *aSwitch = [[SGSwitch alloc] initWithFrame:CGRectZero];
        [aSwitch addTarget:self action:@selector(switchValueChanged) forControlEvents:UIControlEventValueChanged];
        [self addSubview:aSwitch];
        self.switchControl = aSwitch;
        // label
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        [self addSubview:label];
        self.switchLabel = label;
        
        
        [self setSubviewProperties];
    }
    return self;
}


#pragma mark - Switch Methodes


- (void)switchValueChanged {
    
    // we dont use the setter, because the setter will set the switchControl state to the new value
    // which will confuse the voiceover system.
    _value = self.switchControl.on;
    
    // forward the UIControlEventValueChanged event to all registered tagets (IB or programmatically)
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}


#pragma mark - Helper Methodes


- (void)setDefaults {
    
    _value = NO;
    _onTint = nil;
    _thumbTint = nil;
    
    _text = @"Label";
    _lines = 1;
    _textPadding = 20;
    _textAlignment = NSTextAlignmentLeft;
    _fontSize = [UIFont systemFontSize];
    _font = [UIFont systemFontOfSize:_fontSize];
}


- (void)setSubviewProperties {
    
    // set inspectable properties
    // switch
    self.switchControl.on = self.value;
    if (self.onTint) self.switchControl.onTintColor = self.onTint;
    if (self.thumbTint) self.switchControl.thumbTintColor = self.thumbTint;
    
    
    // label
    self.switchLabel.text = self.text;
    if (self.textColor) self.switchLabel.textColor = self.textColor;
    self.switchLabel.numberOfLines = self.lines;
    self.switchLabel.textAlignment = self.textAlignment;
    self.switchLabel.isAccessibilityElement = NO;
    self.switchLabel.font = self.font;
}


#pragma mark - Layout Methodes


- (void)layoutSubviews {
    
    CGFloat selfHeigh = self.frame.size.height;
    CGFloat selfWidth = self.frame.size.width;
    
    
    // switch
    CGFloat heigthSwitch = self.switchControl.frame.size.height;
    CGFloat widthSwitch = self.switchControl.frame.size.width;
    CGFloat x_ax_switch = 0;
    CGFloat y_ax_switch = (selfHeigh-heigthSwitch)/2;
    
    if (self.rightSwitch) {
        x_ax_switch = selfWidth-widthSwitch;
    }
    
    // set frame
    self.switchControl.frame = CGRectMake(x_ax_switch, y_ax_switch, widthSwitch, heigthSwitch);
    
    // label
    CGFloat heigthLabel = selfHeigh;
    CGFloat widthLabel = selfWidth-widthSwitch;
    CGFloat x_ax_label = widthSwitch+self.textPadding;
    CGFloat y_ax_label = 0;
    
    // switch is on the right side
    if (self.rightSwitch) {
        x_ax_label = 0;
        widthLabel = selfWidth-widthSwitch-self.textPadding;
    }
    
    // set frame
    self.switchLabel.frame = CGRectMake(x_ax_label, y_ax_label, widthLabel, heigthLabel);
    
    // accessibility
    [self accessibility_setSwitchesAccessibility];
}


- (CGSize)intrinsicContentSize {
    
    // 31 is the height of the UISwitch so dont make it smaller
    return CGSizeMake(100, 31);
}


- (void)prepareForInterfaceBuilder {
    
    CGFloat selfHeigh = self.frame.size.height;
    CGFloat selfWidth = self.frame.size.width;
    
    
    // switch
    CGFloat heigthSwitch = self.switchControl.frame.size.height;
    CGFloat widthSwitch = self.switchControl.frame.size.width;
    CGFloat x_ax_switch = 0;
    CGFloat y_ax_switch = (selfHeigh-heigthSwitch)/2;
    
    if (self.rightSwitch) {
        x_ax_switch = selfWidth-widthSwitch;
    }
    
    // set frame
    self.switchControl.frame = CGRectMake(x_ax_switch, y_ax_switch, widthSwitch, heigthSwitch);
    
    
    // label
    CGFloat heigthLabel = selfHeigh;
    CGFloat widthLabel = selfWidth-widthSwitch;
    CGFloat x_ax_label = widthSwitch+self.textPadding;
    CGFloat y_ax_label = 0;
    
    // switch is on the right side
    if (self.rightSwitch) {
        x_ax_label = 0;
        widthLabel = selfWidth-widthSwitch-self.textPadding;
    }
    
    // set frame
    self.switchLabel.frame = CGRectMake(x_ax_label, y_ax_label, widthLabel, heigthLabel);
    
    [self setSubviewProperties];
}


#pragma mark - Setter (Switch Properties)
/*
BOOL value;
UIColor *onTint;
UIColor *thumbTint;
BOOL rightSwitch;
*/


- (void)setValue:(BOOL)value {
    
    if (_value != value) {
        
        _value = value;
        self.switchControl.on = value;
    }
}


- (void)setOnTint:(UIColor *)onTint {
    
    if (_onTint != onTint) {
        
        _onTint = onTint;
        self.switchControl.onTintColor = onTint;
    }
}


- (void)setThumbTint:(UIColor *)thumbTint {
    
    if (_thumbTint != thumbTint) {
        
        _thumbTint = thumbTint;
        self.switchControl.thumbTintColor = thumbTint;
    }
}


- (void)setRightSwitch:(BOOL)rightSwitch {
    
    if (_rightSwitch != rightSwitch) {
        
        _rightSwitch = rightSwitch;
        [self layoutSubviews];
    }
}


#pragma mark - Setter (Label Properties)
/*
 NSString *text;
 UIColor *textColor;
 NSInteger lines;
 CGFloat textPadding;
 NSTextAlignment textAlignment;
 CGFloat fontSize;
 UIFont *font;
*/

- (void)setText:(NSString *)text {
    
    _text = text;
    self.switchLabel.text = text;
    
    // accessibility
    self.switchControl.accessibilityLabel = self.text;
}


- (void)setTextColor:(UIColor *)textColor {
    
    if (_textColor != textColor) {
        
        _textColor = textColor;
        self.switchLabel.textColor = textColor;
    }
}


- (void)setLines:(NSInteger)lines {
    
    if (_lines != lines) {
        
        _lines = lines;
        self.switchLabel.numberOfLines = lines;
    }
}


- (void)setTextPadding:(CGFloat)textPadding {
    
    if (_textPadding != textPadding) {
        
        _textPadding = textPadding;
        [self layoutSubviews];
    }
}


- (void)setTextAlignment:(NSTextAlignment)textAlignment {
    
    if (_textAlignment != textAlignment) {
        
        _textAlignment = textAlignment;
        self.switchLabel.textAlignment = textAlignment;
    }
}


- (void)setFontSize:(CGFloat)fontSize {
    
    if (_fontSize != fontSize) {
        
        _fontSize = fontSize;
        self.font = [self.font fontWithSize:fontSize];;
    }
}


- (void)setFont:(UIFont *)font {
    
    if (_font != font) {
        
        _font = font;
        self.switchLabel.font = font;
        _fontSize = font.pointSize;
    }
}


#pragma mark -
@end



///------------------------
/// @name ACCESSIBILITY
///------------------------



@implementation SGLabeledSwitch (UIAccessibility)
#pragma mark - Accessibility Methodes


- (BOOL)isAccessibilityElement {
    
    return NO;
}


- (void)accessibility_setSwitchesAccessibility {
    
    // voice over selection won't work if the accessibilityFrame is higher than 33.0f points. (hight of uiswitch)
    // so we check for the hight and center the accessibilityFrame vertically in the 'real' frame
    CGFloat y_axis = self.frame.origin.y;
    if (self.frame.size.height > 33) {
     
        CGFloat offset = (self.frame.size.height-33.0f)/2.0f;
        y_axis = y_axis+offset;
    }
    
    CGRect rect = CGRectMake(self.frame.origin.x, y_axis, self.frame.size.width, 33.0f);
    self.switchControl.accessibilityFrame = UIAccessibilityConvertFrameToScreenCoordinates(rect, self.superview);
}


#pragma mark -
@end

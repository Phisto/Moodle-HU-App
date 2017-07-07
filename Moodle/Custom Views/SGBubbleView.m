//
//  SGBubbleView.m
//  Moodle
//
//  Created by Simon Gaus on 07.07.17.
//  Copyright © 2017 Simon Gaus. All rights reserved.
//

#import "SGBubbleView.h"

@implementation SGBubbleView
#pragma mark - View Methodes


- (void)drawRect:(CGRect)rect {
    // Drawing code
    //// Rectangle Drawing
    UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRoundedRect:rect
                                                             cornerRadius:9];
    [self.bubbleColor setFill];
    [rectanglePath fill];
}


#pragma mark - IBDesignable Methodes


- (void)prepareForInterfaceBuilder {
    
    //self.bubbleColor = [UIColor ];
}

#pragma mark - Lazy/Getter


- (UIColor *)bubbleColor {
    
    if (!_bubbleColor) {
        _bubbleColor = [UIColor greenColor];
    }
    return _bubbleColor;
}


#pragma mark -
@end

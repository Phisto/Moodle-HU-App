/*
 *  MOODLECourseDocumentItem.m
 *  Moodle
 *
 *  Created by Simon Gaus on 03.06.17.
 *  Copyright © 2017 Simon Gaus. All rights reserved.
 *
 */

@import UIKit;

#import "MOODLECourseSectionItem.h"

@interface MOODLECourseSectionItem (/* Private */)

@property (nonatomic, strong, nullable) NSAttributedString *attributedText;

@end


@implementation MOODLECourseSectionItem
#pragma mark - Lazy/Getter


- (NSAttributedString *)attributedText {
    
    if (!_attributedText) {

        NSString *raw = (self.textRaw) ? self.textRaw : @"";
        NSString *rawHTML = [raw stringByAppendingString:@"<style>body{font-family: '.SFUIText'; font-size:13px;}</style>"];
        NSAttributedString *courseDescription = [[NSAttributedString alloc] initWithData:[rawHTML dataUsingEncoding:NSUnicodeStringEncoding]
                                                                                 options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType,
                                                                                           NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)}
                                                                      documentAttributes:NULL
                                                                                   error:nil];
        
        _attributedText = courseDescription;
    }
    
    
    return _attributedText;
}

@end

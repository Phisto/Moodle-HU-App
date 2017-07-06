/*
 *
 *  MOODLEForumPost.m
 *  Moodle
 *
 *  Copyright © 2017 Simon Gaus. All rights reserved.
 *
 */

@import UIKit;

#import "MOODLEForumPost.h"

///-----------------------
/// @name CATEGORIES
///-----------------------



@interface MOODLEForumPost (/* Private */)

@property (nonatomic, strong) NSAttributedString *content;

@end



///-----------------------
/// @name IMPLEMENTATION
///-----------------------



@implementation MOODLEForumPost
#pragma mark - Lazy/Getter


- (NSAttributedString *)content {
    
    if (!_content) {
        
        NSString *rawHTML = [self.rawContent stringByAppendingString:@"<style>body{font-family: '.SFUIText'; font-size:17px;}</style>"];
        NSAttributedString *startercontent = [[NSAttributedString alloc] initWithData:[rawHTML dataUsingEncoding:NSUnicodeStringEncoding]
                                                                              options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType,
                                                                                        NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)}
                                                                   documentAttributes:NULL
                                                                                error:nil];
        _content = startercontent;
    }
    return _content;
}


- (BOOL)hasAttachments {
    
    return (self.attachments.count > 0);
}

#pragma mark -
@end

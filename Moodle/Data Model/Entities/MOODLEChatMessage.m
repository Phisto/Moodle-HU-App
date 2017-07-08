/*
 *
 *  MOODLEChatMessage.m
 *  Moodle
 *
 *  Copyright © 2017 Simon Gaus. All rights reserved.
 *
 */

@import UIKit;

#import "MOODLEChatMessage.h"

///-----------------------
/// @name CATEGORIES
///-----------------------



@interface MOODLEChatMessage (/* Private */)

@property (nonatomic, strong) NSAttributedString *attributedMessage;

@end



///-----------------------
/// @name IMPLEMENTATION
///-----------------------



@implementation MOODLEChatMessage
#pragma mark - Lazy/Getter

///!!!: Really? setting color in the model?? but for now i dont know another way of doing this (easily).
- (NSAttributedString *)attributedMessage {
    
    if (!_attributedMessage) {

        NSDictionary *options = @{NSDocumentTypeDocumentAttribute:          NSHTMLTextDocumentType,
                                  NSCharacterEncodingDocumentAttribute:     @(NSUTF8StringEncoding)};
        
        NSString *styleInfo = @"<style>body{font-family: '.SFUIText'; font-size:14px;}</style>";
        if (!self.isFromSelf) {
            
            styleInfo = @"<style>body{font-family: '.SFUIText'; font-size:14px; color: white;}</style>";
        }
        NSString *rawHTML = [self.rawMessage stringByAppendingString:styleInfo];
        
        NSAttributedString *message = [[NSAttributedString alloc] initWithData:[rawHTML dataUsingEncoding:NSUnicodeStringEncoding]
                                                                       options:options
                                                            documentAttributes:NULL
                                                                         error:nil];
        
        _attributedMessage = message;
    }
    
    
    return _attributedMessage;
}


#pragma mark -
@end

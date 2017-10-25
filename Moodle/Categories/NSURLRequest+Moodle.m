/*
 *
 *  NSURL+Moodle.m
 *  Moodle
 *
 *  Copyright © 2017 Simon Gaus. All rights reserved.
 *
 */

#import "NSURLRequest+Moodle.h"

///-----------------------
/// @name IMPLEMENTATION
///-----------------------



@implementation NSURLRequest (Moodle)
#pragma mark - Object Creation


+ (instancetype)moodle_loginRequestWithUsername:(NSString *)username andPassword:(NSString *)password {
    
    NSString *post = [NSString stringWithFormat:@"username=%@&password=%@&rememberusername=0", username, password];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    request.cachePolicy = NSURLRequestReloadIgnoringCacheData;
    [request setURL:[NSURL URLWithString:@"https://moodle.hu-berlin.de/login/index.php"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    return [request copy];
}


+ (instancetype)moodle_searchRequestWithSearchString:(NSString *)searchString {
    
    NSString *post = @"search=%@";
    post = [NSString stringWithFormat:post, searchString];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    request.cachePolicy = NSURLRequestReloadIgnoringCacheData;
    [request setURL:[NSURL URLWithString:@"https://moodle.hu-berlin.de/course/search.php"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    return [request copy];
    
}


+ (instancetype)moodle_logoutRequestWithSessionKey:(NSString *)sessionKey {
    
    NSString *post = @"sesskey=%@";
    post = [NSString stringWithFormat:post, sessionKey];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    request.cachePolicy = NSURLRequestReloadIgnoringCacheData;
    [request setURL:[NSURL URLWithString:@"https://moodle.hu-berlin.de/login/logout.php"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    return [request copy];
}


+ (instancetype)moodle_recentChatsRequest {
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    request.cachePolicy = NSURLRequestReloadIgnoringCacheData;
    [request setURL:[NSURL URLWithString:@"https://moodle.hu-berlin.de/message/index.php?viewing=recentconversations"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    return [request copy];
}


#pragma mark -
@end

/*
 *  NSURL+Moodle.m
 *  MOODLE
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
 *  You should have received a copy of the GNU Lesser General Public License
 *  along with this programm.  If not, see <http://www.gnu.org/licenses/>.
 *
 */


/* Header */
#import "NSURLRequest+Moodle.h"



///-----------------------
/// @name IMPLEMENTATION
///-----------------------



@implementation NSURLRequest (Moodle)
#pragma mark - Inititalization

+ (instancetype)moodle_loginRequestWithUsername:(NSString *)username andPassword:(NSString *)password {
    
    NSString *post = @"username=%@&password=%@&rememberusername=0";
    post = [NSString stringWithFormat:post, username, password];
    
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

#pragma mark -
@end

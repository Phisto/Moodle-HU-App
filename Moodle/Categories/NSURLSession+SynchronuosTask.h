/*
 *  NSURLSession+SynchronuosTask.h
 *  Moodle
 *
 *  Created by Simon Gaus on 03.06.17.
 *  Copyright © 2017 Simon Gaus. All rights reserved.
 *
 */

@import Foundation;

/*
 
 This category is a convenient categorie to perform synchronous requests via `NSURLSession` object.
 
 ## Discussion
 This solution was taken from the Apple developer forum, see the answer from eskimo: https://forums.developer.apple.com/thread/11519
 
 */

NS_ASSUME_NONNULL_BEGIN

@interface NSURLSession (SynchronousTask)
#pragma mark - Methodes
///---------------------------
/// @name Synchronous Requests
///---------------------------

/**
 
 Performs a synchronous requests.
 
 @param request The request to perform.
 
 @param responsePtr An object that provides response metadata, such as HTTP headers and status code. If you are making an HTTP or HTTPS request, the returned object is actually an NSHTTPURLResponse object..
 
 @param errorPtr An error object that indicates why the request failed, or nil if the request was successful.
 
 @return The respons data of the request or nil.
 
 */
- (nullable NSData *)moodle_sendSynchronousRequest:(NSURLRequest *)request
                                 returningResponse:(__autoreleasing NSURLResponse * _Nullable * _Nullable)responsePtr
                                             error:(__autoreleasing NSError **)errorPtr;

@end
NS_ASSUME_NONNULL_END

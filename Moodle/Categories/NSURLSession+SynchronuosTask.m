/*
 *
 *  NSURLSession+SynchronuosTask.m
 *  Moodle
 *
 *  Copyright © 2017 Simon Gaus. All rights reserved.
 *
 */

#import "NSURLSession+SynchronuosTask.h"

///-----------------------
/// @name IMPLEMENTATION
///-----------------------



@implementation NSURLSession (SynchronousTask)
#pragma mark - Synchronus Request


- (NSData *)moodle_sendSynchronousRequest:(NSURLRequest *)request
                        returningResponse:(__autoreleasing NSURLResponse **)responsePtr
                                    error:(__autoreleasing NSError **)errorPtr {
    dispatch_semaphore_t    sem;
    __block NSData *        result;
    
    result = nil;
    
    sem = dispatch_semaphore_create(0);
    
    [[self dataTaskWithRequest:request
             completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                 if (errorPtr != NULL) {
                     *errorPtr = error;
                 }
                 if (responsePtr != NULL) {
                     *responsePtr = response;
                 }
                 if (error == nil) {
                     result = data;
                 }
                 dispatch_semaphore_signal(sem);
             }] resume];
    
    dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
    
    return result;
}


#pragma mark -
@end

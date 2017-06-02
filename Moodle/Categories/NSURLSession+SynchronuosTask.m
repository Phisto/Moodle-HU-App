/*
 *  NSURLSession+SynchronuosTask.m
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

#import "NSURLSession+SynchronuosTask.h"



///-----------------------
/// @name IMPLEMENTATION
///-----------------------



@implementation NSURLSession (SynchronousTask)

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

@end

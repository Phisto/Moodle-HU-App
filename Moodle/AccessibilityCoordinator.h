/*
 *  AccessibilityCoordinator.h
 *  Moodle
 *
 *  Created by Simon Gaus on 03.06.17.
 *  Copyright © 2017 Simon Gaus. All rights reserved.
 *
 */

@import UIKit;

/**
 
 
 
 */

NS_ASSUME_NONNULL_BEGIN

@interface AccessibilityCoordinator : NSObject

- (void)accessibility_informUserViaVoiceOver:(NSString *)message
                                     timeout:(NSTimeInterval)timeout
                           completionHandler:(void (^)(void))completionHandler;

@end
NS_ASSUME_NONNULL_END

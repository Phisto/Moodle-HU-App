//
//  AccessibilityCoordinator.m
//  Moodle
//
//  Created by Simon Gaus on 03.06.17.
//  Copyright © 2017 Simon Gaus. All rights reserved.
//

#import "AccessibilityCoordinator.h"

typedef void (^CompletionHandler) (void);

@interface AccessibilityCoordinator (/* Private */)

@property (nonatomic) CompletionHandler completion;

@end


@implementation AccessibilityCoordinator
#pragma mark -

- (instancetype)init {
    
    self = [super init];
    if (self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(voiceOverFinished)
                                                     name:UIAccessibilityAnnouncementDidFinishNotification
                                                   object:nil];
    }
    return self;
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)accessibility_informUserViaVoiceOver:(NSString *)message
                                     timeout:(NSTimeInterval)timeout
                           completionHandler:(void (^)(void))completionHandler {
    
    [self setCompletion:completionHandler];

    UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, message);
    
    // call completion block if UIAccessibilityAnnouncementDidFinishNotification didnt fired
    [self performSelector:@selector(timedOut)
               withObject:nil
               afterDelay:timeout];
}

- (void)timedOut {
    
    self.completion();
    self.completion = nil;
}

- (void)voiceOverFinished {
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    if (self.completion) self.completion();
    self.completion = nil;
}

#pragma mark -
@end

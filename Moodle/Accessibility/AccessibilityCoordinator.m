/*
 *
 *  AccessibilityCoordinator.m
 *  Moodle
 *
 *  Copyright © 2017 Simon Gaus. All rights reserved.
 *
 */

#import "AccessibilityCoordinator.h"

///------------------------
/// @name TYPEDEFS
///------------------------



typedef void (^CompletionHandler) (void);



///------------------------
/// @name CATEGORIES
///------------------------



@interface AccessibilityCoordinator (/* Private */)

@property (nonatomic) CompletionHandler completion;

@end



///------------------------
/// @name IMPLEMENTATION
///------------------------



@implementation AccessibilityCoordinator
#pragma mark - Objet Life Cycle


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


#pragma mark - Synchronisation Methodes


- (void)accessibility_informUserViaVoiceOver:(NSString *)message
                                     timeout:(NSTimeInterval)timeout
                           completionHandler:(void (^)(void))completionHandler {
    
    [self setCompletion:completionHandler];

    UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, message);
    
    // call completion block after timeout if UIAccessibilityAnnouncementDidFinishNotification did not fire...
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

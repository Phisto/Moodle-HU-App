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
 
 The `AccessibilityCoordinator`class is a convenient class to solve VoiceOver timing problems.
 
 ## Discussion
 I created this class to takle a specific VoiceOver timing problem:
 
 1. The user activates a button, for example a login button, VoiceOver will read this activation to the user.
 2. The action does inform the user of success or failure (the result) via VoiceOver.
 3. If the action returns quickly and tries to inform the user while VoiceOver is still reading the button activation,
    this message will be ommited by VoiceOver and the user will stay uninformed about the result.
 
 This class offers a way to inform the user via VoicOver and than execute code inside a completion handler.
 
 ## Notes
 The class will wait for an UIAccessibilityAnnouncementDidFinishNotification and then execute the completion handler.
 There seem to be situations in which this notification wont be fired, so there is a timeout after which
 the completion handler will be called even if the notification was not fired.
 
 See marcelnijman's comment under the accepted answer:
 https://stackoverflow.com/questions/12354828/uiaccessibilityannouncementnotification-asynch-isssue
 
 */

NS_ASSUME_NONNULL_BEGIN

@interface AccessibilityCoordinator : NSObject

/**
 This method will announce a given message via VoicOver and than execute a completion handler.
 
 @param message The message to announce.
 
 @param timeout The max time after which the completion handler should be executed, even if VoiceOver did not finish reading the message.
 
 @param completionHandler The completion handler to execute. The completion handler does not take any arguments.
 
 */
- (void)accessibility_informUserViaVoiceOver:(NSString *)message
                                     timeout:(NSTimeInterval)timeout
                           completionHandler:(void (^)(void))completionHandler;

@end
NS_ASSUME_NONNULL_END

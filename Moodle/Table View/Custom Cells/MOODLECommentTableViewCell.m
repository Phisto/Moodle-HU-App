/*
 *
 *  MOODLECommentTableViewCell.m
 *  Moodle
 *
 *  Copyright © 2017 Simon Gaus. All rights reserved.
 *
 */

#import "MOODLECommentTableViewCell.h"

@implementation MOODLECommentTableViewCell
@end



#pragma mark - ACCESSIBILITY
///-----------------------
/// @name ACCESSIBILITY
///-----------------------



@implementation MOODLECommentTableViewCell (Accessibility)
#pragma mark -


- (NSArray<UIAccessibilityCustomAction *> *)accessibilityCustomActions {
    
    NSString *locString = NSLocalizedString(@"Kommentar vorlesen", @"voice over action to read komment title");
    return @[[[UIAccessibilityCustomAction alloc] initWithName:locString
                                                        target:self
                                                      selector:@selector(readComment)]];
}


- (void)readComment {
    
    [self accessibility_informUserViaVoiceOver:self.textView.text];
}


- (void)accessibility_informUserViaVoiceOver:(NSString *)message {
    
    UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, message);
}


#pragma mark -
@end

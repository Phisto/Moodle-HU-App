/*
 *
 *  MOODLEChatMessage.h
 *  Moodle
 *
 *  Copyright © 2017 Simon Gaus. All rights reserved.
 *
 */

@import Foundation;

/**
 
 A MOODLEChat object represents a chat with another Moodle user.
 
 */

NS_ASSUME_NONNULL_BEGIN

@interface MOODLEChatMessage : NSObject

/**
 The date the message was registered.
 */
@property (nonatomic, strong) NSString *date;
/**
 The time the message was registered.
 */
@property (nonatomic, strong) NSString *time;
/**
 The message.
 */
@property (nonatomic, readonly) NSAttributedString *attributedMessage;
/**
 The raw message.
 */
@property (nonatomic, strong) NSString *rawMessage;
/**
 Boolean indicating if the message is from the currently logged in user.
 */
@property (nonatomic, readwrite) BOOL isFromSelf;


@end
NS_ASSUME_NONNULL_END

/*
 *
 *  MOODLEChat.h
 *  Moodle
 *
 *  Copyright © 2017 Simon Gaus. All rights reserved.
 *
 */

@import Foundation;

@class MOODLEChatMessage;

/**
 
 A MOODLEChat object represents a chat with another Moodle user.
 
 */

NS_ASSUME_NONNULL_BEGIN

@interface MOODLEChat : NSObject

/**
 The name of the other Moodle user.
 */
@property (nonatomic, strong) NSString *chatPartnerName;
/**
 The date of the last message.
 */
@property (nonatomic, strong) NSString *lastMessageDate;
/**
 A preview text of the last message.
 */
@property (nonatomic, strong) NSString *previewMessage;
/**
 The url of the chat.
 */
@property (nonatomic, strong) NSURL *chatURL;
/**
 The messages associated with this chat.
 */
@property (nullable, nonatomic, strong) NSArray<NSArray<MOODLEChatMessage *> *> *messages;

@end
NS_ASSUME_NONNULL_END

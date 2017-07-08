/*
 *
 *  MOODLEChatItemViewController.h
 *  Moodle
 *
 *  Copyright © 2017 Simon Gaus. All rights reserved.
 *
 */

@import UIKit;

@class MOODLEChat;

/**
 
  The `MOODLEChatItemViewController` is responsible for presenting a `MOODLEChat` objects to the user.
 
 */

NS_ASSUME_NONNULL_BEGIN

@interface MOODLEChatItemViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

/**
 The chat item to display.
 */
@property (nonatomic, strong) MOODLEChat *chat;

@end
NS_ASSUME_NONNULL_END

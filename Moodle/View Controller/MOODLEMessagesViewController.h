/*
 *
 *  MOODLEMessagesViewController.h
 *  Moodle
 *
 *  Copyright © 2017 Simon Gaus. All rights reserved.
 *
 */

@import UIKit;

/**
 
 The `MOODLEMessagesViewController` is responsible for presenting an array of `MOODLEChat` objects to the user.
 
 */

NS_ASSUME_NONNULL_BEGIN

@interface MOODLEMessagesViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@end
NS_ASSUME_NONNULL_END

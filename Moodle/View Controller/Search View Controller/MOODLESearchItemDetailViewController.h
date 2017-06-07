/*
 *  MOODLESearchItemDetailViewController.h
 *  Moodle
 *
 *  Created by Simon Gaus on 03.06.17.
 *  Copyright © 2017 Simon Gaus. All rights reserved.
 *
 */

@import UIKit;

@class MOODLESearchItem;

/**
 
 The MOODLESearchItemDetailViewController is responsible for presenting a `MOODLESearchItem` object to the user.
 
 */

NS_ASSUME_NONNULL_BEGIN

@interface MOODLESearchItemDetailViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
#pragma mark - Properties
///--------------------
/// @name Properties
///--------------------

/**
 The MOODLESearchItem to present.
 */
@property (nonatomic, strong) MOODLESearchItem *item;

@end
NS_ASSUME_NONNULL_END

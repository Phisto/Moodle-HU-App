/*
 *
 *  MOODLEForumEntryViewController.h
 *  Moodle
 *
 *  Copyright © 2017 Simon Gaus. All rights reserved.
 *
 */

@import UIKit;

@class MOODLEForumEntry, MOODLEDataModel;

/**
 
 The `MOODLEForumEntryViewController` is responsible for presenting a `MOODLEForumEntry` object to the user.
 
 */

NS_ASSUME_NONNULL_BEGIN

@interface MOODLEForumEntryViewController : UIViewController
/**
 The forum thread to display.
 */
@property (nonatomic, strong) MOODLEForumEntry *entry;
/**
 The app's data model object.
 */
@property (nonatomic, weak) MOODLEDataModel *dataModel;

@end
NS_ASSUME_NONNULL_END

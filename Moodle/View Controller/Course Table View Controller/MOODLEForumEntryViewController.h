//
//  MOODLEForumEntryViewController.h
//  Moodle
//
//  Created by Simon Gaus on 30.06.17.
//  Copyright © 2017 Simon Gaus. All rights reserved.
//

@import UIKit;

@class MOODLEForumEntry, MOODLEDataModel;

/**
 
 
 
 */

NS_ASSUME_NONNULL_BEGIN

@interface MOODLEForumEntryViewController : UIViewController
/**
 
 */
@property (nonatomic, strong) MOODLEForumEntry *entry;
/**
 
 */
@property (nonatomic, weak) MOODLEDataModel *dataModel;

@end
NS_ASSUME_NONNULL_END

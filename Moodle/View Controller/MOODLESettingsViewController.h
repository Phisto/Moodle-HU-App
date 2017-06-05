/*
 *  MOODLESettingsViewController.h
 *  Moodle
 *
 *  Created by Simon Gaus on 03.06.17.
 *  Copyright © 2017 Simon Gaus. All rights reserved.
 *
 */

@import UIKit;


/**
 
 The `MOODLESettingsViewController` is responsible for presenting the app settings to the user. 
 Here he can manage and unhide Moodle courses he previously set hidden.
 
 */

NS_ASSUME_NONNULL_BEGIN

@interface MOODLESettingsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@end
NS_ASSUME_NONNULL_END

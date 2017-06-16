/*
 *  MOODLEURLRessourceViewController.h
 *  Moodle
 *
 *  Created by Simon Gaus on 03.06.17.
 *  Copyright © 2017 Simon Gaus. All rights reserved.
 *
 */

@import UIKit;

/**
 
 The MOODLEURLRessourceViewController is responsible for presenting a local ressource to the user.
 
 */

NS_ASSUME_NONNULL_BEGIN

@interface MOODLEURLRessourceViewController : UIViewController <UIWebViewDelegate>
#pragma mark - Properties
///--------------------
/// @name Properties
///--------------------


/**
 The url of the local ressource.
 */
@property (nonatomic, strong) NSURL *localRessourceURL;


@end
NS_ASSUME_NONNULL_END

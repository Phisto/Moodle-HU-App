/*
 *  MOODLEDocumentViewController.h
 *  Moodle
 *
 *  Created by Simon Gaus on 03.06.17.
 *  Copyright © 2017 Simon Gaus. All rights reserved.
 *
 */

@import UIKit;

/**
 
 The MOODLEDocumentViewController is responsible for presenting MOODLE course section ressources.
 
 ##Overview
 All resources are displayed via an UIWebView. 
 It may be better do use different kind of views to diplay different kind of ressources.
 
 */

NS_ASSUME_NONNULL_BEGIN

@interface MOODLEDocumentViewController : UIViewController
#pragma mark - Properties
///--------------------
/// @name Properties
///--------------------

/**
 Boolean indicating if the ressource needs to play audio.
 */
@property (nonatomic, readwrite) BOOL isAudio;
/**
 The url to the ressource.
 */
@property (nonatomic, strong) NSURL *resourceURL;

@end
NS_ASSUME_NONNULL_END

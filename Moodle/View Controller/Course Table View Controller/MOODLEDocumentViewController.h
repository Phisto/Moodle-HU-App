/*
 *  MOODLEDocumentViewController.h
 *  Moodle
 *
 *  Created by Simon Gaus on 03.06.17.
 *  Copyright © 2017 Simon Gaus. All rights reserved.
 *
 */

@import UIKit;

@class MOODLECourseSectionItem;

/**
 
 The MOODLEDocumentViewController is responsible for presenting MOODLE course section ressources.
 
 */

NS_ASSUME_NONNULL_BEGIN

@interface MOODLEDocumentViewController : UIViewController <UIWebViewDelegate>
#pragma mark - Properties
///--------------------
/// @name Properties
///--------------------

/**
 The item to present.
 */
@property (nonatomic, strong) MOODLECourseSectionItem *item;

@end
NS_ASSUME_NONNULL_END

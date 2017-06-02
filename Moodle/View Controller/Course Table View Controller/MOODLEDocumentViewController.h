/*
 *  MOODLEDocumentViewController.h
 *  MOODLE
 *
 *  Copyright © 2017 Simon Gaus <simon.cay.gaus@gmail.com>
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU Lesser General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU Lesser General Public License for more details.
 *
 *  You should have received a copy of the GNU Lesser General Public License
 *  along with this programm.  If not, see <http://www.gnu.org/licenses/>.
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

/*
 *  NSURL+Moodle.h
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

@import Foundation;

NS_ASSUME_NONNULL_BEGIN

/**
 
 This category is a convenient categorie to create spezific NSURLRequests to send to the MOODLE server.
 
 */

@interface NSURLRequest (Moodle)
#pragma mark - Methodes
///----------------------
/// @name Inititalization
///----------------------

/**
 
 Creates and returns a NSURLRequest object configured to perform a login request.
 
 @param username The username to use for login.
 
 @param password The password to use for login.
 
 @return An initialized NSURLRequest object.
 
 */
+ (instancetype)moodle_loginRequestWithUsername:(NSString *)username andPassword:(NSString *)password;
/**
 
 Creates and returns a NSURLRequest object configured to perform a search request.
 
 @param searchString The search query string to use for the search.
 
 @return An initialized NSURLRequest object.
 
 */
+ (instancetype)moodle_searchRequestWithSearchString:(NSString *)searchString;
/**
 
 Creates and returns a NSURLRequest object configured to perform a logout request.
 
 @param sessionKey The sessionkey of the MOODLE session we want to logout.
 
 */
+ (instancetype)moodle_logoutRequestWithSessionKey:(NSString *)sessionKey;

@end
NS_ASSUME_NONNULL_END

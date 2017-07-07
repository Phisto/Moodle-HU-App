/*
 *
 *  NSURL+Moodle.h
 *  Moodle
 *
 *  Copyright © 2017 Simon Gaus. All rights reserved.
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
/**
 
 Creates and returns a NSURLRequest object configured to perform a recent chat fetch request.
 
 */
+ (instancetype)moodle_recentChatsRequest;

@end
NS_ASSUME_NONNULL_END

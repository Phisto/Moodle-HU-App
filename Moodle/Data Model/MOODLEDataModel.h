/*
 *  MOODLEDataModel.h
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

@class MOODLECourse;

/**
 
 The MOODLEDataModel class represents the data model for the MOODLE app.
 
 ## Discussion
 The apps data is only accessible through this class and every manipulation on the data is made through this class.
 
 */

NS_ASSUME_NONNULL_BEGIN

@interface MOODLEDataModel : NSObject
#pragma mark - Login
///----------------------------
/// @name Data Model Life Cycle
///----------------------------

+ (instancetype)sharedDataModel;
/**
 
 UNAVAILABLE. This class is a singleton class to access the singleton use `+sharedDataModel`.
 
 @return Allocates a new instance of the receiving class, sends it an init message, and returns the initialized object.
 */
+ (instancetype)new NS_UNAVAILABLE;
/**
 
 UNAVAILABLE. This class is a singleton class to access the singleton use `+sharedDataModel`.

 @return An initialized object, or nil if an object could not be created for some reason that would not result in an exception.
*/
- (instancetype)init NS_UNAVAILABLE;

#pragma mark - Data
///--------------------
/// @name Data
///--------------------

/**
 A mutable array of MOODLE courses.
 */
@property (nonatomic, strong) NSMutableArray<MOODLECourse *> *courseArray;
/**
 A mutable array of MOODLE courses that are hidden.
 */
@property (nonatomic, strong) NSMutableArray<MOODLECourse *> *hiddenCourses;

#pragma mark - Login
///---------------------
/// @name Login
///---------------------

/**
 Boolean indicating if the app has stored user credentials in the keychain.
 */
@property (nonatomic, readwrite) BOOL hasUserCredentials;
/**
 Boolean indicating if the app should store the user credentials in the keychain.
 */
@property (nonatomic, readwrite) BOOL shouldRememberCredentials;
/**
 Boolean indicating if the app should auto login.
 */
@property (nonatomic, readwrite) BOOL shouldAutoLogin;
/**
 The stored username.
 */
@property (nonatomic, strong) NSString *userName;
/**
 Thes stored password.
 */
@property (nonatomic, strong) NSString *userPassword;
/**
 The date of the login.
 */
@property (nonatomic, strong, nullable) NSDate *loginDate;
/**
 
 This method will store the given user credentials in the devices keychain. The password will be stored encrypted and only accessible to the app.
 
 @param username The username to store.
 
 @param password The password to store.
 
 */
- (void)saveUserCredentials:(NSString *)username andPassword:(NSString *)password;
/**
 
 This method will delete the stored the user credentials in the devices keychain.
 
 */
- (void)deleteUserCredentials;

#pragma mark - Hide/Favorit
///----------------------
/// @name Hide/Favorite
///----------------------
/**
 
 This method will set the isHidden flag of the given item to a persistent store.
 
 @param item The item to hide/unhide.
 
 @param hidden Weather the item is hidden or not.
 
 */
- (void)setItem:(MOODLECourse *)item isHidden:(BOOL)hidden;
/**
 
 This method will set the isFavourite flag of the given item to a persistent store.
 
 @param item The item to flag.
 
 @param favorit Boolean indicating if the item is a favorit or not.
 
 */
- (void)setItem:(MOODLECourse *)item isFavorit:(BOOL)favorit;
/**
 
 This method will save the current MOODLE course order to disk, so it can be restored the next time the app is loaded.
 
 */
- (void)updateCourseItemsOrderingWeight;

#pragma mark - Data loading
///----------------------
/// @name Data Loading
///----------------------

/**
 
 This method will login a user with the given credentials.
 
 @param username The username to use.
 
 @param password The password to use.
 
 @param completionHandler The completion handler to call when the login is complete. This handler is executed on the main thread.
 
 */
- (void)loginWithUsername:(NSString *)username
                 password:(NSString *)password
        completionHandler:(void (^)(BOOL success, NSError * _Nullable error))completionHandler;
/**
 
 This method will logout the user.
 
 */
- (void)logoutWithCompletionHandler:(void (^)(BOOL success, NSError * _Nullable error))completionHandler;
/**
 
 This method load the content of a given MOODLE course.
 
 @param item The item.
 
 @param completionHandler The completion handler to call when content loading is complete. This handler is executed on the main thread.
 
 */
- (void)loadItemContentForItem:(MOODLECourse *)item
             completionHandler:(void (^)(BOOL success, NSError * _Nullable error))completionHandler;
/**
 
 This method will perform a search for MOODLE courses with a given search query.
 
 @param searchString The search query string.
 
 @param completionHandler The completion handler to call when searching is complete. This handler is executed on the main thread.
 
 */
- (void)loadSearchResultWithSerachString:(NSString *)searchString
                       completionHandler:(void (^)(BOOL success, NSError * _Nullable error, NSArray * _Nullable searchResults))completionHandler;

@end
NS_ASSUME_NONNULL_END

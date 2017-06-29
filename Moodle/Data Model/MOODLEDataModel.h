/*
 *  MOODLEDataModel.h
 *  Moodle
 *
 *  Created by Simon Gaus on 03.06.17.
 *  Copyright © 2017 Simon Gaus. All rights reserved.
 *
 */

@import Foundation;

@class MOODLECourse, MOODLECourseSectionItem;

/**
 
 The MOODLEDataModel class represents the data model for the MOODLE app.
 
 ## Discussion
 The apps data is only accessible through this class and every manipulation on the data is made through this class.
 
 */

NS_ASSUME_NONNULL_BEGIN

@interface MOODLEDataModel : NSObject
#pragma mark - Data Model Life Cycle
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
 
 @brief This method will login a user with the given credentials.
 
 @param username The username to use.
 
 @param password The password to use.
 
 @param completionHandler The completion handler to call when the login is complete. This handler is executed on the main thread.
 
 */
- (void)loginWithUsername:(NSString *)username
                 password:(NSString *)password
        completionHandler:(void (^)(BOOL success, NSError * _Nullable error))completionHandler;
/**
 
 @brief This method will logout the user.
 
 @param completionHandler The completion handler to call when content loggout is complete.
 
 */
- (void)logoutWithCompletionHandler:(void (^)(BOOL success, NSError * _Nullable error))completionHandler;
/**
 
 @brief This method will load the content of a given MOODLE course.
 
 @param item The item.
 
 @param completionHandler The completion handler to call when content loading is complete. This handler is executed on the main thread.
 
 */
- (void)loadItemContentForItem:(MOODLECourse *)item
             completionHandler:(void (^)(BOOL success, NSError * _Nullable error))completionHandler;
/**
 
 @brief This method will perform a search for MOODLE courses with a given search query.
 
 @param searchString The search query string.
 
 @param completionHandler The completion handler to call when searching is complete. This handler is executed on the main thread.
 
 */
- (void)loadSearchResultWithSerachString:(NSString *)searchString
                       completionHandler:(void (^)(BOOL success, NSError * _Nullable error, NSArray * _Nullable searchResults))completionHandler;



#pragma mark - Documents
///----------------------
/// @name Documents
///----------------------

/**
 The size of the document cache in Megabytes.
 */
@property (nonatomic, readwrite) NSUInteger documentCacheSize;
/**
 
 @brief This method will search for a local file assoziated with the given item.
 
 @param item The item to search for.
 
 @return  A NSURL to the local file or nil if there is no cached file.
 
 */
- (nullable NSURL *)localRessourceURLForItem:(MOODLECourseSectionItem *)item;
/**
 
 This method will load the file for the given item, save it locally and call the completion handler.
 
 @param item The item to load the file for.
 
 @param completionHandler The completion handler to call when loading and saving is complete. This handler is executed on the main thread.
 
 */
- (void)saveRemoteRessource:(MOODLECourseSectionItem *)item
          completionHandler:(void (^)(BOOL success, NSError * _Nullable error, NSURL * _Nullable localRessourceURL))completionHandler;
/**
 
 This method will enumerate through all cached documents and calculate the size.
 
 @return The size of all cached documents in Megabyte as a NSInteger.
 
 */
- (NSInteger)sizeOfCachedDocuments;
/**
 
 This method will return all cached document urls.
 
 @return The document urls.
 
 */
- (NSArray<NSURL *> *)allRessourceURLS;
/**
 
 This method will delete the file or folder at the given url.
 
 @param docURL The url to the file or folder.
 
 @return Yes if the file was deleted, NO if the file could not be deleted or if there was no file at the given url.
 
 */
- (BOOL)deleteDocumentWithURL:(NSURL *)docURL;


@end
NS_ASSUME_NONNULL_END

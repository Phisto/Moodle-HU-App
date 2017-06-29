/*
 *  MOODLERessourceCoordinator.h
 *  Moodle
 *
 *  Created by Simon Gaus on 03.06.17.
 *  Copyright © 2017 Simon Gaus. All rights reserved.
 *
 */

@import Foundation;

@class MOODLECourseSectionItem;

/**

 The MOODLERessourceCoordinator class is used to coordinate the locally stored files.
 
 */

NS_ASSUME_NONNULL_BEGIN

@interface MOODLERessourceCoordinator : NSObject
#pragma mark - Data Model Life Cycle
///----------------------------
/// @name Data Model Life Cycle
///----------------------------

/**
 
 Initialzes a MOODLERessourceCoordinator object.
 
 @param session The sesson to use for network requests.
 
 @return An initialized MOODLERessourceCoordinator object.
 
 */
- (instancetype)initWithSession:(NSURLSession *)session;



#pragma mark - Ressource Methodes
///----------------------------
/// @name Ressource Methodes
///----------------------------

/**
 
 @brief This method will search for a local file assoziated with the given item.
 
 @param item The item to search for.
 
 @return  A NSURL to the local file or nil if there is no cached file.
 
 */
- (nullable NSURL *)localRessourceURLForItem:(MOODLECourseSectionItem *)item;
/**
 
 @brief This method will load the file for the given item, save it locally and call the completion handler.
 
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

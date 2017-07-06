/*
 *
 *  MOODLEPersistentStoreCoordinator.h
 *  Moodle
 *
 *  Copyright © 2017 Simon Gaus. All rights reserved.
 *
 */

@import Foundation;

/**
 
 The MOODLEPersistentStoreCoordinator class is used to coordinate the persistently stored values for the app.
 
 */

NS_ASSUME_NONNULL_BEGIN

@interface MOODLEPersistentStoreCoordinator : NSObject

/**
 The size of the document cache in Megabytes.
 */
@property (nonatomic, readwrite) NSUInteger documentCacheSize;

@end
NS_ASSUME_NONNULL_END

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
 
 
 
 */

NS_ASSUME_NONNULL_BEGIN

@interface MOODLEPersistentStoreCoordinator : NSObject

/**
 The size of the document cache in Megabytes.
 */
@property (nonatomic, readwrite) NSUInteger documentCacheSize;

@end
NS_ASSUME_NONNULL_END

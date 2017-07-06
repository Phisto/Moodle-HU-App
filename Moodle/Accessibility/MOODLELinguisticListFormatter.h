/*
 *
 *  MOODLELinguisticListFormatter.h
 *  Moodle
 *
 *  Copyright © 2017 Simon Gaus. All rights reserved.
 *
 */

@import Foundation;

/**
 
 
 
 */

NS_ASSUME_NONNULL_BEGIN

@interface MOODLELinguisticListFormatter : NSObject

/**
 
 
 */
- (void)addItemToList:(NSString *)item;
/**
 
 
 */
- (NSString *)list;

@end
NS_ASSUME_NONNULL_END

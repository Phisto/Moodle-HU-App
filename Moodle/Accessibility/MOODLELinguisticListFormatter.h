/*
 *  MOODLELinguisticListFormatter.h
 *  Moodle
 *
 *  Created by Simon Gaus on 03.06.17.
 *  Copyright © 2017 Simon Gaus. All rights reserved.
 *
 */

@import Foundation;

/**
 
 
 
 */

NS_ASSUME_NONNULL_BEGIN

@interface MOODLELinguisticListFormatter : NSObject

- (void)addItemToList:(NSString *)item;
- (NSString *)list;

@end
NS_ASSUME_NONNULL_END

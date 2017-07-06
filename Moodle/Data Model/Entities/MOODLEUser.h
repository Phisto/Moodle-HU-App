/*
 *
 *  MOODLEUser.h
 *  Moodle
 *
 *  Copyright © 2017 Simon Gaus. All rights reserved.
 *
 */

@import Foundation;

/**
 
 A MOODLEUser object represents a MOODLE user.
 
 */

NS_ASSUME_NONNULL_BEGIN
@interface MOODLEUser : NSObject

/**
 The name of the user.
 */
@property (nonatomic, strong) NSString *name;
/**
 The country name of the user.
 */
@property (nonatomic, strong) NSString *country;
/**
 The city name of the user.
 */
@property (nonatomic, strong) NSString *city;
/**
 The ID of the user.
 */
@property (nonatomic, strong) NSString *userID;

@end
NS_ASSUME_NONNULL_END

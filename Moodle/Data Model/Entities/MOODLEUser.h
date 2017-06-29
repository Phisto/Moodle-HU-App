//
//  MOODLEUser.h
//  Moodle
//
//  Created by Simon Gaus on 29.06.17.
//  Copyright © 2017 Simon Gaus. All rights reserved.
//

@import Foundation;

/**
 
 A MOODLECourse object represents a MOODLE course.
 
 */

NS_ASSUME_NONNULL_BEGIN
@interface MOODLEUser : NSObject

@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) NSString *country;

@property (nonatomic, strong) NSString *city;

@property (nonatomic, strong) NSString *userID;

@end
NS_ASSUME_NONNULL_END

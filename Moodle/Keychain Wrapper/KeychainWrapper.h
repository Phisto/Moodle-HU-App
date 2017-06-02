//
//  KeychainWrapper.h
//  Apple's Keychain Services Programming Guide
//
//  Created by Tim Mitra on 11/17/14.
//  Copyright (c) 2014 Apple. All rights reserved.
//

@import Foundation;
@import Security;

/**
 
 The KeychainWrapper class is a wrapper class to easily access the phones keychain.
 
 ##Discussion
 This source code was taken from raywenderlich.com:
 https://www.raywenderlich.com/92667/securing-ios-data-keychain-touch-id-1password
 
 and refers to Apples's Keychain Services Programming Guide a the source:
 https://developer.apple.com/library/content/documentation/Security/Conceptual/keychainServConcepts/iPhoneTasks/iPhoneTasks.html
 
 */

NS_ASSUME_NONNULL_BEGIN

@interface KeychainWrapper : NSObject

- (void)mySetObject:(id)inObject forKey:(id)key;

- (id)myObjectForKey:(id)key;

- (void)writeToKeychain;

@end
NS_ASSUME_NONNULL_END

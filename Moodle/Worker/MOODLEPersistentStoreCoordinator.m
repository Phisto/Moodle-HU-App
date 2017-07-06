/*
 *
 *  MOODLEPersistentStoreCoordinator.h
 *  Moodle
 *
 *  Copyright © 2017 Simon Gaus. All rights reserved.
 *
 */

#import "MOODLEPersistentStoreCoordinator.h"

///-----------------------
/// @name CONSTANTS
///-----------------------



static NSString * const UserDefaultsDocumentCacheSizeKey = @"UserDefaultsDocumentCacheSizeKey";



///-----------------------
/// @name CATEGORIES
///-----------------------



@interface MOODLEPersistentStoreCoordinator (/* Private */)

// Other
@property (nonatomic, strong) NSUserDefaults *defaults;

@end



///-----------------------
/// @name IMPLEMENTATION
///-----------------------



@implementation MOODLEPersistentStoreCoordinator
#pragma mark - Syntheszie


@synthesize documentCacheSize = _documentCacheSize;


#pragma mark - NSUserDefaults


- (void)setDocumentCacheSize:(NSUInteger)documentCacheSize {
    
    
    if (_documentCacheSize != documentCacheSize) {
        
        [self.defaults setInteger:documentCacheSize
                           forKey:UserDefaultsDocumentCacheSizeKey];
        _documentCacheSize = documentCacheSize;
    }
}


- (NSUInteger)documentCacheSize {
    
    
    if (_documentCacheSize == 0) {
        
        NSNumber *number = [self.defaults objectForKey:UserDefaultsDocumentCacheSizeKey];
        if (number == nil) {
            _documentCacheSize = 10;
            [self.defaults setInteger:10
                               forKey:UserDefaultsDocumentCacheSizeKey];
        }
        else {
            _documentCacheSize = number.unsignedIntegerValue;
        }
    }
    return _documentCacheSize;
}


#pragma mark - Lazy/Getter


- (NSUserDefaults *)defaults {
    
    if (!_defaults) {
        
        _defaults = [NSUserDefaults standardUserDefaults];
    }
    return _defaults;
}


#pragma mark -
@end

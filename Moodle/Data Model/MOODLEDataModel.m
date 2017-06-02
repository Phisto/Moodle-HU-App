/*
 *  MOODLEDataModel.m
 *  MOODLE
 *
 *  Copyright © 2017 Simon Gaus <simon.cay.gaus@gmail.com>
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU Lesser General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU Lesser General Public License for more details.
 *
 *  You should have received a copy of the GNU Lesser General Public License
 *  along with this programm.  If not, see <http://www.gnu.org/licenses/>.
 *
 */

@import UIKit;

#import "MOODLEDataModel.h"

/* Worker */
#import "MOODLEXMLParser.h"

/* Entities */
#import "MOODLECourse.h"
#import "MOODLESearchItem.h"
#import "MOODLECourseSection.h"

/* Networking */
#import "NSURLSession+SynchronuosTask.h"
#import "NSURLRequest+Moodle.h"

/* External */
#import "TFHpple.h"
#import "KeychainWrapper.h"

static NSString * const UserDefaultsFirstLoginKey = @"UserDefaultsFirstLoginKey";
static NSString * const UserDefaultsShouldRememberCredentialsKey = @"UserDefaultsShouldRememberCredentialsKey";
static NSString * const UserDefaultsShouldAutoLoginKey = @"UserDefaultsShouldAutoLoginKey";
static NSString * const UserDefaultsHasCredentialsKey = @"UserDefaultsHasCredentialsKey";
static NSString * const UserDefaultsFavouritesArrayKey = @"UserDefaultsFavouritesArrayKey";
static NSString * const UserDefaultsDeletedArrayKey = @"UserDefaultsDeletedArrayKey";
static NSString * const UserDefaultsOrderingWeightsArrayKey = @"UserDefaultsOrderingWeightsArrayKey";
static NSString * const UserDefaultsLoginDateKey = @"UserDefaultsLoginDateKey";

typedef void (^CompletionBlock)(BOOL success, NSError *error);

@interface MOODLEDataModel (/* Private */)

@property (nonatomic, strong) MOODLEXMLParser *xmlParser;
@property (nonatomic, strong) KeychainWrapper *keyChainWrapper;
@property (nonatomic, strong) NSString *sessionKey;
@property (nonatomic, strong) NSUserDefaults *defaults;
@property (nonatomic, strong) NSURLSession *currentSession;

@property (nonatomic, strong) NSMutableArray<NSString *> *hiddedCourseIdentifier;
@property (nonatomic, strong) NSMutableArray<NSString *> *favouriteIdentifier;
@property (nonatomic, strong) NSMutableDictionary *orderingWeightDictionaries; // @{item.title: 100}

@end



///-----------------------
/// @name IMPLEMENTATION
///-----------------------



@implementation MOODLEDataModel
#pragma mark - Object Life Cycle

+ (instancetype)sharedDataModel {
    
    static MOODLEDataModel *sharedDataModel = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedDataModel = [[[self class] alloc] init_private];
    });
    return sharedDataModel;

}

- (instancetype)init_private {
    
    self = [super init];
    if (self) {
        
        // reate parser
        _xmlParser = [[MOODLEXMLParser alloc] init];
        // create seesion
        NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
        _currentSession = [NSURLSession sessionWithConfiguration:defaultConfigObject
                                                        delegate:nil
                                                   delegateQueue:[NSOperationQueue mainQueue]];
        
        _hiddenCourses = [NSMutableArray array];
        
        
        // when its the first app start, initialize user defaults
        BOOL isFirstLogin = ![self.defaults boolForKey:UserDefaultsFirstLoginKey];
        if (isFirstLogin) {
            
            [self.defaults setBool:YES forKey:UserDefaultsFirstLoginKey];
            
            self.hasUserCredentials = NO;
            self.shouldRememberCredentials = YES;
            self.shouldAutoLogin = NO;
        }
        else {
            
            // dont use setter as the would trigger user default write
            _hasUserCredentials = [self.defaults boolForKey:UserDefaultsHasCredentialsKey];
            _shouldRememberCredentials = [self.defaults boolForKey:UserDefaultsShouldRememberCredentialsKey];
            _shouldAutoLogin = [self.defaults boolForKey:UserDefaultsShouldAutoLoginKey];
        }
    }
    return self;
}

- (instancetype)init {
    
    NSAssert(false,@"Unavailable, use `+sharedDataModel` instead.");
    return nil;
}

+ (instancetype)new {
    
    NSAssert(false,@"Unavailable, use `+sharedDataModel` instead.");
    return nil;
}

/**
 
 Calling this method will reset the data model to the same state as after initialization.
 
 */
- (void)resetData {
    
    // reate parser
    self.xmlParser = [[MOODLEXMLParser alloc] init];
    // create seesion
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    self.currentSession = [NSURLSession sessionWithConfiguration:defaultConfigObject
                                                    delegate:nil
                                               delegateQueue:[NSOperationQueue mainQueue]];
    
    self.hiddenCourses = [NSMutableArray array];
}

#pragma mark - Asynchronous API

- (void)loadSearchResultWithSerachString:(NSString *)searchString
                         completionBlock:(void (^)(BOOL success, NSError * _Nullable error, NSArray * _Nullable searchResults))completionHandler {
    
    NSURLResponse * response = nil;
    NSError *requestError = nil;
    NSData *data = [self.currentSession moodle_sendSynchronousRequest:[NSURLRequest moodle_searchRequestWithSearchString:searchString]
                                                    returningResponse:&response
                                                                error:&requestError];
    
    // handle basic connectivity issues here
    if (!data) {
        
        completionHandler(NO, (requestError) ? requestError : nil, nil);
        return;
    }
    
    // handle HTTP errors here
    if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
        
        NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
        
        if (statusCode != 200) {
            
            NSString *locString = NSLocalizedString(@"Bei der Kommunikation mit dem Server, ist ein Fehler aufgetreten.", @"Error message if the server wont respond with 200 http response code.");
            NSDictionary *userInfo = @{NSLocalizedDescriptionKey: locString};
            NSError *newError = [NSError errorWithDomain:@"de.simonsserver.Moodle" code:1990 userInfo:userInfo];
            completionHandler(NO, newError, nil);
            return;
        }
    }
    
    NSArray<MOODLESearchItem *> *searchItemArray = [self.xmlParser searchResultsFromData:data];
    if (searchItemArray) {
        
        completionHandler(YES, nil, searchItemArray);
    }
    else {
     
        completionHandler(NO, nil, nil);
    }
}

- (void)loginWithUsername:(NSString *)username
                 password:(NSString *)password
          completionBlock:(void (^)(BOOL success, NSError * error))completionHandler {
    
    //Create and start task
    [[self.currentSession dataTaskWithRequest:[NSURLRequest moodle_loginRequestWithUsername:username andPassword:password]
                            completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                
                                // handle basic connectivity issues here
                                if (error) {
                                    completionHandler(NO, error);
                                    return;
                                }
                                
                                // handle HTTP errors here
                                if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                                    
                                    NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
                                    
                                    if (statusCode != 200) {
                                        NSString *locString = NSLocalizedString(@"Bei der Kommunikation mit dem Server, ist ein Fehler aufgetreten.", @"Error message if the server wont respond with 200 http response code.");
                                        NSDictionary *userInfo = @{NSLocalizedDescriptionKey: locString};
                                        NSError *newError = [NSError errorWithDomain:@"de.simonsserver.Moodle" code:1990 userInfo:userInfo];
                                        completionHandler(NO, newError);
                                        return;
                                    }
                                }
                                
                                //type_course depth_3 contains_branch
                                NSString *receivedDataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                if ([receivedDataString containsString:@"Ungültiges Login, bitte versuchen Sie es erneut."]) {
                                    
                                    NSString *locString = NSLocalizedString(@"Ungültiges Login, bitte versuchen Sie es erneut.", @"Error message if the login crdential where wrong.");
                                    NSDictionary *userInfo = @{NSLocalizedDescriptionKey: locString};
                                    
                                    NSError *newError = [NSError errorWithDomain:@"de.simonsserver.Moodle" code:1990 userInfo:userInfo];
                                    completionHandler(NO, newError);
                                    return;
                                    
                                }
                                else {
                                    
                                    self.sessionKey = [self.xmlParser sessionKeyFromData:data];
                                    NSArray *result = [self.xmlParser createCourseItemsFromData:data];
                                        
                                    // set data model
                                    if (result.count > 0) {
                                        
                                        self.courseArray = [self sortCourseItems:result];

                                        for (MOODLECourse *item in result) {
                                            
                                            item.dataModel = self;
                                        }
                                    }
                                    else {
                                        
                                        self.courseArray = [NSMutableArray arrayWithArray:result];
                                    }
                                    
                                    self.loginDate = [NSDate date];
                                    completionHandler(YES, nil);
                                }
                            }] resume];
}

- (void)loadItemContentForItem:(MOODLECourse *)item
               completionBlock:(void (^)(BOOL, NSError * _Nullable error))completionHandler {
    
    NSURLResponse * response = nil;
    NSError *requestError = nil;
    NSData *data = [self.currentSession moodle_sendSynchronousRequest:[NSURLRequest requestWithURL:item.url]
                                                    returningResponse:&response
                                                                error:&requestError];
    // handle basic connectivity issues here
    if (!data) {
        completionHandler(NO, (requestError) ? requestError : nil);
        return;
    }
    
    // handle HTTP errors here
    if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
        
        NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
        
        if (statusCode != 200) {
            
            NSString *locString = NSLocalizedString(@"Bei der Kommunikation mit dem Server, ist ein Fehler aufgetreten.", @"Error message if the server wont respond with 200 http response code.");
            NSDictionary *userInfo = @{NSLocalizedDescriptionKey: locString};
            NSError *newError = [NSError errorWithDomain:@"de.simonsserver.Moodle" code:1990 userInfo:userInfo];
            completionHandler(NO, newError);
            return;
        }
    }
    
    item.courseSections = [self.xmlParser createCourseSectionsFromData:data];
    
    // load content for items that dont have it already ...
    for (MOODLECourseSection *section in item.courseSections) {
        
        if (!section.hasContenLoaded || section.isIndependentSection) {
            
            NSURLResponse * response = nil;
            NSError *requestError = nil;
            NSData *data = [self.currentSession moodle_sendSynchronousRequest:[NSURLRequest requestWithURL:section.sectionURL]
                                                            returningResponse:&response
                                                                        error:&requestError];
            if (data) {
        
                BOOL success = [self.xmlParser createContentForCourseSections:section fromData:data];
                if (!success) {
                    NSLog(@"Could not load content for item: %@", section.sectionTitle);
                }
            }
        }
    }
    
    completionHandler(YES, nil);
}

- (void)logoutWithCompletionHandler:(void (^)(BOOL success, NSError * _Nullable error))completionHandler {
    
    if (self.sessionKey) {
        
        NSURLResponse * response = nil;
        NSError *requestError = nil;
        NSData *data = [self.currentSession moodle_sendSynchronousRequest:[NSURLRequest moodle_logoutRequestWithSessionKey:self.sessionKey]
                                                        returningResponse:&response
                                                                    error:&requestError];
        if (!data) {
            
            NSString *locString = NSLocalizedString(@"Beim Logout ist ein Fehler aufgetreten.", @"Error message if logout failed.");
            NSLog(@"Logout: %@", (requestError) ? requestError.localizedDescription : locString);
            [self resetData];
            completionHandler(NO, (requestError) ? requestError : nil);
            return;
        }
        
        // handle HTTP errors here
        if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
            
            NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
            
            if (statusCode != 200) {
                
                NSString *locString = NSLocalizedString(@"Beim Logout ist ein Fehler aufgetreten.", @"Error message if logout failed.");
                NSDictionary *userInfo = @{NSLocalizedDescriptionKey: locString};
                NSError *newError = [NSError errorWithDomain:@"de.simonsserver.Moodle" code:1990 userInfo:userInfo];
                [self resetData];
                completionHandler(NO, newError);
                return;
            }
        }
        
        [self resetData];
        completionHandler(YES, nil);
        return;
    }
    else {
     
        [self resetData];
        completionHandler(YES, nil);
    }
}

#pragma mark - Sort Methodes

- (NSMutableArray<MOODLECourse *> *)sortCourseItems:(NSArray<MOODLECourse *> *)items {
    
    NSMutableArray *itemArray = [NSMutableArray array];
    for (MOODLECourse *item in items) {
        
        item.isHidden = [self.hiddedCourseIdentifier containsObject:item.courseTitle];
        item.isFavourite = [self.favouriteIdentifier containsObject:item.courseTitle];
        
        if (!item.isHidden) [itemArray addObject:item];
        else { [self.hiddenCourses addObject:item]; }
    }
    
    for (MOODLECourse *item in itemArray) {
        
        NSArray *keys = [self.orderingWeightDictionaries allKeys];
        if ([keys containsObject:item.courseTitle]) {
            
            item.orderingWeight = ((NSNumber *)[self.orderingWeightDictionaries objectForKey:item.courseTitle]).integerValue;
        }
        else {
            
            item.orderingWeight = 1000;
        }
        
    }
    
    [itemArray sortUsingComparator:^NSComparisonResult(MOODLECourse *  _Nonnull obj1, MOODLECourse *  _Nonnull obj2) {
        
        if (obj1.orderingWeight > obj2.orderingWeight) {
        
            return (NSComparisonResult)NSOrderedDescending;
        }
        if (obj1.orderingWeight < obj2.orderingWeight) {
            
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
    
    NSMutableDictionary *newDict = [NSMutableDictionary dictionaryWithCapacity:itemArray.count];
    [itemArray enumerateObjectsUsingBlock:^(MOODLECourse *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        obj.orderingWeight = idx;
        [newDict addEntriesFromDictionary:@{obj.courseTitle: @(idx)}];
    }];
    self.orderingWeightDictionaries = newDict;
    [self.defaults setObject:newDict forKey:UserDefaultsOrderingWeightsArrayKey];
    
    return itemArray;
}

#pragma mark - 

- (void)updateCourseItemsOrderingWeight {
    
    NSMutableArray *itemArray = self.courseArray;
    NSMutableDictionary *newDict = [NSMutableDictionary dictionaryWithCapacity:itemArray.count];
    [itemArray enumerateObjectsUsingBlock:^(MOODLECourse *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        obj.orderingWeight = idx;
        [newDict addEntriesFromDictionary:@{obj.courseTitle: @(idx)}];
    }];
    self.orderingWeightDictionaries = newDict;
    [self.defaults setObject:newDict forKey:UserDefaultsOrderingWeightsArrayKey];
}

- (void)setItem:(MOODLECourse *)item isHidden:(BOOL)hidden {
    
    // hide
    if (hidden) {
        
        [self.hiddedCourseIdentifier addObject:item.courseTitle];
        [self.defaults setObject:self.hiddedCourseIdentifier forKey:UserDefaultsDeletedArrayKey];
        
        [self.courseArray removeObject:item];
        [self.hiddenCourses addObject:item];
    }
    // unhide
    else {
        
        [self.hiddedCourseIdentifier removeObject:item.courseTitle];
        [self.defaults setObject:self.hiddedCourseIdentifier forKey:UserDefaultsDeletedArrayKey];
        
        [self.courseArray addObject:item];
        [self.hiddenCourses removeObject:item];
    }
    
    [self updateCourseItemsOrderingWeight];
}

- (void)setItem:(MOODLECourse *)item isFavorit:(BOOL)favorit {
    
    if (favorit) {
        
        [self.favouriteIdentifier addObject:item.courseTitle];
        [self.defaults setObject:self.favouriteIdentifier forKey:UserDefaultsFavouritesArrayKey];
    }
    else {
        [self.favouriteIdentifier removeObject:item.courseTitle];
        [self.defaults setObject:self.favouriteIdentifier forKey:UserDefaultsFavouritesArrayKey];
    }
}

#pragma mark - User Credential Methodes

- (void)saveUserCredentials:(NSString *)username andPassword:(NSString *)password {

    [self.keyChainWrapper mySetObject:username forKey:(NSString *)kSecAttrAccount];
    [self.keyChainWrapper writeToKeychain];
    [self.keyChainWrapper mySetObject:password forKey:(NSString *)kSecValueData];
    [self.keyChainWrapper writeToKeychain];
    
    self.hasUserCredentials = YES;
}

- (void)deleteUserCredentials {
    
    [self.keyChainWrapper mySetObject:@"-" forKey:(NSString *)kSecAttrAccount];
    [self.keyChainWrapper writeToKeychain];
    [self.keyChainWrapper mySetObject:@"-" forKey:(NSString *)kSecValueData];
    [self.keyChainWrapper writeToKeychain];
    
    self.hasUserCredentials = NO;
}

#pragma mark - Custom Setter

- (void)setHasUserCredentials:(BOOL)hasUserCredentials {
    
    if (_hasUserCredentials != hasUserCredentials) {
        
        [self.defaults setBool:hasUserCredentials
                        forKey:UserDefaultsHasCredentialsKey];
        _hasUserCredentials = hasUserCredentials;
    }
}

- (void)setShouldRememberCredentials:(BOOL)shouldRememberCredentials {
    
    if (_shouldRememberCredentials != shouldRememberCredentials) {
        
        [self.defaults setBool:shouldRememberCredentials
                        forKey:UserDefaultsShouldRememberCredentialsKey];
        _shouldRememberCredentials = shouldRememberCredentials;
    }
}

- (void)setShouldAutoLogin:(BOOL)shouldAutoLogin {
    
    if (_shouldAutoLogin != shouldAutoLogin) {
        
        [self.defaults setBool:shouldAutoLogin
                        forKey:UserDefaultsShouldAutoLoginKey];
        _shouldAutoLogin = shouldAutoLogin;
    }
}

#pragma mark - Lazy/Getter

- (NSString *)userName {
    
    if (!_userName) {
     
        _userName = [self.keyChainWrapper myObjectForKey:(NSString *)kSecAttrAccount];
    }
    return _userName;
}

- (NSString *)userPassword {
    
    if (!_userPassword) {
        
        _userPassword = [self.keyChainWrapper myObjectForKey:(NSString *)kSecValueData];
    }
    return _userPassword;
}

- (KeychainWrapper *)keyChainWrapper {
    
    if (!_keyChainWrapper) {
     
        _keyChainWrapper = [[KeychainWrapper alloc] init];
    }
    return _keyChainWrapper;
}

- (NSUserDefaults *)defaults {
    
    if (!_defaults) {
        
        _defaults = [NSUserDefaults standardUserDefaults];
    }
    return _defaults;
}

- (NSMutableArray<NSString *> *)favouriteIdentifier {
    
    if (!_favouriteIdentifier) {
        
        NSArray *array = [self.defaults objectForKey:UserDefaultsFavouritesArrayKey];
        if (!array) {
            array = [NSMutableArray array];
        }
        _favouriteIdentifier = [NSMutableArray arrayWithArray:[[NSSet setWithArray:array] allObjects]];
    }
    return _favouriteIdentifier;
}

- (NSMutableArray<NSString *> *)hiddedCourseIdentifier {
    
    if (!_hiddedCourseIdentifier) {
        
        NSArray *array = [self.defaults objectForKey:UserDefaultsDeletedArrayKey];
        if (!array) {
            array =  [NSMutableArray array];
        }
        _hiddedCourseIdentifier = [NSMutableArray arrayWithArray:[[NSSet setWithArray:array] allObjects]];
    }
    return _hiddedCourseIdentifier;
}

- (NSMutableDictionary *)orderingWeightDictionaries {
    
    if (!_orderingWeightDictionaries) {
        
        NSDictionary *dict = [self.defaults objectForKey:UserDefaultsOrderingWeightsArrayKey];
        if (!dict) {
            dict = [NSMutableDictionary dictionary];
        }
        _orderingWeightDictionaries = [NSMutableDictionary dictionaryWithDictionary:dict];
    }
    return _orderingWeightDictionaries;
}

#pragma mark -
@end

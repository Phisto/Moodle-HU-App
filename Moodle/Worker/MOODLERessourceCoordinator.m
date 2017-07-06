/*
 *
 *  MOODLERessourceCoordinator.m
 *  Moodle
 *
 *  Copyright © 2017 Simon Gaus. All rights reserved.
 *
 */

#import "MOODLERessourceCoordinator.h"

/* Categories */
#import "NSURLSession+SynchronuosTask.h"

/* Entities */
#import "MOODLECourseSectionItem.h"

///-----------------------
/// @name CONSTANTS
///-----------------------



static NSString * const UserDefaultsCachedFilesArrayKey = @"UserDefaultsCachedFilesArrayKey";



///-----------------------
/// @name CATEGORIES
///-----------------------



@interface MOODLERessourceCoordinator (/* Private */)

@property (nonatomic, strong) NSURLSession *currentSession;
@property (nonatomic, strong) NSUserDefaults *defaults;
@property (nonatomic, strong) NSFileManager *fileManager;

@property (nonatomic, strong) NSMutableArray<NSString *> *cachedFilesArray;

@end



///-----------------------
/// @name IMPLEMENTATION
///-----------------------



@implementation MOODLERessourceCoordinator
#pragma mark - Object Life Cycle


- (instancetype)initWithSession:(NSURLSession *)session {
    
    self = [super init];
    if (self) {
        
        _currentSession = session;
    }
    return self;
}


#pragma mark - Ressource Methodes


- (nullable NSURL *)localRessourceURLForItem:(MOODLECourseSectionItem *)item {
    
    NSURL *url = nil;
    BOOL exists = NO;
    for (NSString *title in self.cachedFilesArray) {
        
        if ([title isEqualToString:item.resourceTitle]) {
            
            NSString *extension = @"pdf";
            if (item.documentType == MoodleDocumentTypePPT) {
                
                extension = @"pptx";
            }
            else if (item.documentType == MoodleDocumentTypeWordDocument) {
                
                extension = @"docx";
            }
            
            url = [self localFileURLFromTitle:item.resourceTitle withPathExtension:extension];
            
            exists = [self.fileManager fileExistsAtPath:url.path];
            if (!exists) { url = nil; }
            break;
        }
    }
    if (!exists) {
        [self.cachedFilesArray removeObject:item.resourceTitle];
        [self saveCachedFilesArray];
    }
    
    return url;
}


///!!!: Add proper error handling.
- (void)saveRemoteRessource:(MOODLECourseSectionItem *)item
          completionHandler:(void (^)(BOOL success, NSError * _Nullable error, NSURL * _Nullable localRessourceURL))completionHandler {
    
    NSURLResponse * response = nil;
    NSError *requestError = nil;
    NSData *data = [self.currentSession moodle_sendSynchronousRequest:[NSURLRequest requestWithURL:item.resourceURL]
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

    NSString *extension = @"pdf";
    if (item.documentType == MoodleDocumentTypePPT) {
        
        extension = @"pptx";
    }
    else if (item.documentType == MoodleDocumentTypeWordDocument) {
        
        extension = @"docx";
    }
    
    NSURL *localFileURL = [self localFileURLFromTitle:item.resourceTitle withPathExtension:extension];
    
    BOOL success = [data writeToURL:localFileURL atomically:YES];
    if (success) {

        [self.cachedFilesArray addObject:item.resourceTitle];
        [self saveCachedFilesArray];
        
        completionHandler(YES, nil, localFileURL);
    }
    else {
        
        NSString *locString = NSLocalizedString(@"Die Datei konnte nicht auf dem Gerät gespeichert werden.", @"Error message if the file could not be saved to disc.");
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey: locString};
        NSError *newError = [NSError errorWithDomain:@"de.simonsserver.Moodle" code:1914 userInfo:userInfo];
        NSLog(@"%@", newError.localizedDescription);
        completionHandler(NO, newError, nil);
    }
}


- (BOOL)deleteDocumentWithURL:(NSURL *)docURL {
    
    if ([self.fileManager fileExistsAtPath:docURL.path]) {
    
        BOOL deleted = [self.fileManager removeItemAtURL:docURL error:nil];
        [self.cachedFilesArray removeObject:[docURL.lastPathComponent stringByDeletingPathExtension]];
        [self saveCachedFilesArray];
        
        return deleted;
    }
    return NO;
}


#pragma mark - Directory Methodes


- (NSURL *)localFileURLFromTitle:(NSString *)title withPathExtension:(NSString *)extension {
    
    NSString *cachePath = [self directoryForDocumentsCache];
    NSString *filePath = [cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", title, extension]];
    return [NSURL fileURLWithPath:filePath];
}


- (NSString *)directoryForDocumentsCache {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [paths objectAtIndex:0];
    BOOL isDir = NO;
    NSError *error;
    //You must check if this directory exist every time
    if (! [self.fileManager fileExistsAtPath:cachePath isDirectory:&isDir] && isDir == NO) {
        [self.fileManager createDirectoryAtPath:cachePath withIntermediateDirectories:NO attributes:nil error:&error];
    }
    
    return cachePath;
}


- (NSInteger)sizeOfCachedDocuments {
    
    unsigned long long fileSize = 0;
    
    NSArray *urls = [self allRessourceURLS];
    for (NSURL *url in urls) {
        fileSize = fileSize + [[self.fileManager attributesOfItemAtPath:url.path error:nil] fileSize];
    }
    
    return (NSInteger)(fileSize/1000/1000); // we want megabyte
}


- (NSArray<NSURL *> *)allRessourceURLS {
    
    NSString *folderPath =  [self directoryForDocumentsCache];
    
    NSArray *directoryContent = [self.fileManager contentsOfDirectoryAtPath:folderPath error:NULL];
    if (!directoryContent) {
        
        return @[];
    }
    
    NSMutableArray *muteArray = [NSMutableArray array];
    for (NSString *path in directoryContent) {
        
        NSURL *fileURL = [[NSURL fileURLWithPath:folderPath] URLByAppendingPathComponent:path];
        NSString *extension = [fileURL pathExtension];
        if ([extension isEqualToString:@"pdf"] || [extension isEqualToString:@"pptx"] || [extension isEqualToString:@"docx"]) {
            [muteArray addObject:fileURL];
        }
    }
    
    return [muteArray copy];
}


#pragma mark - User Defaults Methodes


- (void)saveCachedFilesArray {
    
    [self.defaults setObject:self.cachedFilesArray forKey:UserDefaultsCachedFilesArrayKey];
}


#pragma mark - Lazy/Getter


- (NSMutableArray<NSString *> *)cachedFilesArray {
    
    if (!_cachedFilesArray) {
        
        // NSUserDefaults will always return an immutable version of the object you pass in.
        NSArray *array = [self.defaults objectForKey:UserDefaultsCachedFilesArrayKey];
        if (!array) {
            
            array = [NSArray array];
        }
        
        NSMutableArray *muteArray = [NSMutableArray arrayWithArray:array];
        _cachedFilesArray = muteArray;
    }
    return _cachedFilesArray;
}


- (NSUserDefaults *)defaults {
    
    if (!_defaults) {
        _defaults = [NSUserDefaults standardUserDefaults];
    }
    return _defaults;
}


- (NSFileManager *)fileManager {
    
    if (!_fileManager) {
        _fileManager = [NSFileManager defaultManager];
    }
    return _fileManager;
}


#pragma mark -
@end

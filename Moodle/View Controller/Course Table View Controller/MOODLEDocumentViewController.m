/*
 *  MOODLEDocumentViewController.m
 *  Moodle
 *
 *  Created by Simon Gaus on 03.06.17.
 *  Copyright © 2017 Simon Gaus. All rights reserved.
 *
 */

@import AVFoundation;

#import "MOODLEDocumentViewController.h"

/* Data Model */
#import "MOODLEDataModel.h"
#import "MOODLECourseSectionItem.h"

/* Custom View */
#import "MOODLEActivityView.h"

///-----------------------
/// @name CATEGORIES
///-----------------------



@interface MOODLEDocumentViewController (/* Private */)

// UI
@property (nonatomic, strong) IBOutlet UIWebView *webView;
@property (nonatomic, strong) MOODLEActivityView *loadingView;

// Data Model
@property (nonatomic, strong) MOODLEDataModel *dataModel;

// State
@property (nonatomic, readwrite) BOOL isMoodleItem;
@property (nonatomic, readwrite) BOOL isURL;

@end



///-----------------------
/// @name IMPLEMENTATION
///-----------------------



@implementation MOODLEDocumentViewController
#pragma mark - View Controller Methodes


- (void)viewWillAppear:(BOOL)animated {
    
    // call super
    [super viewWillAppear:animated];
    
    // hide nav bar when scrolling web content ...
    self.navigationController.hidesBarsOnSwipe = YES;
    
    // add activity indicator
    [self.view addSubview:self.loadingView];
    
    // set webview delegate
    self.webView.delegate = self;
    self.webView.hidden = YES;
    
    // prepare for audio
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    // load item
    [self loadItem];
}


- (void)loadItem {
    
    NSString *itemClassString = NSStringFromClass([self.item class]);
    NSString *courseSectionClassString = NSStringFromClass([MOODLECourseSectionItem class]);
    NSString *urlClassString = NSStringFromClass([NSURL class]);
    
    if ([itemClassString isEqualToString:courseSectionClassString]) {
        
        MOODLECourseSectionItem *moodelItem = (MOODLECourseSectionItem *)self.item;
        
        BOOL isDocument = (moodelItem.itemType == MoodleItemTypeDocument);
        BOOL isPDF = (moodelItem.documentType == MoodleDocumentTypePDF);
        BOOL isPPT = (moodelItem.documentType == MoodleDocumentTypePPT);
        BOOL isWORD = (moodelItem.documentType == MoodleDocumentTypeWordDocument);
        BOOL mayBeLocal = (isPDF || isPPT || isWORD);
        
        // pdf & ppt files can be cached ...
        if (isDocument && mayBeLocal) {
            
            NSURL *localURL = [self.dataModel localRessourceURLForItem:moodelItem];
            // the file is cached
            if (localURL) {

                // load resource
                [self.webView loadRequest:[NSURLRequest requestWithURL:localURL]];
            }
            // there is no space to cache
            else if (self.dataModel.sizeOfCachedDocuments >= self.dataModel.documentCacheSize) {
                
                // load resource
                [self.webView loadRequest:[NSURLRequest requestWithURL:moodelItem.resourceURL]];
            }
            // file isn't cached
            else {
                
                dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul);
                dispatch_async(queue, ^{
                    [self.dataModel saveRemoteRessource:moodelItem
                                      completionHandler:^(BOOL success, NSError * _Nullable error, NSURL * _Nullable localRessourceURL) {
                                          
                                          // load resource
                                          [self.webView loadRequest:[NSURLRequest requestWithURL:(success) ? localRessourceURL : moodelItem.resourceURL]];
                                      }];
                });
            }
        }
        else {
            
            // load resource
            [self.webView loadRequest:[NSURLRequest requestWithURL:moodelItem.resourceURL]];
        }
    }
    else if ([itemClassString isEqualToString:urlClassString]) {

        // load resource
        [self.webView loadRequest:[NSURLRequest requestWithURL:(NSURL *)self.item]];
    }
    else {
        
        NSLog(@"%s MOODLEDocumentViewController failed to open item '%@'.", __FUNCTION__, self.item);
        
        NSString *locString = NSLocalizedString(@"Das Objekt kann nicht dargestellt werden.", @"Error message displaying when item is of unknown class.");
        NSDictionary *errorDict = @{ NSLocalizedDescriptionKey: locString };
        NSError *newError = [NSError errorWithDomain:@"de.simonsserver.Moodle"
                                                code:77
                                            userInfo:errorDict];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self presentError:newError];
        });
    }
}


- (void)viewWillDisappear:(BOOL)animated {
    
    // call super
    [super viewWillDisappear:animated];
    
    // bring back my nav bar!
    self.navigationController.hidesBarsOnSwipe = NO;
    
    // remove self as delegate
    self.webView.delegate = nil;
    self.webView.hidden = YES;
    
    // stop
    [self.webView stopLoading];
    
    if (self.isMovingFromParentViewController) {
        [self.webView loadHTMLString:@"" baseURL:nil];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [self.webView loadHTMLString:@"" baseURL:nil];
    
    // inform user
    NSString *locString = NSLocalizedString(@"Achtung", @"memmory issue alert presenting title");
    NSString *locMessage = NSLocalizedString(@"Die Datei ist zu groß.", @"memmory issue alert presenting message");
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:locString
                                                                             message:locMessage
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    NSString *cancelActionTitle = NSLocalizedString(@"Weiter", @"alert view retry button title");
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:cancelActionTitle
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             
                                                             // remove the activity view
                                                             [self.loadingView removeFromSuperview];
                                                             self.loadingView = nil;
                                                         }];
    [alertController addAction:cancleAction];
    
    
    NSString *retryActionTitle = NSLocalizedString(@"Nochmal versuchen", @"alert view retry button title");
    UIAlertAction *retryAction = [UIAlertAction actionWithTitle:retryActionTitle
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * _Nonnull action) {
                                                            // retry content loading...
                                                            
                                                            // show activity indicator..
                                                            if (![self.view.subviews containsObject:self.loadingView]) {
                                                                [self.view addSubview:self.loadingView];
                                                            }
                                                            
                                                            // load resource
                                                            [self loadItem];
                                                        }];
    
    [alertController addAction:retryAction];
    
    [self presentViewController:alertController
                       animated:YES
                     completion:nil];
    
}


- (BOOL)shouldAutorotate {
    
    return YES;
}


#pragma mark - Web View Delegate Methodes


- (void)webViewDidStartLoad:(UIWebView *)webView {
    
    if (![self.view.subviews containsObject:self.loadingView]) {
        [self.view addSubview:self.loadingView];
    }
}


- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    [self.loadingView removeFromSuperview];
    self.loadingView = nil;
    self.webView.hidden = NO;
}


- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self presentError:error];
    });
}


#pragma mark - Error Presenting Methodes


- (void)presentError:(NSError *)error {
    
    [self.loadingView removeFromSuperview];
    
    NSString *locString = NSLocalizedString(@"Fehler", @"Error alert presenting title");
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:locString
                                                                             message:error.localizedDescription
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    NSString *cancelActionTitle = NSLocalizedString(@"Weiter", @"alert view retry button title");
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:cancelActionTitle
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             
                                                             // remove the activity view
                                                             [self.loadingView removeFromSuperview];
                                                             self.loadingView = nil;
                                                         }];
    [alertController addAction:cancleAction];
    
    NSString *retryActionTitle = NSLocalizedString(@"Nochmal versuchen", @"alert view retry button title");
    UIAlertAction *retryAction = [UIAlertAction actionWithTitle:retryActionTitle
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * _Nonnull action) {
                                                            // retry content loading...
                                                            
                                                            // show activity indicator..
                                                            if (![self.view.subviews containsObject:self.loadingView]) {
                                                                [self.view addSubview:self.loadingView];
                                                            }
                                                            
                                                            // load resource
                                                            [self loadItem];
                                                        }];
    
    [alertController addAction:retryAction];
    
    [self presentViewController:alertController
                       animated:YES
                     completion:nil];

}


#pragma mark - Lazy


- (MOODLEActivityView *)loadingView {
    
    if (!_loadingView) {

        MOODLEActivityView *view = [MOODLEActivityView activityView];
        view.center = CGPointMake(self.view.center.x, self.view.center.y-self.navigationController.navigationBar.frame.size.height);
        _loadingView = view;
    }
    return _loadingView;
}


- (MOODLEDataModel *)dataModel {
    
    if (!_dataModel) {
        _dataModel = [MOODLEDataModel sharedDataModel];
    }
    return _dataModel;
}


#pragma mark -
@end

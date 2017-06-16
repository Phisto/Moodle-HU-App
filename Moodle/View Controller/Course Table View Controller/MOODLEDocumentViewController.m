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
    
    // set webview delegate
    self.webView.delegate = self;
    
    // prepare for audio
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    
    BOOL isDocument = (self.item.itemType == MoodleItemTypeDocument);
    BOOL isPDF = (self.item.documentType == MoodleDocumentTypePDF);
    BOOL isPPT = (self.item.documentType == MoodleDocumentTypePPT);
    BOOL isSupportedDocument = (isPDF || isPPT);
    
    // pdf files getting cached ...
    if (isDocument && isSupportedDocument) {

        NSURL *localURL = [self.dataModel localRessourceURLForItem:self.item];
        // the file is cached
        if (localURL) {
            // load resource
            [self.webView loadRequest:[NSURLRequest requestWithURL:localURL]];
        }
        // there is no space to cache
        else if (self.dataModel.sizeOfCachedDocuments >= self.dataModel.documentCacheSize) {
            
            // load resource
            [self.webView loadRequest:[NSURLRequest requestWithURL:self.item.resourceURL]];
        }
        // file isn't cached
        else {
            
            // show activity indicator view
            [self.view addSubview:self.loadingView];
            
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul);
            dispatch_async(queue, ^{
                [self.dataModel saveRemoteRessource:self.item
                                  completionHandler:^(BOOL success, NSError * _Nullable error, NSURL * _Nullable localRessourceURL) {

                                      // load resource
                                      [self.webView loadRequest:[NSURLRequest requestWithURL:(success) ? localRessourceURL : self.item.resourceURL]];
                                  }];
            });
        }
    }
    else {
        
        // load resource
        [self.webView loadRequest:[NSURLRequest requestWithURL:self.item.resourceURL]];
    }
}


- (void)viewWillDisappear:(BOOL)animated {
    
    // call super
    [super viewWillDisappear:animated];
    
    // bring back my nav bar!
    self.navigationController.hidesBarsOnSwipe = NO;
    
    // remove self as delegate
    self.webView.delegate = nil;
    
    // stop
    [self.webView stopLoading];
    
    if (self.isMovingFromParentViewController) {
        [self.webView loadHTMLString:@"" baseURL:nil];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [self.webView reload];
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
                                                             
                                                             // free the activity view
                                                             self.loadingView = nil;
                                                         }];
    [alertController addAction:cancleAction];
    
    NSString *retryActionTitle = NSLocalizedString(@"Nochmal versuchen", @"alert view retry button title");
    UIAlertAction *retryAction = [UIAlertAction actionWithTitle:retryActionTitle
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * _Nonnull action) {
                                                            // retry content loading...
                                                            
                                                            // show activity indicator..
                                                            [self.view addSubview:self.loadingView];
                                                            
                                                            // load resource
                                                            [self.webView loadRequest:[NSURLRequest requestWithURL:self.item.resourceURL]];
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

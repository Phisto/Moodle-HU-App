/*
 *  MOODLEURLRessourceViewController.m
 *  Moodle
 *
 *  Created by Simon Gaus on 03.06.17.
 *  Copyright © 2017 Simon Gaus. All rights reserved.
 *
 */

@import AVFoundation;

#import "MOODLEURLRessourceViewController.h"

///-----------------------
/// @name CATEGORIES
///-----------------------



@interface MOODLEURLRessourceViewController (/* Private */)

// UI
@property (nonatomic, strong) IBOutlet UIWebView *webView;

@end



///-----------------------
/// @name IMPLEMENTATION
///-----------------------



@implementation MOODLEURLRessourceViewController
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
    
    // load resource
    [self.webView loadRequest:[NSURLRequest requestWithURL:self.localRessourceURL]];
}


- (void)viewWillDisappear:(BOOL)animated {
    
    // call super
    [super viewWillDisappear:animated];
    
    // remove self as delegate
    self.webView.delegate = nil;
    
    // stop
    [self.webView stopLoading];
    
    if (self.isMovingFromParentViewController) {
        
        [self.webView loadHTMLString:@"" baseURL:nil];
    }
}


- (BOOL)shouldAutorotate {
    
    return YES;
}


#pragma mark -
@end

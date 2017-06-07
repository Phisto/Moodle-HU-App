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

/* Custom View */
#import "MOODLEActivityView.h"



///-----------------------
/// @name CATEGORIES
///-----------------------



@interface MOODLEDocumentViewController (/* Private */)

// UI
@property (nonatomic, strong) IBOutlet UIWebView *webView;
@property (nonatomic, strong) MOODLEActivityView *loadingView;

@end



///-----------------------
/// @name IMPLEMENTATION
///-----------------------



@implementation MOODLEDocumentViewController
#pragma mark - View Controller Methodes


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // set webview delegate
    self.webView.delegate = self;
}


- (void)viewWillAppear:(BOOL)animated {
    
    // call super
    [super viewWillAppear:animated];

    // hide bottom bar
    [UIView animateWithDuration:.4 animations:^{
       
        //self.tabBarController.tabBar.hidden = YES;
        self.tabBarController.tabBar.alpha = 0.0;
    }];
    
    // prepare audio
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    // load resource
    [self.webView loadRequest:[NSURLRequest requestWithURL:self.resourceURL]];
}


- (void)viewWillDisappear:(BOOL)animated {
    
    // call super
    [super viewWillDisappear:animated];
    
    // show bottom bar
    [UIView animateWithDuration:0.4f
                     animations:^{
        
        //self.tabBarController.tabBar.hidden = NO;
        self.tabBarController.tabBar.alpha = 1.0;
    }];
    
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


#pragma mark - Web View Delegate Methodes


- (void)webViewDidStartLoad:(UIWebView *)webView {
    
    [self.view addSubview:self.loadingView];
}


- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    [self.loadingView removeFromSuperview];
    self.loadingView = nil;
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


#pragma mark -
@end

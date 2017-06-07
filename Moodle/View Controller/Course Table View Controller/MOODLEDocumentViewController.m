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
#import "HUProgressIndicator.h"

@interface MOODLEDocumentViewController ()<UIWebViewDelegate>

// UI
@property (nonatomic, strong) IBOutlet UIWebView *webView;
@property (nonatomic, strong) UIView *loadingView;

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
    [UIView animateWithDuration:.4 animations:^{
        
        //self.tabBarController.tabBar.hidden = NO;
        self.tabBarController.tabBar.alpha = 1.0;
    }];
    
    // stop
    [self.webView stopLoading];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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


- (UIView *)loadingView {
    
    if (!_loadingView) {
        
        UIView *loading = [[UIView alloc] initWithFrame:CGRectMake(100, 200, 120, 120)];
        
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:loading.bounds];
        imgView.image = [UIImage imageNamed:@"blurry_bg"];
        [loading addSubview:imgView];
        
        
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
        UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        [blurEffectView setFrame:loading.bounds];
        
        
        [loading addSubview:blurEffectView];
        
        loading.clipsToBounds = YES;
        loading.layer.cornerRadius = 15;
        //loading.opaque = NO;
        //loading.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8f];
        
        
        HUProgressIndicator *spinning = [[HUProgressIndicator alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
        spinning.backgroundColor = [UIColor clearColor];
        spinning.color = [UIColor blackColor];
        [spinning setCenter:CGPointMake(loading.frame.size.width/2.0f, loading.frame.size.height/2)];
        [loading addSubview:spinning];
        [spinning startAnimating];
        
        [loading setCenter:CGPointMake(self.view.frame.size.width/2.0f, self.view.frame.size.height/2.0f)];
        
        _loadingView = loading;
    }
    return _loadingView;
}


#pragma mark -
@end

/*
 *  MOODLEDocumentViewController.m
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

@import AVFoundation;

#import "MOODLEDocumentViewController.h"



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
        
        loading.layer.cornerRadius = 15;
        loading.opaque = NO;
        loading.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.7f];
        
        UIActivityIndicatorView *spinning = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        spinning.frame = CGRectMake(42, 54, 37, 37);
        [spinning startAnimating];
        [spinning setCenter:CGPointMake(loading.frame.size.width/2.0f, loading.frame.size.height/2.0f)];
        [loading addSubview:spinning];
        
        //loading.frame = CGRectMake(100, 200, 120, 120);
        [loading setCenter:CGPointMake(self.view.frame.size.width/2.0f, self.view.frame.size.height/2.0f)];
        
        _loadingView = loading;
    }
    return _loadingView;
}


#pragma mark -
@end

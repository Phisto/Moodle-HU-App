/*
 *  MOODLETabBarController.m
 *  Moodle
 *
 *  Created by Simon Gaus on 03.06.17.
 *  Copyright © 2017 Simon Gaus. All rights reserved.
 *
 */

#import "MOODLETabBarController.h"

/* View Controller */
#import "MOODLECourseViewController.h"
#import "MOODLECourseDetailViewController.h"
#import "MOODLESearchItemDetailViewController.h"
#import "MOODLESettingsViewController.h"

///-----------------------
/// @name IMPLEMENTATION
///-----------------------



@implementation MOODLETabBarController
#pragma mark - View Controller Methodes


- (void)viewDidLoad {
    
    // call super
    [super viewDidLoad];

    // Navigation bar appearance
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];

    // Tab bar appearance
    // center icons  & hide title
    for(UITabBarItem * tabBarItem in self.tabBar.items){
        tabBarItem.accessibilityLabel = tabBarItem.title;
        tabBarItem.title = @"";
        tabBarItem.imageInsets = UIEdgeInsetsMake(6.0f, 0.0f, -6.0f, 0.0f);
    }
    
    // set status bar appearance
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}


- (BOOL)shouldAutorotate {
    
    return NO;
}


#pragma mark -
@end

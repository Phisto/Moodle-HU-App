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
#import "MOODLEDocumentsTableViewController.h"

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
        NSLog(@"tabBarItem.title: %@", tabBarItem.title);
        tabBarItem.accessibilityLabel = tabBarItem.title;
        tabBarItem.title = @"";
        tabBarItem.imageInsets = UIEdgeInsetsMake(6.0f, 0.0f, -6.0f, 0.0f);
    }
    
    // set delegate
    self.delegate = self;
    
    // set status bar appearance
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}


- (BOOL)shouldAutorotate {
    
    return [self currentViewController].shouldAutorotate;
}


- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return [self.currentViewController supportedInterfaceOrientations];
}


#pragma mark - Tab Bar Controller Delegate Methodes


- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {

    if ([[self currentViewController] isKindOfClass:[UITableViewController class]]) {
        
        [[(UITableViewController *)[self currentViewController] tableView] reloadData];
    }
}


#pragma mark - Helper Methodes


- (UIViewController*)currentViewController {
    
    UIViewController *controller = self.selectedViewController;
    
    if([controller isKindOfClass:[UINavigationController class]]) {
        controller = [(UINavigationController *)controller topViewController];
    }
    return controller;
}


#pragma mark -
@end

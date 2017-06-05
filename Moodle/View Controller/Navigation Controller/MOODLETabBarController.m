/*
 *  MOODLETabBarController.m
 *  Moodle
 *
 *  Created by Simon Gaus on 03.06.17.
 *  Copyright © 2017 Simon Gaus. All rights reserved.
 *
 */

#import "MOODLETabBarController.h"

#import "MOODLECourseViewController.h"
#import "MOODLECourseDetailViewController.h"
#import "MOODLESearchItemDetailViewController.h"
#import "MOODLESettingsViewController.h"

@interface MOODLETabBarController ()<UISplitViewControllerDelegate>

@end



///-----------------------
/// @name IMPLEMENTATION
///-----------------------



@implementation MOODLETabBarController
#pragma mark - View Controller Methodes


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // UISplitViewController delegate
    // Do any additional setup after loading the view.
    ((UISplitViewController *)[self viewControllers][0]).delegate = self;
    ((UISplitViewController *)[self viewControllers][1]).delegate = self;

    // Navigation bar appearance
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    

    // Tab bar appearance
    // center icons  & hide title
    for(UITabBarItem * tabBarItem in self.tabBar.items){
        tabBarItem.title = @"";
        tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    }
    
    // set status bar appearance
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}


#pragma mark - Split View Controller Delegate Methodes


- (BOOL)splitViewController:(UISplitViewController *)splitViewController collapseSecondaryViewController:(UIViewController *)secondaryViewController
                                                                               ontoPrimaryViewController:(UIViewController *)primaryViewController {
    
    BOOL val1 = [secondaryViewController isKindOfClass:[UINavigationController class]];
    
    BOOL val2_1 = [[(UINavigationController *)secondaryViewController topViewController] isKindOfClass:[MOODLECourseDetailViewController class]];
    BOOL val2_2 = [[(UINavigationController *)secondaryViewController topViewController] isKindOfClass:[MOODLESearchItemDetailViewController class]];

    BOOL val3_1 = ([(MOODLECourseDetailViewController *)[(UINavigationController *)secondaryViewController topViewController] item] == nil);
    BOOL val3_2 = ([(MOODLESearchItemDetailViewController *)[(UINavigationController *)secondaryViewController topViewController] item] == nil);
    
    
    if (val1 && ((val2_1 && val3_1) || (val2_2 && val3_2))) {
        // Return YES to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
        return YES;
    } else {
        return NO;
    }
}


#pragma mark -
@end

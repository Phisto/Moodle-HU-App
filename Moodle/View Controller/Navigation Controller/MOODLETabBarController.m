/*
 *  MOODLETabBarController.m
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

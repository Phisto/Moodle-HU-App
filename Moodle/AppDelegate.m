/*
 *  AppDelegate.m
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



///--------------------
/// @name IMPORTS
///--------------------



/* Header */
#import "AppDelegate.h"

/* Data Model */
#import "MOODLEDataModel.h"

/* Controller */
#import "MOODLELoginViewController.h"
#import "MOODLETabBarController.h"
#import "MOODLEProgressViewController.h"



///-----------------------
/// @name CONSTANTS
///-----------------------



static NSUInteger const kLoginTimeoutTrashold = 60*30*2;



///-----------------------
/// @name CATEGORIES
///-----------------------


@interface AppDelegate (/* Private */)

@property (nonatomic, strong) NSUserDefaults *defaults;
@property (nonatomic, readonly) MOODLEDataModel *dataModel;

@end



///-----------------------
/// @name IMPLEMENTATION
///-----------------------



@implementation AppDelegate
#pragma mark - Delegate Methodes


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    // register to notification so we transition to the course view controler after login (embeded in tab bar controller, hence the name ...)
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(transitionToCourseViewController)
                                                 name:MOODLEDidLoginNotification
                                               object:nil];
    
    return YES;
}


- (void)applicationDidEnterBackground:(UIApplication *)application {

    // save user defaults
    [self.defaults synchronize];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {

    if ([self dataModel].loginDate && [[NSDate date] timeIntervalSinceDate:[self dataModel].loginDate] > kLoginTimeoutTrashold) {
        
        [self transitionToProgressViewController];
        
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul);
        dispatch_async(queue, ^{
            
            sleep(5);
            
            [self.dataModel logoutWithCompletionHandler:^(BOOL success, NSError * _Nullable error) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self transitionToLoginViewController];
                });
            }];
        });
    }
}


- (void)applicationWillTerminate:(UIApplication *)application {

    // save user defaults
    [self.defaults synchronize];
    // remove observer (not necessary in app delegate but for style/convention)
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MOODLEDidLoginNotification
                                                  object:nil];
}


#pragma mark -  View Controller Transition Methodes


- (void)transitionToCourseViewController {
    
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    MOODLETabBarController *controller = [mainStoryBoard instantiateViewControllerWithIdentifier:MOODLETabBarControllerIdentifier];
    [self changeRootViewController:controller];
    
}


- (void)transitionToLoginViewController {
    
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    MOODLELoginViewController *controller = [mainStoryBoard instantiateInitialViewController];
    [self changeRootViewController:controller];
}


- (void)transitionToProgressViewController {
    
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    MOODLEProgressViewController *controller = [mainStoryBoard instantiateViewControllerWithIdentifier:MOODLEProgressViewControllerIdentifier];
    controller.shouldShowReloginLabel = YES;
    [self changeRootViewController:controller];
}


- (void)changeRootViewController:(UIViewController*)viewController {

    // taken from https://gist.github.com/gimenete/53704124583b5df3b407
    
    // if there is noo rootview controller just set it
    if (!self.window.rootViewController) {
        self.window.rootViewController = viewController;
        return;
    }
    // if the controller already is rootview controller do nothing ...
    if ([self.window.rootViewController class] != [viewController class]) {
        
        UIView *snapShot = [self.window snapshotViewAfterScreenUpdates:YES];
        
        [viewController.view addSubview:snapShot];
        
        self.window.rootViewController = viewController;
        
        [UIView animateWithDuration:0.4f animations:^{
            snapShot.layer.opacity = 0;
            snapShot.layer.transform = CATransform3DMakeScale(1.5, 1.5, 1.5);
        } completion:^(BOOL finished) {
            [snapShot removeFromSuperview];
        }];
    }
}


#pragma mark - Lazy/Getter


- (NSUserDefaults *)defaults {
    
    if (!_defaults) {
        
        _defaults = [NSUserDefaults standardUserDefaults];
    }
    return _defaults;
}


- (MOODLEDataModel *)dataModel {
    
    return [MOODLEDataModel sharedDataModel];
}


#pragma mark -
@end

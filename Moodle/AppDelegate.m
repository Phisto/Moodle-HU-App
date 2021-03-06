/*
 *
 *  AppDelegate.m
 *  Moodle
 *
 *  Copyright © 2017 Simon Gaus. All rights reserved.
 *
 */

#import "AppDelegate.h"

/* Data Model */
#import "MOODLEDataModel.h"

/* Controller */
#import "MOODLELoginViewController.h"
#import "MOODLETabBarController.h"
#import "MOODLEProgressViewController.h"
#import "MOODLESettingsViewController.h"



///-----------------------
/// @name CONSTANTS
///-----------------------



// As I dont know when the moodle session will invalidate,
// just assumed that a session will invalidate after two houres
static NSTimeInterval const kLoginTimeoutTrashold = 7200.0f;



///-----------------------
/// @name CATEGORIES
///-----------------------


@interface AppDelegate (/* Private */)

@property (nonatomic, strong) NSUserDefaults *defaults;
@property (nonatomic, strong) MOODLEDataModel *dataModel;

@end



///-----------------------
/// @name IMPLEMENTATION
///-----------------------



@implementation AppDelegate
#pragma mark - Delegate Methodes


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    // register to notification so we transition to the course view controler after login (embeded in tab bar controller, hence the name ...)
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(transitionToCourseViewController)
                                                 name:MOODLEDidLoginNotification
                                               object:nil];
    
    // register to notification so we transition to the course view controler after login (embeded in tab bar controller, hence the name ...)
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(logout)
                                                 name:MOODLEShouldLogoutNotification
                                               object:nil];    
    return YES;
}


- (void)applicationDidEnterBackground:(UIApplication *)application {

    // save user defaults
    [self.defaults synchronize];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {

    // check if the usere already logged in &
    // if its more than 2 houres ago transition to the login view controller
    // because we dont know if the session is still valid we attemp to logout first
    ///???: this possibly can be skipped if its very long time since the user logged in ?
    if ([self dataModel].loginDate && [[NSDate date] timeIntervalSinceDate:[self dataModel].loginDate] > kLoginTimeoutTrashold) {
        
        // display an undetermined progress indicator while logout
        // to signal to the user that the session is over
        // use a new view controller not just a hud progress indicator
        [self transitionToProgressViewControllerWithMessage:YES];
        
        // logout on background
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul);
        dispatch_async(queue, ^{
            
            [self.dataModel logoutWithCompletionHandler:^(BOOL success, NSError * _Nullable error) {
                
                // its not important if the loggout was successful
                // as this is just for safety (and may be performed while the user is logged out and subsequently fail here)
                
                // there realy is no login date now ...
                self.dataModel.loginDate = nil;
                
                // update ui on main thread
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


#pragma mark - Logout Methodes


- (void)logout {
    
    // display an undetermined progress indicator while logout
    // to signal to the user that the session is over
    // use a new view controller not just a hud progress indicator
    [self transitionToProgressViewControllerWithMessage:NO];
    
    // logout on background
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul);
    dispatch_async(queue, ^{
        
        [self.dataModel logoutWithCompletionHandler:^(BOOL success, NSError * _Nullable error) {
            
            // its not important if the loggout was successful
            // as this is just for safety (and may be performed while the user is logged out and subsequently fail here)
            
            // there realy is no login date now ...
            self.dataModel.loginDate = nil;
            
            // update ui on main thread
            dispatch_async(dispatch_get_main_queue(), ^{
                [self transitionToLoginViewController];
            });
        }];
    });
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


- (void)transitionToProgressViewControllerWithMessage:(BOOL)showMessage {
    
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    MOODLEProgressViewController *controller = [mainStoryBoard instantiateViewControllerWithIdentifier:MOODLEProgressViewControllerIdentifier];
    controller.shouldShowReloginLabel = showMessage;
    [self changeRootViewController:controller];
}


- (void)changeRootViewController:(UIViewController*)viewController {

    // source taken from https://gist.github.com/gimenete/53704124583b5df3b407
    
    // if there is no rootview controller just set it without animation
    if (!self.window.rootViewController) {
        self.window.rootViewController = viewController;
        return;
    }
    // if the controller already is the rootview controller do nothing ...
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


#pragma mark - Lazy/Getter/Injected


- (NSUserDefaults *)defaults {
    
    if (!_defaults) {
        
        _defaults = [NSUserDefaults standardUserDefaults];
    }
    return _defaults;
}


- (MOODLEDataModel *)dataModel {
    
    if (!_dataModel) {
        
        _dataModel = [MOODLEDataModel sharedDataModel];
    }
    
    return _dataModel;
}


#pragma mark -
@end

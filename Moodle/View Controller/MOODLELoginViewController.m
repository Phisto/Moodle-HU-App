/*
 *  MOODLELoginViewController.m
 *  Moodle
 *
 *  Created by Simon Gaus on 03.06.17.
 *  Copyright © 2017 Simon Gaus. All rights reserved.
 *
 */


/* Header */
#import "MOODLELoginViewController.h"

/* Data Model */
#import "MOODLEDataModel.h"

/* Accessibility */
#import "AccessibilityCoordinator.h"

/* Custom Views */
#import "SGLabeledSwitch.h"
#import "HUProgressIndicator.h"


///-----------------------
/// @name CONSTANTS
///-----------------------



static NSInteger const kUsernameTextFieldTag = 101;
static NSInteger const kPasswordTextFieldTag = 102;



///-----------------------
/// @name CATEGORIES
///-----------------------



#pragma mark - Private Category
@interface MOODLELoginViewController (/* Private */) <UITextFieldDelegate>

// UI
@property (nonatomic, strong) IBOutlet UIImageView *imageView; // for displaying hu logo
@property (nonatomic, strong) IBOutlet UITextField *usernameTextField;
@property (nonatomic, strong) IBOutlet UITextField *passwordTextField;
@property (nonatomic, strong) IBOutlet UILabel *errorLabel;
@property (nonatomic, strong) IBOutlet UIButton *loginButton;
@property (nonatomic, strong) IBOutlet SGLabeledSwitch *saveCredentialsSwitch;
@property (nonatomic, strong) IBOutlet SGLabeledSwitch *autoLoginSwitch;
@property (nonatomic, strong) UIView *loadingView;
// Contraints
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *imageHeightConstraint;
// Navigation
@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer; // for dismissing keyboard
// Model
@property (nonatomic, strong) MOODLEDataModel *dataModel;

@property (nonatomic, strong) AccessibilityCoordinator *accessibility_cord;

@end


#pragma mark - Accessibility Category
@interface MOODLELoginViewController (Accessibility)

- (BOOL)accessibility_accessibilityIsActiv;
- (void)accessibility_highlightElement:(id)element;

@end



///-----------------------
/// @name IMPLEMENTATION
///-----------------------



@implementation MOODLELoginViewController
#pragma mark - View Controller Methodes


- (void)viewDidLoad {
    // call super
    [super viewDidLoad];
    
    // Add tap gesture recogniszer (for dismissing keyboard)
    self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                        action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:self.tapGestureRecognizer];
    
    /*
    NSLog(@"Cookies before login");
    NSLog(@"\n\n\n");
    
    NSArray *cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage].cookies;
    for (NSHTTPCookie *plaetzchen in cookies) {
        
        NSLog(@"cookies:%@", plaetzchen);
    }
    
    NSLog(@"\n\n\n");
    */
}


- (void)viewDidAppear:(BOOL)animated {
    
    // call super
    [super viewDidAppear:animated];
    
    // register self as observer for keyboard events
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    // set option switches
    self.saveCredentialsSwitch.text = NSLocalizedString(@"Anmeldedaten merken", @"Label of the switch to toggle saving of username and password");
    self.saveCredentialsSwitch.value = self.dataModel.shouldRememberCredentials;
    self.autoLoginSwitch.text = NSLocalizedString(@"Automatisch einloggen", @"Label of the switch to toggle if autologin is enabled");
    self.autoLoginSwitch.value = self.dataModel.shouldAutoLogin;
    
    if (self.dataModel.shouldRememberCredentials && self.dataModel.hasUserCredentials) {
        
        [self populateUserCredentials];
    }
    
    if (self.dataModel.shouldAutoLogin && self.dataModel.hasUserCredentials) {
        
        [self loginWithUsername:self.dataModel.userName
                    andPassword:self.dataModel.userPassword];
    }
}


- (void)viewWillDisappear:(BOOL)animated {
    
    // call super
    [super viewWillDisappear:animated];
    
    // remove keyboard observer
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    // delete user credentials
    if (!self.dataModel.shouldRememberCredentials && self.dataModel.hasUserCredentials) {
        
        [self.dataModel deleteUserCredentials];
    }
}


- (BOOL)shouldAutorotate {
    return NO;
}


#pragma mark - Layout Methodes


- (void)viewDidLayoutSubviews {
    
    [self.autoLoginSwitch setNeedsLayout];
    [self.saveCredentialsSwitch setNeedsLayout];
}


#pragma mark - Keychain Related Methodes


- (void)populateUserCredentials {
    
    self.usernameTextField.text = self.dataModel.userName;
    self.passwordTextField.text = self.dataModel.userPassword;
}


#pragma mark - IBAction Methodes


- (IBAction)login:(id)sender {
    
    NSString *username = self.usernameTextField.text;
    NSString *password = self.passwordTextField.text;
    
    [self loginWithUsername:username andPassword:password];
}


- (void)loginWithUsername:(NSString *)username andPassword:(NSString *)password {
    
    // prevent user interaction during loggin process
    self.usernameTextField.enabled = NO;
    self.passwordTextField.enabled = NO;
    
    if ( [username isEqualToString:@""] || [password isEqualToString:@""]) {
        
        NSString *locString = NSLocalizedString(@"Bitte geben Sie einen Benutzernamen und Passwort ein.", @"Message if the user tried to login without entering user credentials.");
        
        if (self.accessibility_accessibilityIsActiv) {
            
            // need to wait a bit so the message will be spoken by voiceover,
            // otherwise the login button action annonuncment will 'override'
            // our failure announcment. (the values 2 is guessed and depends on the user settings)
            [self performSelector:@selector(showFailureWithMessage:)
                       withObject:locString
                       afterDelay:2.0f];
        }
        else {
            
            [self showFailureWithMessage:locString];
        }
    }
    else {
        
        // display indetermined progress indicator
        [self.view addSubview:self.loadingView];
        // set focus to indicator so voiceover will inform user of the process
        [self accessibility_highlightElement:self.loadingView];
        
        // perform web request on background thread ...
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul);
        dispatch_async(queue, ^{
            
            [self.dataModel loginWithUsername:username
                                     password:password
                            completionHandler:^(BOOL success, NSError *error) {
                                
                                if (success) {
                                    
                                    // now make changes to the userdefaults
                                    // corresponding to the current settings
                                    if (self.dataModel.shouldRememberCredentials) {
                                        
                                        [self.dataModel saveUserCredentials:username andPassword:password];
                                    }
                                    else {
                                        
                                        if (self.dataModel.hasUserCredentials) {
                                            [self.dataModel deleteUserCredentials];
                                        }
                                    }
                                    
                                    if (self.accessibility_accessibilityIsActiv) {
                                        
                                        AccessibilityCoordinator *coord = [[AccessibilityCoordinator alloc] init];
                                        [coord accessibility_informUserViaVoiceOver:NSLocalizedString(@"Login erfolgreich", @"Voice over message aftter successfull login.")
                                                                            timeout:15.0f // call this method after 15 seconds event when the method failes (VoiceOver seems to be tricky at times)
                                                                  completionHandler:^{
                                                                      
                                                                      // update ui on main thread
                                                                      dispatch_async(dispatch_get_main_queue(), ^{
                                                                          
                                                                          // remove activity indicator
                                                                          [self.loadingView removeFromSuperview];
                                                                          self.loadingView = nil;
                                                                          
                                                                          
                                                                          
                                                                          // this will make the app delegate change the root view controller
                                                                          // from loggin to course controller
                                                                          [[NSNotificationCenter defaultCenter] postNotificationName:MOODLEDidLoginNotification
                                                                                                                              object:nil];
                                                                      });
                                                                  }];
                                        // we need to store strong reference
                                        ///!!!: This works but is lazy, find a more beautiful way please me!
                                        self.accessibility_cord = coord;
                                    }
                                    else {
                                        
                                        // update ui on main thread
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            
                                            // remove activity indicator
                                            [self.loadingView removeFromSuperview];
                                            self.loadingView = nil;
                                            // this will make the app delegate change the root view controller
                                            // from loggin to course controller
                                            [[NSNotificationCenter defaultCenter] postNotificationName:MOODLEDidLoginNotification
                                                                                                object:nil];
                                        });
                                    }
                                }
                                else {
                                    
                                    NSString *locString = error.localizedDescription;
                                    if (!locString) {
                                        locString = NSLocalizedString(@"Bei der Kommunikation mit dem Server, ist ein Fehler aufgetreten.",
                                                                      @"Error message if loggin failed and no error is provided.");
                                    }
                                    
                                    if (self.accessibility_accessibilityIsActiv) {
                                        
                                        // need to wait a bit so the message will be spoken by voiceover,
                                        // otherwise the login button action annonuncment will 'override'
                                        // our failure announcment. (the values 2 is guessed and depends on the user settings)
                                        [self performSelector:@selector(showFailureWithMessage:)
                                                   withObject:locString
                                                   afterDelay:2.0f];
                                    }
                                    else {
                                        
                                        [self showFailureWithMessage:locString];
                                    }
                                    
                                    
                                }
                            }];
        });
    }
}


- (IBAction)shouldSaveCredentialsChanged:(id)sender {
    
    self.dataModel.shouldRememberCredentials = [(SGLabeledSwitch *)sender value];
}


- (IBAction)shouldAutoLoginChanged:(id)sender {
    
    self.dataModel.shouldAutoLogin = [(SGLabeledSwitch *)sender value];
}


#pragma mark - Failure Methodes


- (void)showFailureWithMessage:(NSString *)message {
    
    // make sure ui updates will be made on the main thread
    dispatch_async(dispatch_get_main_queue(), ^{
        
        // remove activity indicator
        [self.loadingView removeFromSuperview];
        self.loadingView = nil;
        
        // only reset password field as it is not visble
        ///???: This is questionable, as it takes away choice from the user ?
        self.passwordTextField.text = @"";
        
        self.usernameTextField.enabled = YES;
        self.passwordTextField.enabled = YES;
        
        self.errorLabel.text = message;
        self.errorLabel.hidden = NO;
        
        // If accessibilty is active we dont need to show the message for 2.0f seconds
        [self performSelector:@selector(slowlyHideErrorMessage) withObject:nil afterDelay:(self.accessibility_accessibilityIsActiv) ? 0.0f : 2.0f];
    });
}


- (void)slowlyHideErrorMessage {
    
    if (self.accessibility_accessibilityIsActiv) {
        
        AccessibilityCoordinator *coord = [[AccessibilityCoordinator alloc] init];
        [coord accessibility_informUserViaVoiceOver:self.errorLabel.text
                                            timeout:15
                                  completionHandler:^{
                                      
                                      // hide error message set first responder
                                      [UIView animateWithDuration:0.5f
                                                       animations:^{ self.errorLabel.alpha = 0; }
                                                       completion: ^(BOOL finished) {
                                                           
                                                           self.errorLabel.hidden = finished;
                                                           self.errorLabel.alpha = 1;
                                                           
                                                           self.usernameTextField.enabled = YES;
                                                           self.passwordTextField.enabled = YES;
                                                       }];
                                      
                                      // 'select' the user textfield for trying again
                                      [self accessibility_highlightElement:self.usernameTextField];
                                  }];
        self.accessibility_cord = coord;
    }
    
    else {
        
        // hide error message set first responder
        [UIView animateWithDuration:0.5f
                         animations:^{ self.errorLabel.alpha = 0; }
                         completion: ^(BOOL finished) {
                             
                             self.errorLabel.hidden = finished;
                             self.errorLabel.alpha = 1;
                             
                             self.usernameTextField.enabled = YES;
                             self.passwordTextField.enabled = YES;
                             
                             // 'select' the user textfield to try again
                             // if nothing is selected
                             if (!self.usernameTextField.isFirstResponder && !self.passwordTextField.isFirstResponder) {
                                 [self.usernameTextField becomeFirstResponder];
                             }
                         }];
    }
}


#pragma mark - Keyboard Related Methodes


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    // dismiss focus on the textfield when return key is hit
    [textField resignFirstResponder];
    
    // highlite a reasonable element else random element will be selected
    if ([self accessibility_accessibilityIsActiv]) {
        
        if (textField.tag == kUsernameTextFieldTag) {
            
            [self accessibility_highlightElement:self.passwordTextField];
        }
        else if (textField.tag == kPasswordTextFieldTag) {
            
            [self accessibility_highlightElement:self.loginButton];
        }
    }
    
    return YES;
}


- (void)dismissKeyboard {
    
    // dismiss focus on the textfields when user taps on 'background'
    [self.usernameTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
}


- (void)keyboardWillShow:(NSNotification*)notification {
    
    // the keyborad will appear so we hide the banner
    // and resize the image view so the text fields will go up.
    [UIView animateWithDuration:0.2f animations:^{
        
        self.imageView.hidden = YES;
        self.imageHeightConstraint.constant = 35.0f;
        [self.view layoutIfNeeded];
    }];
}


- (void)keyboardWillHide:(NSNotification*)notification {
    
    // the keyborad will disappear so we show the banner
    // and resize the image view to its original frame
    [UIView animateWithDuration:0.2f animations:^{
        
        self.imageView.hidden = NO;
        self.imageHeightConstraint.constant = 156.0f;
        [self.view layoutIfNeeded];
    }];
}


#pragma mark - Lazy/Getter


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
        
        UILabel *loadLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 25, 90, 22)];
        loadLabel.text = NSLocalizedString(@"Login", @"Lable of the activity indicator during login request.");
        loadLabel.font = [UIFont systemFontOfSize:18.0f];
        loadLabel.textAlignment = NSTextAlignmentCenter;
        loadLabel.textColor = [UIColor blackColor];
        loadLabel.backgroundColor = [UIColor clearColor];
        [loadLabel setCenter:CGPointMake(loading.frame.size.width/2.0f, loading.frame.size.height*0.88f)];
        
        [loading addSubview:loadLabel];
        
        
        HUProgressIndicator *spinning = [[HUProgressIndicator alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
        spinning.backgroundColor = [UIColor clearColor];
        spinning.color = [UIColor blackColor];
        [spinning setCenter:CGPointMake(loading.frame.size.width/2.0f, loading.frame.size.height*0.45f)];
        [loading addSubview:spinning];
        [spinning startAnimating];
        
        [loading setCenter:CGPointMake(self.view.frame.size.width/2.0f, self.view.frame.size.height/2.0f)];
        
        _loadingView = loading;
    }
    return _loadingView;
}


- (MOODLEDataModel *)dataModel {
    
    if (!_dataModel) {
        
        _dataModel = [MOODLEDataModel sharedDataModel];
    }
    return _dataModel;
}


#pragma mark -
@end



#pragma mark - ACCESSIBILITY
///-----------------------
/// @name ACCESSIBILITY
///-----------------------



@implementation MOODLELoginViewController (Accessibility)


- (BOOL)accessibility_accessibilityIsActiv {
    
    return UIAccessibilityIsVoiceOverRunning();
}


- (void)accessibility_highlightElement:(id)element {
    
    UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification,  element);
}


- (void)accessibility_informUserViaVoiceOver:(NSString *)message {
    
    UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, message);
}

#pragma mark -
@end

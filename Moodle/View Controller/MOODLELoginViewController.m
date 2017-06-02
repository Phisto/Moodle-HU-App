/*
 *  MOODLELoginViewController.m
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
#import "MOODLELoginViewController.h"

/* Data Model */
#import "MOODLEDataModel.h"



///-----------------------
/// @name CATEGORIES
///-----------------------



@interface MOODLELoginViewController (/* Private */) <UITextFieldDelegate>

// UI
@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) IBOutlet UITextField *usernameTextField;
@property (nonatomic, strong) IBOutlet UITextField *passwordTextField;
@property (nonatomic, strong) IBOutlet UILabel *errorLabel;
@property (nonatomic, strong) IBOutlet UIButton *loginButton;
@property (nonatomic, strong) IBOutlet UISwitch *saveCredentialsSwitch;
@property (nonatomic, strong) IBOutlet UISwitch *autoLoginSwitch;
@property (nonatomic, strong) UIView *loadingView;

// Contraints
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *bottomConstraint;

// Navigation
@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;

// Model
@property (nonatomic, strong) MOODLEDataModel *dataModel;

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
    self.saveCredentialsSwitch.on = self.dataModel.shouldRememberCredentials;
    self.autoLoginSwitch.on = self.dataModel.shouldAutoLogin;
    
    // set contraints
    CGFloat heights = self.view.bounds.size.height;
    self.bottomConstraint.constant = MOODLEPixelAlignedValue(heights/4.0f); // pixel alligne value
    
    // hide/show hu_logo based on screen size
    [self evaluateImageViewVisibility];
    
    if (self.dataModel.shouldRememberCredentials && self.dataModel.hasUserCredentials) [self populateUserCredentials];
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


- (void)evaluateImageViewVisibility {
    
    [UIView animateWithDuration:0.5 animations:^{
        
        self.imageView.hidden = (self.imageView.frame.size.height < 60.0f);
        [self.view layoutIfNeeded];
    }];
}


#pragma mark - Keychain Related Methodes


- (void)populateUserCredentials {
    
    self.usernameTextField.text = self.dataModel.userName;
    self.passwordTextField.text = self.dataModel.userPassword;
}


#pragma mark - Keyboard Related Methodes


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}


- (void)dismissKeyboard {
    
    [self.usernameTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
}


- (void)keyboardWillShow:(NSNotification*)notification {
    NSDictionary *info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    if (self.bottomConstraint.constant < kbSize.height) {
        
        [UIView animateWithDuration:0.3 animations:^{
            
            // we dont need to pixel alligne value, kbSize.height will be alligned
            self.bottomConstraint.constant = kbSize.height;
            [self.view layoutIfNeeded];
        }];
    }
    
    // hide/show hu_logo
    [self evaluateImageViewVisibility];
}


- (void)keyboardWillHide:(NSNotification*)notification {
    
    [UIView animateWithDuration:0.3 animations:^{
        
        // set contraints
        CGFloat heights = self.view.bounds.size.height;
        self.bottomConstraint.constant = MOODLEPixelAlignedValue(heights/4.0f); // pixel alligne value
        [self.view layoutIfNeeded];
    }];
    
    // hide/show hu_logo
    [self evaluateImageViewVisibility];
}


#pragma mark - IBAction Methodes


- (IBAction)login:(id)sender {
    
    NSString *username = self.usernameTextField.text;
    NSString *password = self.passwordTextField.text;
    
    [self loginWithUsername:username andPassword:password];
}


- (void)loginWithUsername:(NSString *)username andPassword:(NSString *)password {
    
    self.usernameTextField.enabled = NO;
    self.passwordTextField.enabled = NO;
    
    if ( [username isEqualToString:@""] || [password isEqualToString:@""]) {
        
        NSString *locString = NSLocalizedString(@"Bitte geben Sie einen Benutzernamen und Passwort ein.", @"Message if the user tried to login without entering user credentials.");
        [self showFailureWithMessage:locString];
        self.usernameTextField.enabled = YES;
        self.passwordTextField.enabled = YES;
    }
    else {
        
        [self.view addSubview:self.loadingView];
        
        // perform web request on background thread ...
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul);
        dispatch_async(queue, ^{
            
            [self.dataModel loginWithUsername:username
                                     password:password
                            completionHandler:^(BOOL success, NSError *error) {
                                  
                                  if (success) {
                                      
                                      if (self.dataModel.shouldRememberCredentials) {
                                          
                                          [self.dataModel saveUserCredentials:username andPassword:password];
                                      }
                                      else {
                                          
                                          if (self.dataModel.hasUserCredentials) {
                                              [self.dataModel deleteUserCredentials];
                                          }
                                      }
                                      
                                      dispatch_async(dispatch_get_main_queue(), ^{
                                          
                                          [self.loadingView removeFromSuperview];
                                          self.loadingView = nil;
                                          
                                          [[NSNotificationCenter defaultCenter] postNotificationName:MOODLEDidLoginNotification
                                                                                              object:nil];
                                      });
                                  }
                                  else {
                                      
                                      if (error) [self showFailureWithMessage:error.localizedDescription];
                                  }
                              }];
        });
    }
}


- (IBAction)shouldSaveCredentialsChanged:(id)sender {
    
    self.dataModel.shouldRememberCredentials = [(UISwitch *)sender isOn];
}


- (IBAction)shouldAutoLoginChanged:(id)sender {
    
    self.dataModel.shouldAutoLogin = [(UISwitch *)sender isOn];
}


#pragma mark - Failure Methodes


- (void)showFailureWithMessage:(NSString *)message {
    
    // make sure ui updates will be made on the main thread
    dispatch_async(dispatch_get_main_queue(), ^{

        [self.loadingView removeFromSuperview];
        self.loadingView = nil;
        
        self.usernameTextField.text = @"";
        self.passwordTextField.text = @"";
        
        self.errorLabel.text = message;
        self.errorLabel.hidden = NO;
        
        [self performSelector:@selector(slowlyHideErrorMessage) withObject:nil afterDelay:2.0f];
    });
}


- (void)slowlyHideErrorMessage {
    
    [UIView animateWithDuration:0.5f
                     animations:^{ self.errorLabel.alpha = 0; }
                     completion: ^(BOOL finished) {
                         
                         self.errorLabel.hidden = finished;
                         self.errorLabel.alpha = 1;
                         
                         self.usernameTextField.enabled = YES;
                         self.passwordTextField.enabled = YES;
                     }];
}


#pragma mark - Lazy/Getter


- (UIView *)loadingView {
    
    if (!_loadingView) {
        
        UIView *loading = [[UIView alloc] initWithFrame:CGRectMake(100, 200, 120, 120)];
        
        loading.layer.cornerRadius = 15;
        loading.opaque = NO;
        loading.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.7f];
        
        UILabel *loadLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 25, 90, 22)];
        loadLabel.text = NSLocalizedString(@"Login", @"Lable of the activity indicator during login request.");
        loadLabel.font = [UIFont boldSystemFontOfSize:18.0f];
        loadLabel.textAlignment = NSTextAlignmentCenter;
        loadLabel.textColor = [UIColor colorWithWhite:1.0f alpha:1.0f];
        loadLabel.backgroundColor = [UIColor clearColor];
        [loadLabel setCenter:CGPointMake(loading.frame.size.width/2.0f, loading.frame.size.height*0.8f)];
        
        [loading addSubview:loadLabel];
        
        UIActivityIndicatorView *spinning = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        spinning.frame = CGRectMake(42, 54, 37, 37);
        [spinning startAnimating];
        [spinning setCenter:CGPointMake(loading.frame.size.width/2.0f, loading.frame.size.height*0.45f)];
        [loading addSubview:spinning];
        
        //loading.frame = CGRectMake(100, 200, 120, 120);
        [loading setCenter:CGPointMake(self.view.frame.size.width/2.0f, self.view.frame.size.height/2.0f)];
        
        _loadingView = loading;
    }
    return _loadingView;
}


- (MOODLEDataModel *)dataModel {
    
    return [MOODLEDataModel sharedDataModel];
}


#pragma mark - Funktions


static inline CGFloat MOODLEPixelAlignedValue(CGFloat value) {
    
    return (value < 0.5f) ? 0.5f : floor(value * 2) / 2;
}


#pragma mark -
@end

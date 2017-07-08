/*
 *
 *  MOODLEMessagesViewController.m
 *  Moodle
 *
 *  Copyright © 2017 Simon Gaus. All rights reserved.
 *
 */

#import "MOODLEMessagesViewController.h"

/* Data Model */
#import "MOODLEDataModel.h"
#import "MOODLEChat.h"

/* Custom Views */
#import "MOODLEActivityView.h"

/* Table View */
#import "MOODLEChatItemTableViewCell.h"

/* View Controller */
#import "MOODLEChatItemViewController.h"


///-----------------------
/// @name CATEGORIES
///-----------------------



@interface MOODLEMessagesViewController (/* Private */)

// UI
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) MOODLEActivityView *loadingView;
// Data
@property (nonatomic, strong) MOODLEDataModel *dataModel;

@end



///-----------------------
/// @name IMPLEMENTATION
///-----------------------



@implementation MOODLEMessagesViewController
#pragma mark - View Controller Methodes


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (!self.dataModel.chats) {
        
        // show activity indicator..
        [self.view addSubview:self.loadingView];
        
        // perform web request on background thread ...
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul), ^{
            
            [self.dataModel loadChatsWithCompletionHandler:^(BOOL success, NSError * _Nullable error) {
                if (success) { [self finishedContentLoading]; }
                else { [self failedToLoadContentWithMessage:error.localizedDescription]; }
            }];
        });
    }
    else {
        
        [self showTableView];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillAppear:(BOOL)animated {
    
    // call super
    [super viewWillAppear:animated];
    
    // deselect table view cell
    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow
                                  animated:YES];
}


- (BOOL)shouldAutorotate {
    
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    BOOL rotate = !UIInterfaceOrientationIsPortrait(interfaceOrientation);
    return rotate;
}


- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}


#pragma mark - Helper Methodes


- (void)failedToLoadContentWithMessage:(NSString *)message {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.loadingView removeFromSuperview];
        
        NSString *locString = NSLocalizedString(@"Fehler", @"Error alert presenting title");
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:locString
                                                                                 message:message
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        NSString *cancelActionTitle = NSLocalizedString(@"Weiter", @"alert view retry button title");
        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:cancelActionTitle
                                                               style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction * _Nonnull action) {
                                                                 
                                                                 // free the activity view
                                                                 self.loadingView = nil;
                                                             }];
        [alertController addAction:cancleAction];
        
        NSString *retryActionTitle = NSLocalizedString(@"Nochmal versuchen", @"alert view retry button title");
        UIAlertAction *retryAction = [UIAlertAction actionWithTitle:retryActionTitle
                                                              style:UIAlertActionStyleDefault
                                                            handler:^(UIAlertAction * _Nonnull action) {
                                                                // retry content loading...
                                                                
                                                                // show activity indicator..
                                                                [self.view addSubview:self.loadingView];
                                                                
                                                                // perform web request on background thread ...
                                                                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul), ^{
                                                                    
                                                                    [self.dataModel loadChatsWithCompletionHandler:^(BOOL success, NSError * _Nullable error) {
                                                                        if (success) { [self finishedContentLoading]; }
                                                                        else { [self failedToLoadContentWithMessage:error.localizedDescription]; }
                                                                    }];
                                                                });
                                                            }];
        
        [alertController addAction:retryAction];
        
        [self presentViewController:alertController
                           animated:YES
                         completion:nil];
        
    });
}


- (void)finishedContentLoading {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.loadingView removeFromSuperview];
        self.loadingView = nil;
        [self showTableView];
    });
}


- (void)showTableView {
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.hidden = NO;
    [self.tableView reloadData];
    [self.view setNeedsDisplay];
}


#pragma mark - Table View Methodes


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MOODLEChat *chat = self.dataModel.chats[indexPath.row];
    MOODLEChatItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MOODLEChatItemTableViewCellIdentifier
                                                                        forIndexPath:indexPath];
    cell.chatPartnerLabel.text = chat.chatPartnerName;
    cell.timeLabel.text = chat.lastMessageDate;
    cell.previewMessageView.text = chat.previewMessage;
    cell.profileImagView.image = [UIImage imageNamed:@"user_icon"];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 100.0f;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataModel.chats.count;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MOODLEChat *chat = self.dataModel.chats[indexPath.row];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    MOODLEChatItemViewController *newViewController = (MOODLEChatItemViewController *)[storyboard instantiateViewControllerWithIdentifier:@"chatItemViewController"];
    newViewController.chat = chat;
    newViewController.navigationItem.title = chat.chatPartnerName;
    [self.navigationController pushViewController:newViewController animated:YES];
}


#pragma mark - Lazy/Getter Methodes


- (MOODLEDataModel *)dataModel {
    
    if (!_dataModel) {
        
        _dataModel = [MOODLEDataModel sharedDataModel];
    }
    return _dataModel;
}


- (UIView *)loadingView {
    
    if (!_loadingView) {
        
        NSString *locString = NSLocalizedString(@"Laden", @"Label of the progress indicator during course content loading.");
        MOODLEActivityView *view = [MOODLEActivityView activityViewWithText:locString];
        view.center = CGPointMake(
                                  self.tableView.center.x-view.frame.size.width/4.0f,
                                  self.tableView.center.y-view.frame.size.height/4.0f
                                  );
        _loadingView = view;
    }
    return _loadingView;
}


#pragma mark -
@end

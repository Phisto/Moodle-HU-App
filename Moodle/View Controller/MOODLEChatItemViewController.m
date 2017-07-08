/*
 *
 *  MOODLEChatItemViewController.m
 *  Moodle
 *
 *  Copyright © 2017 Simon Gaus. All rights reserved.
 *
 */

#import "MOODLEChatItemViewController.h"

/* Data Model */
#import "MOODLEDataModel.h"
#import "MOODLEChat.h"
#import "MOODLEChatMessage.h"

/* Custom Views */
#import "MOODLEActivityView.h"

/* Table View */
#import "MOODLEChatMessageTableViewCell.h"

///-----------------------
/// @name CATEGORIES
///-----------------------



@interface MOODLEChatItemViewController (/* Private */)

// UI
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) MOODLEActivityView *loadingView;
// Data
@property (nonatomic, strong) MOODLEDataModel *dataModel;
// Other
@property (nonatomic, strong) UITextView *heightCalculationTextView;

@end



///-----------------------
/// @name IMPLEMENTATION
///-----------------------



@implementation MOODLEChatItemViewController
#pragma mark - View Controller Methodes


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (!self.chat.messages) {
        
        // show activity indicator..
        [self.view addSubview:self.loadingView];
        
        // perform web request on background thread ...
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul), ^{
            
            [self.dataModel loadChatMessagesforChat:self.chat withCompletionHandler:^(BOOL success, NSError * _Nullable error) {
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
    self.tableView.sectionFooterHeight = 0.0f;
    self.tableView.hidden = NO;
    [self.tableView reloadData];
    [self.view setNeedsDisplay];
}

#pragma mark - Table View Methodes


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MOODLEChatMessage *message = self.chat.messages[indexPath.section][indexPath.row];
    MOODLEChatMessageTableViewCell *cell;
    if (message.isFromSelf) {
        
        cell = [tableView dequeueReusableCellWithIdentifier:MOODLEChatMessageTableViewCellIdentifierLEFT
                                               forIndexPath:indexPath];
    }
    else {
        
        cell = [tableView dequeueReusableCellWithIdentifier:MOODLEChatMessageTableViewCellIdentifierRIGHT
                                               forIndexPath:indexPath];
    }
    
    cell.timeLabel.text = message.time;
    cell.textView.attributedText = message.attributedMessage;

    return cell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
     return self.chat.messages[section].count;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.chat.messages.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MOODLEChatMessage *message = self.chat.messages[indexPath.section][indexPath.row];
    CGFloat height = [self textViewHeightForAttributedText:message.attributedMessage
                                                  andWidth:(tableView.frame.size.width*0.7f)-10];// substract width margin
    return height+16.0f; // add height margins
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 35.0f;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *view = [[UIView alloc] init];
    UILabel *label = [[UILabel alloc] init];
    
    // view
    view.backgroundColor = [UIColor whiteColor];
    
    // label
    label.text = self.chat.messages[section].firstObject.date;
    label.textAlignment = NSTextAlignmentCenter;
    [label sizeToFit];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    
    [view addSubview:label];
    
    // autolayout
    [label.leadingAnchor constraintEqualToAnchor:view.leadingAnchor constant:0].active = YES;
    [label.trailingAnchor constraintEqualToAnchor:view.trailingAnchor constant:0].active = YES;
    [label.topAnchor constraintEqualToAnchor:view.topAnchor constant:0].active = YES;
    [label.bottomAnchor constraintEqualToAnchor:view.bottomAnchor constant:0].active = YES;

    return view;
}


#pragma mark - Helper Methodes


- (CGFloat)textViewHeightForAttributedText:(NSAttributedString *)text andWidth:(CGFloat)width {
    
    [self.heightCalculationTextView setAttributedText:text];
    CGSize size = [self.heightCalculationTextView sizeThatFits:CGSizeMake(width, FLT_MAX)];
    
    return size.height;
}


#pragma mark - Lazy/Getter Methodes


- (UITextView *)heightCalculationTextView {
    
    if (!_heightCalculationTextView) {
        
        _heightCalculationTextView = [[UITextView alloc] init];
    }
    return _heightCalculationTextView;
}


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

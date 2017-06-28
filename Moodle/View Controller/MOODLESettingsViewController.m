/*
 *  MOODLESettingsViewController.m
 *  Moodle
 *
 *  Created by Simon Gaus on 03.06.17.
 *  Copyright © 2017 Simon Gaus. All rights reserved.
 *
 */

/* Header */
#import "MOODLESettingsViewController.h"

/* Data Model */
#import "MOODLEDataModel.h"
#import "MOODLECourse.h"

/* Other */
#import "MOODLETableViewRowAction.h"

/* Custom Controls */
#import "SGLabeledSwitch.h"

/* Colors */
#import "UIColor+Moodle.h"


@interface MOODLESettingsViewController (/* Private */)

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet SGLabeledSwitch *autoLoginSwitch;
@property (nonatomic, strong) IBOutlet UILabel *hiddenSectionsLabel;
@property (nonatomic, strong) IBOutlet UISlider *storageSlider;
@property (nonatomic, strong) IBOutlet UILabel *storageSliderLabel;
@property (nonatomic, strong) IBOutlet UILabel *storageLabel;

@property (nonatomic, strong) MOODLEDataModel *dataModel;


@end



///-----------------------
/// @name IMPLEMENTATION
///-----------------------



@implementation MOODLESettingsViewController
#pragma mark - View Controller Methodes


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.autoLoginSwitch.value = self.dataModel.shouldAutoLogin;
    
    
    NSString *locString = NSLocalizedString(@"Logout", @"title of the logout button");
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:locString
                                                                      style:UIBarButtonItemStylePlain
                                                                     target:self
                                                                     action:@selector(logout:)];
    anotherButton.accessibilityLabel = locString;
    
    anotherButton.image = [UIImage imageNamed:@"logout_icon"];
    self.navigationItem.rightBarButtonItem = anotherButton;
}


- (void)viewWillAppear:(BOOL)animated {
    
    // call super
    [super viewWillAppear:animated];
    
    [self calculateIfTableViewIsHidden];
    [self.tableView reloadData];
    
    self.storageSlider.value = self.dataModel.documentCacheSize;
    self.storageSliderLabel.text = [NSString stringWithFormat:@"%lu MB", (unsigned long)self.dataModel.documentCacheSize];
    
    NSString *locString = NSLocalizedString(@"Zur Zeit sind %lu MB belegt.", @"label of the storage field");
    self.storageLabel.text = [NSString stringWithFormat:locString, self.dataModel.sizeOfCachedDocuments];
}


- (BOOL)shouldAutorotate {
    
    return NO;
}


- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}


#pragma mark - Layout Methodes


- (void)calculateIfTableViewIsHidden {
    
    if (self.dataModel.hiddenCourses.count == 0) {
        
        self.tableView.hidden = YES;
        self.hiddenSectionsLabel.hidden = YES;
    }
    else {
        
        self.tableView.hidden = NO;
        self.hiddenSectionsLabel.hidden = NO;
    }
}


#pragma mark - IBAction Methodes


- (IBAction)shouldAutoLoginChanged:(id)sender {
    
    self.dataModel.shouldAutoLogin = [(SGLabeledSwitch *)sender value];
}


- (IBAction)changedCacheSize:(UISlider *)sender {
    
    self.dataModel.documentCacheSize = sender.value;
    self.storageSliderLabel.text = [NSString stringWithFormat:@"%lu MB", (unsigned long)sender.value];
}


- (IBAction)logout:(id)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:MOODLEShouldLogoutNotification
                                                        object:nil];
}


#pragma mark - Table View Methodes


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *deletedCellIdentifier = @"deletedCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:deletedCellIdentifier];
    cell.textLabel.text = self.dataModel.hiddenCourses[indexPath.row].courseTitle;
    return cell;
}


- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewRowAction *unhideAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault
                                                                            title:NSLocalizedString(@"Wieder anzeigen", @"Label of the button to unhide a moodle course.")
                                                                          handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                                                                              
                                                                              self.dataModel.hiddenCourses[indexPath.row].isHidden = NO;
                                                                              
                                                                              [self.tableView deleteRowsAtIndexPaths:@[indexPath]
                                                                                                    withRowAnimation:UITableViewRowAnimationRight];
                                                                              
                                                                              // hide the table view if there are no hidden courses
                                                                              [self calculateIfTableViewIsHidden];
                                                                          }];
    
    unhideAction.backgroundColor = [UIColor moodle_unhideActionColor];
    
    return @[unhideAction];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataModel.hiddenCourses.count;
}


#pragma mark - Lazy/Getter Methodes


- (MOODLEDataModel *)dataModel {
    
    if (!_dataModel) {
        
        _dataModel = [MOODLEDataModel sharedDataModel];
    }
    return _dataModel;
}



#pragma mark -
@end

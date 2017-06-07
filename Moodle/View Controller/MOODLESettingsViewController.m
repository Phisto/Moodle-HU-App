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

/* Colors */
#import "UIColor+Moodle.h"


@interface MOODLESettingsViewController (/* Private */)

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet UISwitch *autoLoginSwitch;
@property (nonatomic, strong) IBOutlet UILabel *hiddenSectionsLabel;
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
    self.autoLoginSwitch.on = self.dataModel.shouldAutoLogin;
}


- (void)viewWillAppear:(BOOL)animated {
    
    // call super
    [super viewWillAppear:animated];
    
    [self calculateIfTableViewIsHidden];
    [self.tableView reloadData];
}


- (BOOL)shouldAutorotate {
    return NO;
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
    
    self.dataModel.shouldAutoLogin = [(UISwitch *)sender isOn];
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

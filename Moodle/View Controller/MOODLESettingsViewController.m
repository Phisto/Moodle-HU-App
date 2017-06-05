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

@interface MOODLESettingsViewController (/* Private */) <UITableViewDelegate, UITableViewDataSource>

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


- (IBAction)shouldAutoLoginChanged:(id)sender {
    
    self.dataModel.shouldAutoLogin = [(UISwitch *)sender isOn];
}


- (BOOL)shouldAutorotate {
    return NO;
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
                                                                              
                                                                              //[self.dataModel setItemUnhiddenWithTitle:self.dataModel.hiddedCourseIdentifier[indexPath.row]];
                                                                              self.dataModel.hiddenCourses[indexPath.row].isHidden = NO;
                                                                              
                                                                              [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
                                                                              [self calculateIfTableViewIsHidden];
                                                                          }];
    
    unhideAction.backgroundColor = [UIColor colorWithRed:(231.0f/255.0f)
                                                 green:(76.0f/255.0f)
                                                  blue:(60.0f/255.0f)
                                                 alpha:1.0f];
    
    return @[unhideAction];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataModel.hiddenCourses.count;
}


#pragma mark - Lazy/Getter Methodes


- (MOODLEDataModel *)dataModel {
    
    return [MOODLEDataModel sharedDataModel];
}


#pragma mark -
@end

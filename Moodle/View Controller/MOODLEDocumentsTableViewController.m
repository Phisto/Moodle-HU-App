/*
 *  MOODLEDocumentsTableViewController.m
 *  Moodle
 *
 *  Created by Simon Gaus on 03.06.17.
 *  Copyright © 2017 Simon Gaus. All rights reserved.
 *
 */

#import "MOODLEDocumentsTableViewController.h"

/* Data Model */
#import "MOODLEDataModel.h"

/* Table View */
#import "MOODLECourseSectionItemTableViewCell.h"

/* Colors */
#import "UIColor+Moodle.h"

@interface MOODLEDocumentsTableViewController (/* Private */)

@property (nonatomic, strong) MOODLEDataModel *dataModel;

@end

@implementation MOODLEDocumentsTableViewController
#pragma mark - View Controller Methodes


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)shouldAutorotate {
    
    return NO;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [self.dataModel allRessourceURLS].count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MOODLECourseSectionItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MOODLECourseSectionItemTableViewCellIdentifier];
    NSURL *url = [self.dataModel allRessourceURLS][indexPath.row];
    cell.itemLabel.text = [url.lastPathComponent stringByDeletingPathExtension];
    cell.fileIconImageView.image = [UIImage imageNamed:@"pdf_icon"];
    
    // accessibility
    cell.accessibilityLabel = cell.itemLabel.text;
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 60.0f;
}


- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewRowAction *unhideAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault
                                                                            title:NSLocalizedString(@"Löschen", @"Label of the button to delete a document")
                                                                          handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                                                                              
                                                                              if ([self.dataModel deleteDocumentWithURL:[self.dataModel allRessourceURLS][indexPath.row]]) {
                                                                                  [self.tableView deleteRowsAtIndexPaths:@[indexPath]
                                                                                                        withRowAnimation:UITableViewRowAnimationRight];
                                                                              }
                                                                              
                                                                          }];
    
    unhideAction.backgroundColor = [UIColor moodle_hideActionColor];
    
    return @[unhideAction];
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

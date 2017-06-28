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

/* View Controller */
#import "MOODLEURLRessourceViewController.h"

/* Colors */
#import "UIColor+Moodle.h"

/* PDF */
#import "ReaderDocument.h"
#import "ReaderViewController.h"

///-----------------------
/// @name CONSTANTS
///-----------------------


static NSString * const KMOODLEPathExtentsionPDF = @"pdf";
static NSString * const KMOODLEPathExtentsionPPT = @"pptx";
static NSString * const KMOODLEPathExtentsionMP3 = @"mp3";


///-----------------------
/// @name CATEGORIES
///-----------------------



@interface MOODLEDocumentsTableViewController (/* Private */)<ReaderViewControllerDelegate>

// UI
@property (nonatomic, strong) UILabel *noContentInformationLabel;
// Data Model
@property (nonatomic, strong) MOODLEDataModel *dataModel;
// Table View
@property (nonatomic, strong) NSArray<NSArray<NSURL *> *> *tableData;
@property (nonatomic, strong) NSArray<NSString *> *titleArray;

@end



///-----------------------
/// @name IMPLEMENTATION
///-----------------------



@implementation MOODLEDocumentsTableViewController
#pragma mark - View Controller Methodes


- (void)viewDidAppear:(BOOL)animated {
    
    // call super
    [super viewDidAppear:animated];
    
    // table view inset
    self.tableView.contentInset = UIEdgeInsetsMake(22.0f, 0.0f, 22.0f, 0.0f);
    // reload data
    [self reloadTableData];
    // reload table view
    [self.tableView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)shouldAutorotate {
    
    return NO;
}


#pragma mark - Helper Methodes


- (void)reloadTableData {
    
    NSMutableArray *muteArrayArray = [NSMutableArray array];
    NSMutableArray *titleArray = [NSMutableArray array];
    
    NSMutableArray *pdfArray = [NSMutableArray array];
    NSMutableArray *pptArray = [NSMutableArray array];
    NSMutableArray *mp3Array = [NSMutableArray array];
    
    for (NSURL *fileURL in [self.dataModel allRessourceURLS]) {
        
        NSString *extension = [fileURL pathExtension];
        if ([extension isEqualToString:KMOODLEPathExtentsionPDF]) {
            
            [pdfArray addObject:fileURL];
        }
        else if ([extension isEqualToString:KMOODLEPathExtentsionPPT]) {
            
            [pptArray addObject:fileURL];
        }
        else if ([extension isEqualToString:KMOODLEPathExtentsionMP3]) {
            
            [mp3Array addObject:fileURL];
        }
    }
    
    if (pdfArray.count > 0) {
        
        [muteArrayArray addObject:[pdfArray copy]];
        NSString *locString = NSLocalizedString(@"PDF Dateien", @"header title for the pdf document section");
        [titleArray addObject:locString];
    }
    if (pptArray.count > 0) {
        
        [muteArrayArray addObject:[pptArray copy]];
        NSString *locString = NSLocalizedString(@"PowerPoint Dateien", @"header title for the ppt document section");
        [titleArray addObject:locString];
    }
    if (mp3Array.count > 0) {
        
        [muteArrayArray addObject:[mp3Array copy]];
        NSString *locString = NSLocalizedString(@"MP3 Dateien", @"header title for the mp3 document section");
        [titleArray addObject:locString];
    }
    
    _titleArray = [titleArray copy];
    _tableData = [muteArrayArray copy];
}


#pragma mark - Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    NSUInteger numberOfSections = self.tableData.count;
    if (numberOfSections == 0) {
        
        if (!self.noContentInformationLabel) {
         
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
            NSString *locString = NSLocalizedString(@"Keine Dokumente vorhanden", @"text label if there are no entries in the document table view");
            label.text = locString;
            label.textAlignment = NSTextAlignmentCenter;
            self.tableView.backgroundView = label;
            self.noContentInformationLabel = label;
        }
    }
    else {
        
        if (self.noContentInformationLabel) {
            
            self.tableView.backgroundView = nil;
            self.noContentInformationLabel = nil;
        }
    }
    return self.tableData.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.tableData[section].count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MOODLECourseSectionItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MOODLECourseSectionItemTableViewCellIdentifier];
    NSURL *url = self.tableData[indexPath.section][indexPath.row];
    cell.itemLabel.text = [url.lastPathComponent stringByDeletingPathExtension];
    
    NSString *extension = [url.lastPathComponent pathExtension];
    cell.fileIconImageView.image = ([extension isEqualToString:KMOODLEPathExtentsionPDF]) ? [UIImage imageNamed:@"pdf_icon"] : [UIImage imageNamed:@"ppt_icon"];
    
    // accessibility
    cell.accessibilityLabel = cell.itemLabel.text;
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 60.0f;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 22.0f;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    return self.titleArray[section];
}


- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewRowAction *unhideAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault
                                                                            title:NSLocalizedString(@"Löschen", @"Label of the button to delete a document")
                                                                          handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                                                                              
                                                                              NSURL *url = self.tableData[indexPath.section][indexPath.row];
                                                                              if ([self.dataModel deleteDocumentWithURL:url]) {
                                                                                  
                                                                                  [self reloadTableData];

                                                                                  if ([tableView numberOfRowsInSection:indexPath.section] == 1) {

                                                                                      [tableView deleteSections:[[NSIndexSet alloc] initWithIndex:indexPath.section]
                                                                                               withRowAnimation:UITableViewRowAnimationAutomatic];
                                                                                  }
                                                                                  else {
                                                                                      
                                                                                      [self.tableView deleteRowsAtIndexPaths:@[indexPath]
                                                                                                            withRowAnimation:UITableViewRowAnimationRight];
                                                                                  }
                                                                              }
                                                                              
                                                                          }];
    
    unhideAction.backgroundColor = [UIColor moodle_hideActionColor];
    
    return @[unhideAction];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSURL *ressourceURL = self.tableData[indexPath.section][indexPath.row];
    NSString *pathExtension = [ressourceURL pathExtension];
    
    if ([pathExtension isEqualToString:@"pdf"]) {
        
        ReaderDocument *document = [ReaderDocument withDocumentFilePath:ressourceURL.path password:nil];
        
        // Must have a valid ReaderDocument object in order to proceed with things
        if (document) {
            
            ReaderViewController *readerViewController = [[ReaderViewController alloc] initWithReaderDocument:document];
            readerViewController.delegate = self; // Set the ReaderViewController delegate to self
            
            readerViewController.hidesBottomBarWhenPushed = YES;
            
            [self.navigationController pushViewController:readerViewController animated:YES];
        }
        // Log an error so that we know that something went wrong
        else {
            
            NSLog(@"%s [ReaderDocument withDocumentFilePath:'%@' password:'%@'] failed.", __FUNCTION__, ressourceURL.path, nil);
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
            MOODLEURLRessourceViewController *newViewController = (MOODLEURLRessourceViewController *)[storyboard instantiateViewControllerWithIdentifier:@"urlRessourceViewController"];
            newViewController.localRessourceURL = ressourceURL;
            [self.navigationController pushViewController:newViewController animated:YES];
        }
    }
    else {
     
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        MOODLEURLRessourceViewController *newViewController = (MOODLEURLRessourceViewController *)[storyboard instantiateViewControllerWithIdentifier:@"urlRessourceViewController"];
        newViewController.localRessourceURL = ressourceURL;
        [self.navigationController pushViewController:newViewController animated:YES];
    }
}


#pragma mark - ReaderViewControllerDelegate methods

- (void)dismissReaderViewController:(ReaderViewController *)viewController {
    
    [self.navigationController popViewControllerAnimated:YES];
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

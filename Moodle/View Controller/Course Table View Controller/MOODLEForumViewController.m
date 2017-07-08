/*
 *
 *  MOODLEForumViewController.m
 *  Moodle
 *
 *  Copyright © 2017 Simon Gaus. All rights reserved.
 *
 */

#import "MOODLEForumViewController.h"

/* Data Model */
#import "MOODLEDataModel.h"
#import "MOODLECourse.h"
#import "MOODLEForum.h"
#import "MOODLEForumEntry.h"

/* View Controller */
#import "MOODLEForumEntryViewController.h"

/* Tabel View Cell */
#import "MOODLEForumThreadTableViewCell.h"

///-----------------------
/// @name CATEGORIES
///-----------------------



@interface MOODLEForumViewController (/* Private */) <UITableViewDelegate, UITableViewDataSource>

// UI
@property (nonatomic, strong) IBOutlet UITableView *tableView;
// Table View Data
@property (nonatomic, strong) NSArray<NSArray *> *tableData;
@property (nonatomic, strong) NSArray<NSString *> *headerTitleArray;

@end



///-----------------------
/// @name IMPLEMENTATION
///-----------------------



@implementation MOODLEForumViewController
#pragma mark - View Controller Methodes


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    BOOL forum = self.course.forum.hasEntries;
    BOOL announcments = self.course.announcements.hasEntries;
    
    if (forum) {
        
        if (announcments) {
            
            self.tableData = @[self.course.announcements.entries, self.course.forum.entries];
            self.headerTitleArray = @[@"Ankündigungen", @"Forum"];
        }
        else {
            
            self.tableData = @[self.course.forum.entries];
            self.headerTitleArray = @[@"Forum"];
        }
    }
    else if (announcments) {
        
        self.tableData = @[self.course.announcements.entries];
        self.headerTitleArray = @[@"Ankündigungen"];
    }
    else {
        
        self.tableData = @[];
        self.headerTitleArray = @[];
    }
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table View Methodes


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.tableData.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.tableData[section].count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MOODLEForumThreadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MOODLEForumThreadTableViewCellIdentifier
                                                            forIndexPath:indexPath];
    cell.titleLabel.text = ((MOODLEForumEntry *)self.tableData[indexPath.section][indexPath.row]).title;
    cell.authorLabel.text = ((MOODLEForumEntry *)self.tableData[indexPath.section][indexPath.row]).author;
    cell.profileImageView.image = [UIImage imageNamed:@"user_icon"];
    
    NSInteger replies = ((MOODLEForumEntry *)self.tableData[indexPath.section][indexPath.row]).replies;
    NSInteger unread = ((MOODLEForumEntry *)self.tableData[indexPath.section][indexPath.row]).unreadReplies;
    NSString *repliesString = [NSString stringWithFormat:@"%lu/%lu", (long)(replies-unread)+1, (long)replies+1];
    cell.repliesLabel.text = repliesString;
    return cell;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    return self.headerTitleArray[section];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MOODLEForumEntry *entry = self.tableData[indexPath.section][indexPath.row];
    
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    MOODLEForumEntryViewController *newViewController = (MOODLEForumEntryViewController *)[storyboard instantiateViewControllerWithIdentifier:@"forumThreadViewController"];
    newViewController.dataModel = self.course.dataModel;
    newViewController.entry = entry;
    [self.navigationController pushViewController:newViewController animated:YES];
}


#pragma mark -
@end

//
//  MOODLEForumViewController.m
//  Moodle
//
//  Created by Simon Gaus on 29.06.17.
//  Copyright © 2017 Simon Gaus. All rights reserved.
//

#import "MOODLEForumViewController.h"

/* Data Model */
#import "MOODLEDataModel.h"
#import "MOODLECourse.h"
#import "MOODLEForum.h"
#import "MOODLEForumEntry.h"

/* View Controller */
#import "MOODLEForumEntryViewController.h"

///-----------------------
/// @name CATEGORIES
///-----------------------



@interface MOODLEForumViewController (/* Private */) <UITableViewDelegate, UITableViewDataSource>

// UI
@property (nonatomic, strong) IBOutlet UITableView *tableView;
// Table View Data
@property (nonatomic, strong) NSArray<NSArray *> *proxyTableData;
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
            
            self.proxyTableData = @[self.course.announcements.entries, self.course.forum.entries];
            self.headerTitleArray = @[@"Ankündigungen", @"Forum"];
        }
        else {
            
            self.proxyTableData = @[self.course.forum.entries];
            self.headerTitleArray = @[@"Forum"];
        }
    }
    else if (announcments) {
        
        self.proxyTableData = @[self.course.announcements.entries];
        self.headerTitleArray = @[@"Ankündigungen"];
    }
    else {
        
        self.proxyTableData = @[];
        self.headerTitleArray = @[];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table View Methodes


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.proxyTableData.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.proxyTableData[section].count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"forumTableViewCellIdentifier"
                                                            forIndexPath:indexPath];
    cell.textLabel.text = ((MOODLEForumEntry *)self.proxyTableData[indexPath.section][indexPath.row]).title;
    cell.detailTextLabel.text = ((MOODLEForumEntry *)self.proxyTableData[indexPath.section][indexPath.row]).author;
    return cell;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    return self.headerTitleArray[section];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MOODLEForumEntry *entry = self.proxyTableData[indexPath.section][indexPath.row];
    
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    MOODLEForumEntryViewController *newViewController = (MOODLEForumEntryViewController *)[storyboard instantiateViewControllerWithIdentifier:@"forumThreadViewController"];
    newViewController.dataModel = self.course.dataModel;
    newViewController.entry = entry;
    [self.navigationController pushViewController:newViewController animated:YES];
}


#pragma mark -
@end

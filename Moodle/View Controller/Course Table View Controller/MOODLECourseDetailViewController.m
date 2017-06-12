/*
 *  MOODLECourseDetailViewController.m
 *  Moodle
 *
 *  Created by Simon Gaus on 03.06.17.
 *  Copyright © 2017 Simon Gaus. All rights reserved.
 *
 */

#import "MOODLECourseDetailViewController.h"

/* View Controller */
#import "MOODLECourseSectionDetailViewController.h"

/* Data Model */
#import "MOODLEDataModel.h"
#import "MOODLECourse.h"
#import "MOODLECourseSection.h"

/* Table View */
#import "MOODLECourseSectionTableViewCell.h"

/* Custom Views */
#import "MOODLEActivityView.h"

/* Accessibilility */
#import "MOODLELinguisticListFormater.h"

///-----------------------
/// @name CATEGORIES
///-----------------------



@interface MOODLECourseDetailViewController (/* Private */)

// UI
@property (nonatomic, strong) IBOutlet UILabel *courseTitleLabel;
@property (nonatomic, strong) IBOutlet UILabel *moodleTitleLabel;
@property (nonatomic, strong) IBOutlet UILabel *semesterLabel;
@property (nonatomic, strong) IBOutlet UITableView *tableView;

@property (nonatomic, strong) MOODLEActivityView *loadingView;

@end



///-----------------------
/// @name IMPLEMENTATION
///-----------------------



@implementation MOODLECourseDetailViewController
#pragma mark - View Controller Methodes


- (void)viewWillAppear:(BOOL)animated {
    
    // call super
    [super viewWillAppear:animated];

    
    self.courseTitleLabel.text = self.item.courseTitle;
    self.moodleTitleLabel.text = [NSString stringWithFormat:@"Moodle: %@", self.item.moodleTitle];
    self.semesterLabel.text = self.item.semester;
    
    if (!self.item.courseSections) {
        
        // show activity indicator..
        [self.view addSubview:self.loadingView];
        
        // perform web request on background thread ...
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul), ^{
            
            [self.item.dataModel loadItemContentForItem:self.item
                                      completionHandler:^(BOOL success, NSError *error) {
                                          
                                          if (success) { [self finishedContentLoading]; }
                                          else { [self failedToLoadContentWithMessage:error.localizedDescription]; }
                                      }];
        });
    }
    else { [self showTableView]; }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Helper Methodes


- (void)failedToLoadContentWithMessage:(NSString *)message {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSLog(@"failedToLoadContentWithMessage: %@", message);
        [self.loadingView removeFromSuperview];
        self.loadingView = nil;
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


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.item.courseSections.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    MOODLECourseSection *section = [self.item.courseSections objectAtIndex:indexPath.row];
    
    UITableViewCell *returnCell = nil;
    
    if (section.hasContent) {
        
        MOODLECourseSectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MOODLECourseSectionTableViewCellIdentifier];
        
        cell.noContentLabel.hidden = YES;
        
        MOODLELinguisticListFormater *listFormatter = [MOODLELinguisticListFormater new];
        
        if (section.hasDescription) {
            
            cell.descriptionImageView.image = [UIImage imageNamed:@"comment_icon_heigh"];
            
            NSString *locString = NSLocalizedString(@"Beschreibung", @"Appended to accessibility label if course section has a description.");
            [listFormatter addItemToList:locString];
            
        } else {
            
            cell.descriptionImageView.image = [UIImage imageNamed:@"comment_icon_low"];
        }
        
        if (section.hasDocuments || section.hasOhterItems) {
            
            cell.dokumentImageView.image = [UIImage imageNamed:@"doc_icon_heigh"];
            
            NSString *locString = NSLocalizedString(@"Dokumente", @"Appended to accessibility label if course section has documents 1.");
            [listFormatter addItemToList:locString];
            
        } else {
            
            cell.dokumentImageView.image = [UIImage imageNamed:@"doc_icon_low"];
        }
        
        if (section.hasAssignment) {
            
            
            cell.assignmentImageView.image = [UIImage imageNamed:@"assign_icon_blue"];
            
            NSString *locString = NSLocalizedString(@"Abgabe", @"Appended to accessibility label if course section has an assignment.");
            [listFormatter addItemToList:locString];
            
        } else {
            
            cell.assignmentImageView.image = [UIImage imageNamed:@"assign_icon_grey"];
        }
        
        
        // accessibility
        NSString *accesibility_label = section.sectionTitle;
        accesibility_label = [accesibility_label stringByAppendingString:@"\n "]; // make pause after title
        accesibility_label = [accesibility_label stringByAppendingString:listFormatter.list];
        NSString *locString = NSLocalizedString(@" vorhanden", @"Appended to accessibility label.");
        cell.accessibilityLabel = [accesibility_label stringByAppendingString:locString];;
        
        
        cell.sectionTitleLabel.text = section.sectionTitle;
        
        returnCell = cell;
        
    }
    else {
    
        static NSString *noContentCell = @"noContentCell";
        returnCell = [tableView dequeueReusableCellWithIdentifier:noContentCell];
        returnCell.textLabel.text = section.sectionTitle;
        
        // accessibility
        returnCell.accessibilityLabel = section.sectionTitle;
    }

    return returnCell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 80.0f;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    MOODLECourseSectionDetailViewController *newViewController = (MOODLECourseSectionDetailViewController *)[storyboard instantiateViewControllerWithIdentifier:@"courseSectionViewController"];
    newViewController.section = self.item.courseSections[indexPath.row];
    [self.navigationController pushViewController:newViewController animated:YES];
}


#pragma mark - Lazy/Getter


- (UIView *)loadingView {
    
    if (!_loadingView) {
        
        NSString *locString = NSLocalizedString(@"Laden", @"Label of the progress indicator during course content loading.");
        MOODLEActivityView *view = [MOODLEActivityView activityViewWithText:locString];
        view.center = CGPointMake(self.view.center.x, self.view.center.y-self.navigationController.navigationBar.frame.size.height);
        _loadingView = view;
    }
    return _loadingView;
}


#pragma mark -
@end

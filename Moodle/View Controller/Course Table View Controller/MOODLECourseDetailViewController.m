/*
 *  MOODLECourseDetailViewController.m
 *  Moodle
 *
 *  Created by Simon Gaus on 03.06.17.
 *  Copyright © 2017 Simon Gaus. All rights reserved.
 *
 */

#import "MOODLECourseDetailViewController.h"

/* Data Model */
#import "MOODLEDataModel.h"
#import "MOODLECourse.h"
#import "MOODLECourseSection.h"


#import "MOODLECourseSectionDetailViewController.h"
#import "MOODLECourseSectionTableViewCell.h"


@interface MOODLECourseDetailViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) IBOutlet UILabel *courseTitleLabel;
@property (nonatomic, strong) IBOutlet UILabel *moodleTitleLabel;
@property (nonatomic, strong) IBOutlet UILabel *semesterLabel;

@property (nonatomic, strong) UIView *loadingView;

@property (nonatomic, strong) IBOutlet UITableView *tableView;

@end



///-----------------------
/// @name IMPLEMENTATION
///-----------------------



@implementation MOODLECourseDetailViewController
#pragma mark - View Controller Methodes


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillAppear:(BOOL)animated {
    
    // call super
    [super viewWillAppear:animated];
    
    // set nav bar shadow
    [self setupNavigationBar];
    
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


- (void)setupNavigationBar {
    
    UINavigationBar *navBar = self.navigationController.navigationBar;
    navBar.layer.shadowColor = [UIColor blackColor].CGColor;
    navBar.layer.shadowOffset = CGSizeMake(0.0f, 2.0f);
    navBar.layer.shadowOpacity = 0.22f;
    navBar.layer.shadowRadius = 2.0f;
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
        cell.sectionTitleLabel.text = section.sectionTitle;
        
        cell.noContentLabel.hidden = YES;
        
        if (section.hasDescription) {
            
            cell.descriptionImageView.image = [UIImage imageNamed:@"comment_icon_heigh"];
            
        } else {
            
            cell.descriptionImageView.image = [UIImage imageNamed:@"comment_icon_low"];
        }
        
        if (section.hasDocuments || section.hasOhterItems) {
            
            cell.dokumentImageView.image = [UIImage imageNamed:@"doc_icon_heigh"];
            
        } else {
            
            cell.dokumentImageView.image = [UIImage imageNamed:@"doc_icon_low"];
        }
        
        if (section.hasAssignment) {
            
            
            cell.assignmentImageView.image = [UIImage imageNamed:@"assign_icon_blue"];
        } else {
            
            cell.assignmentImageView.image = [UIImage imageNamed:@"assign_icon_grey"];
        }
        
        returnCell = cell;
        
    }
    else {
    
        static NSString *noContentCell = @"noContentCell";
        returnCell = [tableView dequeueReusableCellWithIdentifier:noContentCell];
        returnCell.textLabel.text = section.sectionTitle;
    }

    return returnCell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 80.0f;
}


#pragma mark - Navigation Methodes

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"toSectionDetail"]) {

        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        UINavigationController *destNavController = segue.destinationViewController;
        MOODLECourseSectionDetailViewController *destViewController = destNavController.viewControllers[0];
        destViewController.section = [self.item.courseSections objectAtIndex:indexPath.row];
    }
}


#pragma mark - Lazy/Getter


- (UIView *)loadingView {
    
    if (!_loadingView) {
        
        UIView *loading = [[UIView alloc] initWithFrame:CGRectMake(100, 200, 120, 120)];
        
        loading.layer.cornerRadius = 15;
        loading.opaque = NO;
        loading.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7f];
        
        UILabel *loadLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 25, 90, 22)];
        loadLabel.text = NSLocalizedString(@"Laden", @"Label of the progress indicator during course content loading.");
        loadLabel.font = [UIFont boldSystemFontOfSize:18.0f];
        loadLabel.textAlignment = NSTextAlignmentCenter;
        loadLabel.textColor = [UIColor whiteColor];
        loadLabel.backgroundColor = [UIColor clearColor];
        [loadLabel setCenter:CGPointMake(loading.frame.size.width/2.0f, loading.frame.size.height*0.8f)];
        
        [loading addSubview:loadLabel];
        
        UIActivityIndicatorView *spinning = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        spinning.frame = CGRectMake(42, 54, 37, 37);
        [spinning startAnimating];
        [spinning setCenter:CGPointMake(loading.frame.size.width/2.0f, loading.frame.size.height*0.45f)];
        [loading addSubview:spinning];
        
        //loading.frame = CGRectMake(100, 200, 120, 120);
        [loading setCenter:CGPointMake(self.view.frame.size.width/2.0f, self.view.frame.size.height/2.0f)];
        
        _loadingView = loading;
    }
    return _loadingView;
}


#pragma mark -
@end

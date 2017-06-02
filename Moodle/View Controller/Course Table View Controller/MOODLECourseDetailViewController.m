/*
 *  MOODLECourseDetailViewController.m
 *  MOODLE
 *
 *  Copyright © 2017 Simon Gaus <simon.cay.gaus@gmail.com>
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU Lesser General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU Lesser General Public License for more details.
 *
 *  You should have received a copy of the GNU Lesser General Public License
 *  along with this programm.  If not, see <http://www.gnu.org/licenses/>.
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
            
            [self.item.dataModel loadItemContentForItem:self.item completionBlock:^(BOOL success, NSError *error) {
                
                if (success) { [self finishedContentLoading]; }
                else { [self failedToLoadContentWithMessage:error.localizedDescription]; }
            }];
        });
    }
    else { [self showTableView]; }
}

- (void)failedToLoadContentWithMessage:(NSString *)message {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSLog(@"message: %@", message);
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

#pragma mark - Table View Delegate Methodes

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.item.courseSections.count;
}

#pragma mark - Table View Data Source Methodes

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
        loading.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.7f];
        
        UILabel *loadLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 25, 90, 22)];
        loadLabel.text = @"Laden";
        loadLabel.font = [UIFont boldSystemFontOfSize:18.0f];
        loadLabel.textAlignment = NSTextAlignmentCenter;
        loadLabel.textColor = [UIColor colorWithWhite:1.0f alpha:1.0f];
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

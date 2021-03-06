/*
 *
 *  MOODLESearchItemDetailViewController.m
 *  Moodle
 *
 *  Copyright © 2017 Simon Gaus. All rights reserved.
 *
 */

#import "MOODLESearchItemDetailViewController.h"

/* Data Model */
#import "MOODLECourse.h"

/* View Controller */
#import "MOODLEDocumentViewController.h"

///-----------------------
/// @name CATEGORIES
///-----------------------



@interface MOODLESearchItemDetailViewController (/* Private */)

// UI
@property (nonatomic, strong) IBOutlet UILabel *sectionTitleLabel;
@property (nonatomic, strong) IBOutlet UILabel *semesterLabel;
@property (nonatomic, strong) IBOutlet UILabel *categoryLabel;
@property (nonatomic, strong) IBOutlet UITextView *textView;
@property (nonatomic, strong) IBOutlet UITableView *tableView;

// Constraints
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *tableViewHeightConstraint;

@end



///-----------------------
/// @name IMPLEMENTATION
///-----------------------



@implementation MOODLESearchItemDetailViewController
#pragma mark - View Controller Methodes


- (void)viewWillAppear:(BOOL)animated {
    
    // call super
    [super viewWillAppear:animated];
    
    if (self.item.canSubscribe) {
        
        
        NSString *locString = NSLocalizedString(@"Einschreiben", @"Title of the subscription nav bar item");
        UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:locString
                                                                          style:UIBarButtonItemStylePlain
                                                                         target:self
                                                                         action:@selector(subscribe:)];
        self.navigationItem.rightBarButtonItem = anotherButton;
    }
    
    
    self.sectionTitleLabel.text = self.item.courseTitle;
    self.semesterLabel.text = self.item.semester;
    NSString *locString = NSLocalizedString(@"Kursbereich: %@", @"Label indicating the assoziated department of a moodle course.");
    self.categoryLabel.text = (self.item.courseCategory) ? [NSString stringWithFormat:locString, self.item.courseCategory] : nil;
    

    CGFloat height = self.item.teacher.count*20.0f;
    self.tableViewHeightConstraint.constant = (height > 80.0f) ? 80.0f : height;
    [self.tableView reloadData];
    self.textView.attributedText = self.item.attributedCourseDescription;
}


- (BOOL)shouldAutorotate {
    
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    BOOL rotate = !UIInterfaceOrientationIsPortrait(interfaceOrientation);
    return rotate;
}


- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}


- (void)viewDidLayoutSubviews {
    // set content offset after the text view is properly sized
    [self.textView setContentOffset:CGPointZero animated:NO];
}


#pragma mark - Table View Methodes


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *teacherCellIdentifier = @"teacherCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:teacherCellIdentifier];
    NSString *item = self.item.teacher[indexPath.row];
    NSString *locString = NSLocalizedString(@"Kursverantwortliche/r: %@", @"Label indicating the teacher of a moodle course.");
    cell.textLabel.text = [NSString stringWithFormat:locString, item];
    return cell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.item.teacher.count;
}

#pragma mark - IBActions


- (IBAction)subscribe:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    MOODLEDocumentViewController *newViewController = (MOODLEDocumentViewController *)[storyboard instantiateViewControllerWithIdentifier:@"enrollmentViewController"];
    newViewController.item = self.item.url;
    [self.navigationController pushViewController:newViewController animated:YES];
}


#pragma mark -
@end

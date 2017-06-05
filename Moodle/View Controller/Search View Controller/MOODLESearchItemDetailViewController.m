/*
 *  MOODLESearchItemDetailViewController.m
 *  Moodle
 *
 *  Created by Simon Gaus on 03.06.17.
 *  Copyright © 2017 Simon Gaus. All rights reserved.
 *
 */

/* Header */
#import "MOODLESearchItemDetailViewController.h"

/* Data Model */
#import "MOODLESearchItem.h"

/* View Controller */
#import "MOODLEDocumentViewController.h"

@interface MOODLESearchItemDetailViewController (/* Private */)<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) IBOutlet UILabel *sectionTitleLabel;
@property (nonatomic, strong) IBOutlet UILabel *semesterLabel;
@property (nonatomic, strong) IBOutlet UILabel *categoryLabel;
@property (nonatomic, strong) IBOutlet UITextView *textView;
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet UIButton *subscribeButton;

@property (nonatomic, strong) IBOutlet NSLayoutConstraint *subscriptionButtonHeightConstraint;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *tableViewHeightConstraint;

@end



///-----------------------
/// @name IMPLEMENTATION
///-----------------------



@implementation MOODLESearchItemDetailViewController
#pragma mark - View Controller Methodes


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (void)viewWillAppear:(BOOL)animated {
    
    // call super
    [super viewWillAppear:animated];
    
    self.sectionTitleLabel.text = self.item.title;
    self.semesterLabel.text = self.item.semester;
    NSString *locString = NSLocalizedString(@"Kursbereich: %@", @"Label indicating the assoziated department of a moodle course.");
    self.categoryLabel.text = (self.item.courseCategory) ? [NSString stringWithFormat:locString, self.item.courseCategory] : nil;
    
    self.subscriptionButtonHeightConstraint.constant = (self.item.canSubscribe) ? 44.0f : 0.0f;
    self.subscribeButton.hidden = !self.item.canSubscribe;

    CGFloat height = self.item.teacher.count*20.0f;
    self.tableViewHeightConstraint.constant = (height > 80.0f) ? 80.0f : height;
    [self.tableView reloadData];
    
    NSMutableAttributedString *attributedString = self.item.attributedCourseDescription;
    [attributedString addAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:17.0f]} range:NSMakeRange(0, attributedString.length)];
    
    self.textView.attributedText = attributedString;
    [self.textView layoutIfNeeded];
    self.textView.contentOffset = CGPointMake(0.0f, 0.0f);
}


#pragma mark - Table View


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


#pragma mark - Navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"toSubscribeSegue"]) {

        MOODLEDocumentViewController *destViewController = (MOODLEDocumentViewController *)segue.destinationViewController;
        destViewController.resourceURL = self.item.courseURL;
    }
}


#pragma mark -
@end

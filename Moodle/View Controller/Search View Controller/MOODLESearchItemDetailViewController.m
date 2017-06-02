/*
 *  MOODLESearchItemDetailViewController.m
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

#import "MOODLESearchItemDetailViewController.h"

#import "MOODLESearchItem.h"
#import "MOODLEDocumentViewController.h"

@interface MOODLESearchItemDetailViewController ()<UITableViewDelegate, UITableViewDataSource>

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
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithData: [self.item.courseDescription dataUsingEncoding:NSUnicodeStringEncoding]
                                                                                          options: @{ NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType }
                                                                               documentAttributes: nil
                                                                                            error: nil];
    
    [attributedString addAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:17.0f]} range:NSMakeRange(0, attributedString.length)];
    [attributedString addAttributes:@{NSStrokeColorAttributeName: [UIColor blackColor]} range:NSMakeRange(0, attributedString.length)];
    [attributedString addAttributes:@{NSForegroundColorAttributeName: [UIColor blackColor]} range:NSMakeRange(0, attributedString.length)];
    
    
    [self.textView setAttributedText:attributedString];
    [self.textView layoutIfNeeded];
    [self.textView setContentOffset:CGPointMake(0, 0)];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"toSubscribeSegue"]) {

        MOODLEDocumentViewController *destViewController = (MOODLEDocumentViewController *)segue.destinationViewController;
        destViewController.resourceURL = self.item.courseURL;
    }
}

@end

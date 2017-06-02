/*
 *  MOODLECourseViewController.m
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

/* Controller */
#import "MOODLETabBarController.h"
#import "MOODLECourseViewController.h"
#import "MOODLECourseDetailViewController.h"

/* Data Model */
#import "MOODLEDataModel.h"
#import "MOODLECourse.h"

/* Table View */
#import "MOODLECourseTableViewCell.h"
#import "MOODLETableViewRowAction.h"

@interface MOODLECourseViewController (/* Private */)

@property (nonatomic, strong) MOODLEDataModel *dataModel;
@property (nonnull, strong) IBOutlet UITableView *tableView;

@end



///-----------------------
/// @name IMPLEMENTATION
///-----------------------



@implementation MOODLECourseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // add long press gesture recognizer
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                            action:@selector(longPressGestureRecognized:)];
    [self.tableView addGestureRecognizer:longPress];
}

- (void)viewDidAppear:(BOOL)animated {
    
    // call super
    [super viewDidAppear:animated];

    // reload data
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table View Reordering Methodes

- (IBAction)longPressGestureRecognized:(id)sender {
    
    UILongPressGestureRecognizer *longPress = (UILongPressGestureRecognizer *)sender;
    UIGestureRecognizerState state = longPress.state;
    
    CGPoint location = [longPress locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];
    
    static UIView       *snapshot = nil;        ///< A snapshot of the row user is moving.
    static NSIndexPath  *sourceIndexPath = nil; ///< Initial index path, where gesture begins.
    
    switch (state) {
        case UIGestureRecognizerStateBegan: {
            if (indexPath) {
                sourceIndexPath = indexPath;
                
                UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
                
                // Take a snapshot of the selected row using helper method.
                snapshot = [self customSnapshotFromView:cell];
                
                // Add the snapshot as subview, centered at cell's center...
                __block CGPoint center = cell.center;
                snapshot.center = center;
                snapshot.alpha = 0.0;
                [self.tableView addSubview:snapshot];
                [UIView animateWithDuration:0.25 animations:^{
                    
                    // Offset for gesture location.
                    center.y = location.y;
                    snapshot.center = center;
                    snapshot.transform = CGAffineTransformMakeScale(1.05, 1.05);
                    snapshot.alpha = 0.98;
                    
                    // Fade out.
                    cell.alpha = 0.0;
                    
                } completion:^(BOOL finished) {
                    
                    cell.hidden = YES;
                    
                }];
            }
            break;
        }
            
        case UIGestureRecognizerStateChanged: {
            CGPoint center = snapshot.center;
            center.y = location.y;
            snapshot.center = center;
            
            // Is destination valid and is it different from source?
            if (indexPath && ![indexPath isEqual:sourceIndexPath]) {
                
                // ... update data source.
                [self.dataModel.courseArray exchangeObjectAtIndex:indexPath.row
                                                withObjectAtIndex:sourceIndexPath.row];
                
                // ... move the rows. Check for sourceIndexPath because of analyzer warning.
                if (sourceIndexPath) [self.tableView moveRowAtIndexPath:sourceIndexPath toIndexPath:indexPath];
                
                // ... and update source so it is in sync with UI changes.
                sourceIndexPath = indexPath;
            }
            break;
        }
            
        default: {
            
            // Check for sourceIndexPath because of analyzer warning.
            if (sourceIndexPath) {
                // Clean up.
                UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:sourceIndexPath];
                cell.hidden = NO;
                cell.alpha = 0.0;
                [UIView animateWithDuration:0.25 animations:^{
                    
                    snapshot.center = cell.center;
                    snapshot.transform = CGAffineTransformIdentity;
                    snapshot.alpha = 0.0;
                    
                    // Undo fade out.
                    cell.alpha = 1.0;
                    
                } completion:^(BOOL finished) {
                    
                    sourceIndexPath = nil;
                    [snapshot removeFromSuperview];
                    snapshot = nil;
                    
                }];
            }
            [self.dataModel updateCourseItemsOrderingWeight];
            break;
        }
    }
}

- (UIView *)customSnapshotFromView:(UIView *)inputView {
    
    // Make an image from the input view.
    UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, NO, 0);
    [inputView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // Create an image view.
    UIView *snapshot = [[UIImageView alloc] initWithImage:image];
    snapshot.layer.masksToBounds = NO;
    snapshot.layer.cornerRadius = 0.0;
    snapshot.layer.shadowOffset = CGSizeMake(-5.0, 0.0);
    snapshot.layer.shadowRadius = 5.0;
    snapshot.layer.shadowOpacity = 0.4;
    
    return snapshot;
}

#pragma mark - Table View Methodes
 
- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MOODLECourse *item = self.dataModel.courseArray[indexPath.row];
    
    MOODLETableViewRowAction *hideAction = [MOODLETableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault
                                                                                  title:NSLocalizedString(@"Verbergen", @"Button label to hide moodle course.")
                                                                                   icon:[UIImage imageNamed:@"hide_icon"]
                                                                                handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                                                                                    
                                                                                    item.isHidden = YES;
                                                                                    
                                                                                    [tableView deleteRowsAtIndexPaths:@[indexPath]
                                                                                                     withRowAnimation:UITableViewRowAnimationAutomatic];
                                                                                }];
    
    hideAction.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
    hideAction.backgroundColor = [UIColor colorWithRed:(231.0f/255.0f)
                                                 green:(76.0f/255.0f)
                                                  blue:(60.0f/255.0f)
                                                 alpha:1.0f];
    
    MOODLETableViewRowAction *favoriteAction = [MOODLETableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault
                                                                                      title:NSLocalizedString(@"Favorisieren", @"Button label to favorite moodle course.")
                                                                                       icon:(item.isFavourite) ? [UIImage imageNamed:@"starred_on"] : [UIImage imageNamed:@"starred_off"]
                                                                                    handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {

                                                                                        item.isFavourite = !item.isFavourite;
                                                                                        
                                                                                        [self.tableView reloadRowsAtIndexPaths:@[indexPath]
                                                                                                              withRowAnimation:UITableViewRowAnimationFade];

                                                                                    }];
    favoriteAction.iconAndLabelColor = [UIColor blackColor];
    favoriteAction.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
    favoriteAction.backgroundColor = [UIColor colorWithRed:(189.0f/255.0f)
                                                     green:(195.0f/255.0f)
                                                      blue:(199.0f/255.0f)
                                                     alpha:1.0f];

    return @[hideAction, favoriteAction];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    MOODLECourse *item = self.dataModel.courseArray[indexPath.row];;

    MOODLECourseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MOODLECourseTableViewCellIdentifier];
    cell.courseTitleLabel.text = item.courseTitle;
    cell.moodleTitleLabel.text = [NSString stringWithFormat:@"Moodle: %@", item.moodleTitle];
    cell.semesterLabel.text = item.semester;
    cell.backgroundColor = (item.isFavourite) ? [UIColor colorWithRed:(3.0f/255.0f)
                                                                green:(102.0f/255.0f)
                                                                 blue:(148.0f/255.0f)
                                                                alpha:0.2f] : [UIColor whiteColor];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataModel.courseArray.count;
}

#pragma mark - Lazy/Getter Methodes

- (MOODLEDataModel *)dataModel {
    
    return [MOODLEDataModel sharedDataModel];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        MOODLECourse *item = self.dataModel.courseArray[indexPath.row];
        MOODLECourseDetailViewController *controller = (MOODLECourseDetailViewController *)[[segue destinationViewController] topViewController];
        controller.item = item;
    }
}

#pragma mark -
@end

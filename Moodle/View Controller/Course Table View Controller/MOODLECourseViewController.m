/*
 *
 *  MOODLECourseViewController.m
 *  Moodle
 *
 *  Copyright © 2017 Simon Gaus. All rights reserved.
 *
 */

#import "MOODLECourseViewController.h"

/* Controller */
#import "MOODLETabBarController.h"
#import "MOODLECourseDetailViewController.h"
#import "MOODLECourseSearchViewController.h"

/* Data Model */
#import "MOODLEDataModel.h"
#import "MOODLECourse.h"

/* Table View */
#import "MOODLECourseTableViewCell.h"
#import "MOODLETableViewRowAction.h"

/* Colors */
#import "UIColor+Moodle.h"

///-----------------------
/// @name CATEGORIES
///-----------------------



@interface MOODLECourseViewController (/* Private */)

@property (nonatomic, strong) MOODLEDataModel *dataModel;

@end



///-----------------------
/// @name IMPLEMENTATION
///-----------------------



@implementation MOODLECourseViewController
#pragma mark - View Controller Methodes


- (void)viewDidLoad {
    // call super
    [super viewDidLoad];
    
    // add long press gesture recognizer
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                            action:@selector(longPressGestureRecognized:)];
    [self.tableView addGestureRecognizer:longPress];

    UIBarButtonItem *searchButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Suche", @"title of the search button")
                                                                     style:UIBarButtonItemStylePlain
                                                                    target:self
                                                                    action:@selector(search:)];
    searchButton.image = [UIImage imageNamed:@"search_icon"];
    self.navigationItem.rightBarButtonItem = searchButton;
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
    hideAction.backgroundColor = [UIColor moodle_hideActionColor];
    
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
    favoriteAction.backgroundColor = [UIColor moodle_favoriteActionColor];

    return @[hideAction, favoriteAction];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    MOODLECourse *item = self.dataModel.courseArray[indexPath.row];;

    MOODLECourseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MOODLECourseTableViewCellIdentifier];
    cell.courseTitleLabel.text = item.courseTitle;
    cell.moodleTitleLabel.text = [NSString stringWithFormat:@"Moodle: %@", item.moodleTitle];
    cell.semesterLabel.text = item.semester;
    cell.backgroundColor = (item.isFavourite) ? [[UIColor moodle_blueColor] colorWithAlphaComponent:0.2f] : [UIColor whiteColor];
    
    // accessibility
    // dont read moodle course id and speack with a pause
    cell.accessibilityLabel = [NSString stringWithFormat:@"%@\n%@", item.courseTitle, item.semester];
    
    return cell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataModel.courseArray.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 76.0f;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    MOODLECourseDetailViewController *newViewController = (MOODLECourseDetailViewController *)[storyboard instantiateViewControllerWithIdentifier:@"courseDetailViewController"];
    MOODLECourse *item = self.dataModel.courseArray[indexPath.row];
    newViewController.item = item;
    [self.navigationController pushViewController:newViewController animated:YES];
}


#pragma mark - Search Result Updating


- (IBAction)search:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    MOODLECourseSearchViewController *searchViewController = (MOODLECourseSearchViewController *)[storyboard instantiateViewControllerWithIdentifier:@"MOODLECourseSearchViewController"];
    [self.navigationController pushViewController:searchViewController animated:YES];
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

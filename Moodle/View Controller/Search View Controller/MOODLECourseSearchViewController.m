/*
 *  MOODLECourseSearchViewController.m
 *  Moodle
 *
 *  Created by Simon Gaus on 03.06.17.
 *  Copyright © 2017 Simon Gaus. All rights reserved.
 *
 */

#import "MOODLECourseSearchViewController.h"

/* Data Model */
#import "MOODLEDataModel.h"
#import "MOODLESearchItem.h"

/* View Controller */
#import "MOODLETabBarController.h"
#import "MOODLESearchItemDetailViewController.h"

/* Table View */
#import "MOODLESearchResultTableViewCell.h"

/* Custom Views */
#import "MOODLEActivityView.h"

///-----------------------
/// @name CATEGORIES
///-----------------------



@interface MOODLECourseSearchViewController (/* Private */)

// UI
@property (nonatomic, strong) MOODLEActivityView *loadingView;
@property (nonatomic, strong) IBOutlet UISearchBar *searchBar;

// Table View
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray<MOODLESearchItem *> *resultArray;
@property (nonatomic, readwrite) BOOL hasContent;

// Navigation
@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;

// Data Model
@property (nonatomic, strong) MOODLEDataModel *dataModel;

@end



///-----------------------
/// @name IMPLEMENTATION
///-----------------------



@implementation MOODLECourseSearchViewController
#pragma mark - View Controller Methodes


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.hasContent = NO;
    _resultArray = @[];
    self.tableView.hidden = YES;
    
    // Add tap gesture recogniszer (for dismissing keyboard)
    self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:self.tapGestureRecognizer];
}


- (void)viewDidAppear:(BOOL)animated {
    
    // call super
    [super viewDidAppear:animated];
    
    [self.searchBar resignFirstResponder];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Keyboard Methodes


- (void)dismissKeyboard {
    
    [self.searchBar resignFirstResponder];
}


#pragma mark - Search Related Methodes


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];

    searchBar.userInteractionEnabled = NO;
    NSString *searchString = searchBar.text;
    if (searchString.length > 0) {
        
        [self.view addSubview:self.loadingView];
        
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul);
        dispatch_async(queue, ^{
            
            [self.dataModel loadSearchResultWithSerachString:searchString
                                           completionHandler:^(BOOL success, NSError * _Nullable error, NSArray * _Nullable searchResults) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if (success) {
                        
                        [self searchSucceededWithResult:searchResults];
                    }
                    else {
                        
                        [self searchFailedForSearch:searchString];
                    }

                });
            }];
        });
    }
    else {
        
        searchBar.userInteractionEnabled = YES;
    }
}


- (void)searchFailedForSearch:(NSString *)searchString {
    
    [self.loadingView removeFromSuperview];
    self.loadingView = nil;
    
    self.hasContent = NO;
    MOODLESearchItem *item = [[MOODLESearchItem alloc] init];
    NSString *locString = NSLocalizedString(@"Keine Kurse mit dem Begriff '%@' gefunden.", @"Message if course search yields no results.");
    item.title = [NSString stringWithFormat:locString, searchString];
    self.resultArray = @[item];
    self.tableView.hidden = NO;
    [self.tableView reloadData];
    
    self.searchBar.userInteractionEnabled = YES;
}


- (void)searchSucceededWithResult:(NSArray *)resutlArray {
    
    [self.loadingView removeFromSuperview];
    self.loadingView = nil;
    
    [self.view removeGestureRecognizer:self.tapGestureRecognizer];
    self.hasContent = YES;
    self.resultArray = resutlArray;
    self.tableView.hidden = NO;
    [self.tableView reloadData];
    
    self.searchBar.userInteractionEnabled = YES;
}


#pragma mark - Table View Methodes


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.resultArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *noResultCellIdentifier = @"noResultCell";
    
    UITableViewCell *cell = nil;
    
    if (self.hasContent) {
        
        cell = [tableView dequeueReusableCellWithIdentifier:MOODLESearchResultTableViewCellIdentifier];
        MOODLESearchItem *item = self.resultArray[indexPath.row];
        ((MOODLESearchResultTableViewCell *)cell).titleLabel.text = item.title;
        ((MOODLESearchResultTableViewCell *)cell).subscribeImageIcon.image = (item.canSubscribe) ? [UIImage imageNamed:@"subscribe_possible_icon"] : [UIImage imageNamed:@"subscribe_not_possible_icon"];
    }
    else {
        
        cell = [tableView dequeueReusableCellWithIdentifier:noResultCellIdentifier];
        MOODLESearchItem *item = self.resultArray[indexPath.row];
        cell.textLabel.text = item.title;
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    MOODLESearchItemDetailViewController *newViewController = (MOODLESearchItemDetailViewController *)[storyboard instantiateViewControllerWithIdentifier:@"MOODLESearchItemDetailViewController"];
    MOODLESearchItem *item = self.resultArray[indexPath.row];
    newViewController.item = item;
    [self.navigationController pushViewController:newViewController animated:YES];
}

#pragma mark - Lazy/Getter


- (MOODLEDataModel *)dataModel {
    
    if (!_dataModel) {
        
        _dataModel = [MOODLEDataModel sharedDataModel];
    }
    return _dataModel;
}


- (MOODLEActivityView *)loadingView {
    
    if (!_loadingView) {
        
        NSString *locString = NSLocalizedString(@"Suche", @"Message the activity indicator is showing during a course search");
        MOODLEActivityView *view = [MOODLEActivityView activityViewWithText:locString];
        view.center = CGPointMake(self.view.center.x, self.view.center.y-self.navigationController.navigationBar.frame.size.height);
        _loadingView = view;
    }
    return _loadingView;
}

#pragma mark -
@end

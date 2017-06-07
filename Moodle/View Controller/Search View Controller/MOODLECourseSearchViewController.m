/*
 *  MOODLECourseSearchViewController.m
 *  Moodle
 *
 *  Created by Simon Gaus on 03.06.17.
 *  Copyright © 2017 Simon Gaus. All rights reserved.
 *
 */

#import "MOODLECourseSearchViewController.h"

#import "NSURLRequest+Moodle.h"
#import "MOODLEDataModel.h"
#import "MOODLESearchItem.h"
#import "MOODLETabBarController.h"
#import "MOODLESearchItemDetailViewController.h"
#import "MOODLESearchResultTableViewCell.h"
#import "MOODLEActivityView.h"

@interface MOODLECourseSearchViewController ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (nonatomic, strong) MOODLEDataModel *dataModel;

@property (nonatomic, readwrite) BOOL hasContent;

@property (nonatomic, strong) MOODLEActivityView *loadingView;

@property (nonatomic, strong) IBOutlet UISearchBar *searchBar;

/* Table View */
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray<MOODLESearchItem *> *resultArray;

/* Navigation */
@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;

@end



///-----------------------
/// @name IMPLEMENTATION
///-----------------------



@implementation MOODLECourseSearchViewController

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

-(void)dismissKeyboard {
    
    [self.searchBar resignFirstResponder];
}

- (void)viewDidAppear:(BOOL)animated {
    
    // call super
    [super viewDidAppear:animated];

    [self.searchBar resignFirstResponder];
}

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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"showSearchDetail"]) {
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        MOODLESearchItemDetailViewController *destViewController = (MOODLESearchItemDetailViewController *)[[segue destinationViewController] topViewController];
        MOODLESearchItem *item = self.resultArray[indexPath.row];
        destViewController.item = item;
    }
}


@end

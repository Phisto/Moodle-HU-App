/*
 *  MOODLECourseSearchViewController.m
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

#import "MOODLECourseSearchViewController.h"

#import "NSURLRequest+Moodle.h"
#import "MOODLEDataModel.h"
#import "MOODLESearchItem.h"
#import "MOODLETabBarController.h"
#import "MOODLESearchItemDetailViewController.h"
#import "MOODLESearchResultTableViewCell.h"

@interface MOODLECourseSearchViewController ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (nonatomic, readonly) MOODLEDataModel *dataModel;

@property (nonatomic, readwrite) BOOL hasContent;

@property (nonatomic, strong) UIView *loadingView;

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
    
    return [MOODLEDataModel sharedDataModel];
}

- (UIView *)loadingView {
    
    if (!_loadingView) {
        
        UIView *loading = [[UIView alloc] initWithFrame:CGRectMake(100, 200, 120, 120)];
        
        loading.layer.cornerRadius = 15;
        loading.opaque = NO;
        loading.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.7f];
        
        UILabel *loadLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 25, 90, 22)];
        loadLabel.text = NSLocalizedString(@"Suche", @"Message the activity indicator is showing during a course search");
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

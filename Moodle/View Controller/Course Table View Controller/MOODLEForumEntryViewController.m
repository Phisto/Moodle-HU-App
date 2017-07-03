//
//  MOODLEForumEntryViewController.m
//  Moodle
//
//  Created by Simon Gaus on 30.06.17.
//  Copyright © 2017 Simon Gaus. All rights reserved.
//

#import "MOODLEForumEntryViewController.h"

/* Custom Views */
#import "MOODLEActivityView.h"

/* View Controller */
#import "MOODLEDocumentViewController.h"

/* Data Model */
#import "MOODLEDataModel.h"
#import "MOODLEForumEntry.h"
#import "MOODLEForumPost.h"
#import "MOODLECourseSectionItem.h"

/* Table View Cell */
#import "MOODLEForumPostTableViewCell.h"

///-----------------------
/// @name CATEGORIES
///-----------------------



@interface MOODLEForumEntryViewController (/* Private */) <UITableViewDelegate, UITableViewDataSource>

// UI
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) MOODLEActivityView *loadingView;


// Other
@property (nonatomic, strong) IBOutlet UITextView *heightCalculationTextView;

@end



///-----------------------
/// @name IMPLEMENTATION
///-----------------------



@implementation MOODLEForumEntryViewController
#pragma mark - View Controller Methodes


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.tableView.hidden = YES;
    [self.view addSubview:self.loadingView];
    
    if (!self.entry.posts) {
        
        // perform web request on background thread ...
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul), ^{
            
            [self.dataModel loadForumEntryContentForEntry:self.entry
                                               completionHandler:^(BOOL erfolg, NSError * _Nullable error) {
                                                   
                                                   [self showTableView];
                                               }];
        });
    }
    else {
        
        [self showTableView];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Helper Methodes


- (void)showTableView {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.tableView.hidden = NO;
        [self.loadingView removeFromSuperview];
        self.loadingView = nil;
        
        [self.tableView reloadData];
    });
}


#pragma mark - Tabel View Methodes


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    MOODLEForumPost *post = self.entry.posts[indexPath.row];
    MOODLEForumPostTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MOODLEForumPostTableViewCellIdentifier
                                                                         forIndexPath:indexPath];
    cell.authorLabel.text = post.author;
    cell.titleLabel.text = post.title;
    cell.textView.attributedText = post.content;
    cell.opLabel.hidden = !post.isOP;
    cell.postRankLabel.text = [NSString stringWithFormat:@"#%lu", indexPath.row+1];
    cell.profileImageView.image = [UIImage imageNamed:@"user_icon"];
    
    
    if (post.hasAttachments) {
        
        cell.ressourceContainerView.hidden = NO;
        cell.ressourceContainerHeightConstraint.constant = 44.0f;
        cell.ressourceTitleLabel.text = post.attachments.firstObject.resourceTitle;
        cell.ressourceIconImageView.image = (post.attachments.firstObject.itemType == MoodleDocumentTypePDF) ? [UIImage imageNamed:@"pdf_icon"] : [UIImage imageNamed:@"other_file_icon"];
        cell.userInteractionEnabled = YES;
        
    }
    else {
    
        cell.ressourceContainerHeightConstraint.constant = 0.0f;
        cell.ressourceContainerView.hidden = YES;
        cell.userInteractionEnabled = NO;
    }
    
    
    
    return cell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.entry.posts.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MOODLEForumPost *post = self.entry.posts[indexPath.row];
    
    CGFloat height = [self textViewHeightForAttributedText:post.content
                                                  andWidth:tableView.frame.size.width];
    
    return height+84.0f;
}


- (CGFloat)textViewHeightForAttributedText:(NSAttributedString*)text andWidth:(CGFloat)width {
    
    [self.heightCalculationTextView setAttributedText:text];
    CGSize size = [self.heightCalculationTextView sizeThatFits:CGSizeMake(width, FLT_MAX)];
    
    return size.height;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    MOODLEDocumentViewController *newViewController = (MOODLEDocumentViewController *)[storyboard instantiateViewControllerWithIdentifier:@"forumItemViewController"];
    MOODLEForumPost *post = self.entry.posts[indexPath.row];
    MOODLECourseSectionItem *item = post.attachments.firstObject;
    newViewController.item = item;
    [self.navigationController pushViewController:newViewController animated:YES];
}


- (UITextView *)heightCalculationTextView {
    
    if (!_heightCalculationTextView) {
        
        _heightCalculationTextView = [[UITextView alloc] init];
    }
    return _heightCalculationTextView;
}


#pragma mark - Lazy/Getter


- (MOODLEActivityView *)loadingView {
    
    if (!_loadingView) {
    
        MOODLEActivityView *view = [MOODLEActivityView activityView];
        view.center = self.view.center;
        _loadingView = view;
    }
    return _loadingView;
}


#pragma mark -
@end

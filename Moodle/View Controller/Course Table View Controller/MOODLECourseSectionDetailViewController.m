/*
 *  MOODLECourseSectionDetailViewController.m
 *  Moodle
 *
 *  Created by Simon Gaus on 03.06.17.
 *  Copyright © 2017 Simon Gaus. All rights reserved.
 *
 */


/* Header */
#import "MOODLECourseSectionDetailViewController.h"

/* View Controller */
#import "MOODLEDocumentViewController.h"

/* Table View */
#import "MOODLECommentTableViewCell.h"
#import "MOODLECourseSectionItemTableViewCell.h"

/* Data Model */
#import "MOODLECourseSection.h"
#import "MOODLECourseSectionItem.h"



@interface MOODLECourseSectionDetailViewController (/* Private */) <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) IBOutlet UILabel *sectionTitleLabel;
@property (nonatomic, strong) IBOutlet UITextView *textView;
@property (nonatomic, strong) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray<NSString *> *tableViewSegmentTitles;
@property (nonatomic, strong) NSArray<NSArray<MOODLECourseSectionItem *> *> *tableViewSegments;

@property (nonatomic, strong) IBOutlet NSLayoutConstraint *textViewHeight;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *seperatorHeigthOneContraint;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *seperatorHeigthTwoContraint;

@property (nonatomic, strong) IBOutlet UITextView *heightCalculationTextView;

@end



///-----------------------
/// @name IMPLEMENTATION
///-----------------------



@implementation MOODLECourseSectionDetailViewController
#pragma mark - View Controller Methodes


- (void)viewDidLoad {
    // call super
    [super viewDidLoad];

    // set up shadow nav bar
    [self setupNavigationBar];
    
    // table view inset
    self.tableView.contentInset = UIEdgeInsetsMake(22.0f, 0.0f, 0.0f, 0.0f);
    
    
    NSArray *doc = self.section.documentItemArray;
    NSArray *assign = self.section.assignmentsItemArray;
    NSArray *wiki = self.section.wikisItemArray;
    NSArray *other = self.section.otherItemArray;

    NSMutableArray *titles = [NSMutableArray array];
    NSMutableArray *array = [NSMutableArray array];
    if (doc) {
        [array addObject:doc];
        [titles addObject:NSLocalizedString(@"Dokumente", @"Section title for document items.")];
    }
    if (assign) {
        [array addObject:assign];
        [titles addObject:NSLocalizedString(@"Abgaben", @"Section title for assignment items.")];
    }
    if (wiki) {
        [array addObject:wiki];
        [titles addObject:NSLocalizedString(@"Wiki", @"Section title for wiki items.")];
    }
    if (other) {
        [array addObject:other];
        [titles addObject:NSLocalizedString(@"Anderes", @"Section title for other items.")];
    }
    _tableViewSegments = [array copy];
    _tableViewSegmentTitles = [titles copy];
}


- (void)viewWillAppear:(BOOL)animated {
    
    // call super
    [super viewWillAppear:animated];
    
    // set title
    self.sectionTitleLabel.text = self.section.sectionTitle;

    // set/calculate contraints
    NSMutableAttributedString *attributedString = self.section.attributedSectionDescription;
    [attributedString addAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:17.0f]} range:NSMakeRange(0, attributedString.length)];
    CGFloat height = [self textViewHeightForAttributedText:attributedString
                                                  andWidth:self.view.frame.size.width-30.0f];
    [self calculateAndSetContrainsts:height];
    
    // set text
    self.textView.attributedText = attributedString;
    [self.textView layoutIfNeeded];
    self.textView.contentOffset = CGPointMake(0.0f, 0.0f);
    
    // reload table view
    [self.tableView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Layout Methodes


- (void)calculateAndSetContrainsts:(CGFloat)probableTextHeight {
    
    if (self.section.hasDescription) {
        
        if (probableTextHeight > 150.0f) {
            
            if (!self.section.hasDocuments && !self.section.hasWiki && !self.section.hasAssignment && !self.section.hasOhterItems) {
                
                self.seperatorHeigthOneContraint.constant = 0.0f;
                self.seperatorHeigthTwoContraint.constant = 0.0f;
                self.textViewHeight.constant = self.view.frame.size.height-(57.0f+self.navigationController.navigationBar.frame.size.height+10.0f);
                //self.textViewHeight.constant = 300.0f;
            }
            else {
                
                self.textViewHeight.constant = 150.0f;
                self.seperatorHeigthOneContraint.constant = 8.0f;
                self.seperatorHeigthTwoContraint.constant = 8.0f;
            }
            
        }
        else {
            
            if (probableTextHeight < 30.0f) {
                probableTextHeight = 30.0f;
            }
            
            self.textViewHeight.constant = probableTextHeight;
        }
        
        self.textView.hidden = NO;
    }
    else {
        
        self.textView.text = @"";
        self.seperatorHeigthOneContraint.constant = 0.0f;
        self.seperatorHeigthTwoContraint.constant = 0.0f;
        self.textViewHeight.constant = 0.0f;
        self.textView.hidden = YES;
    }
    
    // set table vie hidden if neccessary
    self.tableView.hidden = !(self.section.hasDocuments || self.section.hasOhterItems || self.section.hasAssignment || self.section.hasWiki);
}


- (void)setupNavigationBar {
    
    UINavigationBar *navBar = self.navigationController.navigationBar;
    navBar.layer.shadowColor = [UIColor blackColor].CGColor;
    navBar.layer.shadowOffset = CGSizeMake(0.0f, 2.0f);
    navBar.layer.shadowOpacity = 0.22f;
    navBar.layer.shadowRadius = 2.0f;
}



#pragma mark - Table View Methodes


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MOODLECourseSectionItem *doc = self.tableViewSegments[indexPath.section][indexPath.row];
    
    if (doc.itemType == MoodleItemTypeComment) {
        
        MOODLECommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MOODLECommentTableViewCellIdentifier];
        
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithData:[doc.text dataUsingEncoding:NSUnicodeStringEncoding]
                                                                                              options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
                                                                                   documentAttributes:nil
                                                                                                error:nil];
        
        [attributedString addAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13.0f]} range:NSMakeRange(0, attributedString.length)];
        
        cell.textView.attributedText = attributedString;
        return cell;
        
    } else {
        
        MOODLECourseSectionItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MOODLECourseSectionItemTableViewCellIdentifier];
        
        cell.itemLabel.text = doc.resourceTitle;
        cell.fileIconImageView.image = [self imageForItem:doc];
        
        return cell;
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.tableViewSegmentTitles.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.tableViewSegments[section].count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MOODLECourseSectionItem *doc = self.tableViewSegments[indexPath.section][indexPath.row];
    
    if (doc.itemType == MoodleItemTypeComment) {
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithData:[doc.text dataUsingEncoding:NSUnicodeStringEncoding]
                                                                                              options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
                                                                                   documentAttributes:nil
                                                                                                error:nil];
        
        [attributedString addAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14.0f]} range:NSMakeRange(0, attributedString.length)];
        CGFloat height = [self textViewHeightForAttributedText:attributedString
                                                      andWidth:self.view.frame.size.width-30.0f];
        
        return (height > 150.0f) ? 150.0f : height;
    }
    
    return 44.0f;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UITableViewCell *headerCell = [tableView dequeueReusableCellWithIdentifier:@"headerCell"];
    headerCell.textLabel.text = self.tableViewSegmentTitles[section];
    headerCell.textLabel.textColor = [UIColor darkGrayColor];
    return headerCell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 22.0f;
}


#pragma mark - Helper Methoes


- (UIImage *)imageForItem:(MOODLECourseSectionItem *)item {
    
    MoodleItemType itemType = item.itemType;
    
    UIImage *image = nil;
    
    switch (itemType) {
        case MoodleItemTypeDocument:
            image = [self imageForDocumentType:item.documentType];
            break;
            
        case MoodleItemTypeURL:
            image = [UIImage imageNamed:@"link_icon"];
            break;
            
        case MoodleItemTypeForum:
            image = [UIImage imageNamed:@"forum_icon"];
            break;
            
        case MoodleItemTypeGlossary:
            image = [UIImage imageNamed:@"gloss_icon"];
            break;
            
        case MoodleItemTypeAssignment:
            image = [UIImage imageNamed:@"assign_icon_grey"];
            break;
            
        case MoodleItemTypeGallery:
            image = [UIImage imageNamed:@"gallery_icon"];
            break;
            
        case MoodleItemTypeFolder:
            image = [UIImage imageNamed:@"folder_icon"];
            break;
            
        case MoodleItemTypeComment:
            image = nil;
            break;
           
        default:
            image = [UIImage imageNamed:@"other_file_icon"];
            break;
    }

    return image;
}


- (UIImage *)imageForDocumentType:(MoodleDocumentType)documentType {
    
    UIImage *image = [UIImage imageNamed:@"other_file_icon"];;
    
    if (documentType == MoodleDocumentTypePDF) {
        
        image = [UIImage imageNamed:@"pdf_icon"];
    }
    else if (documentType == MoodleDocumentTypePPT) {
        
        image = [UIImage imageNamed:@"ppt_icon"];
    }
    else if (documentType == MoodleDocumentTypeWordDocument) {
        
        image = [UIImage imageNamed:@"doc_icon"];
    }
    else if (documentType == MoodleDocumentTypeAudioFile) {
        
        image = [UIImage imageNamed:@"mp3_icon"];
    }

    return image;
}


- (CGFloat)textViewHeightForAttributedText:(NSAttributedString*)text andWidth:(CGFloat)width {
    
    [self.heightCalculationTextView setAttributedText:text];
    CGSize size = [self.heightCalculationTextView sizeThatFits:CGSizeMake(width, FLT_MAX)];

    return size.height+10.0f;
}


- (UITextView *)heightCalculationTextView {
    
    if (!_heightCalculationTextView) {
        
        _heightCalculationTextView = [[UITextView alloc] init];
    }
    return _heightCalculationTextView;
}


#pragma mark - Navigation


// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller
    
    if ([segue.identifier isEqualToString:@"toDocumentSegue"]) {
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        MOODLEDocumentViewController *destViewController = segue.destinationViewController;
        MOODLECourseSectionItem *item = self.tableViewSegments[indexPath.section][indexPath.row];
        
        destViewController.resourceURL = item.resourceURL;
        if (item.itemType == MoodleItemTypeDocument) destViewController.isAudio = (item.documentType == MoodleDocumentTypeAudioFile);
    }
}


#pragma mark -
@end

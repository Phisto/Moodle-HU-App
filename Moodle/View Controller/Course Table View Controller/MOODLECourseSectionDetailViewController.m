/*
 *  MOODLECourseSectionDetailViewController.m
 *  Moodle
 *
 *  Created by Simon Gaus on 03.06.17.
 *  Copyright © 2017 Simon Gaus. All rights reserved.
 *
 */

#import "MOODLECourseSectionDetailViewController.h"

/* View Controller */
#import "MOODLEDocumentViewController.h"

/* Table View */
#import "MOODLECommentTableViewCell.h"
#import "MOODLECourseSectionItemTableViewCell.h"

/* Data Model */
#import "MOODLECourseSection.h"
#import "MOODLECourseSectionItem.h"

///-----------------------
/// @name CATEGORIES
///-----------------------



@interface MOODLECourseSectionDetailViewController (/* Private */)

// UI
@property (nonatomic, strong) IBOutlet UILabel *sectionTitleLabel;
@property (nonatomic, strong) IBOutlet UITextView *textView;
@property (nonatomic, strong) IBOutlet UITableView *tableView;

// Table View
@property (nonatomic, strong) NSArray<NSString *> *tableViewSegmentTitles;
@property (nonatomic, strong) NSArray<NSArray<MOODLECourseSectionItem *> *> *tableViewSegments;

// Constraints
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *textViewHeight;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *seperatorHeigthOneContraint;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *seperatorHeigthTwoContraint;

// Other
@property (nonatomic, strong) IBOutlet UITextView *heightCalculationTextView;

@end



@interface MOODLECourseSectionDetailViewController (Accessibility)

- (NSString *)accessibility_titleForItem:(MOODLECourseSectionItem *)item;

@end



///-----------------------
/// @name IMPLEMENTATION
///-----------------------



@implementation MOODLECourseSectionDetailViewController
#pragma mark - View Controller Methodes


- (void)viewDidLoad {
    
    // call super
    [super viewDidLoad];
    
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
    [attributedString addAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16.0f]} range:NSMakeRange(0, attributedString.length)];
    CGFloat height = [self textViewHeightForAttributedText:attributedString
                                                  andWidth:self.view.frame.size.width-30.0f];
    [self calculateAndSetContrainsts:height];
    self.textView.attributedText = attributedString;

    // reload table view
    [self.tableView reloadData];
}


- (void)viewDidLayoutSubviews {
    // set content offset after the text view is properly sized
    [self.textView setContentOffset:CGPointZero animated:NO];
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
        
        // accessibility
        NSString *locString = NSLocalizedString(@"Kommentar", @"prefix for a comment course section item");
        cell.accessibilityLabel = locString;
        
        return cell;
        
    } else {
        
        MOODLECourseSectionItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MOODLECourseSectionItemTableViewCellIdentifier];
        
        cell.itemLabel.text = doc.resourceTitle;
        cell.fileIconImageView.image = [self imageForItem:doc];
        
        // accessibility
        cell.accessibilityLabel = [NSString stringWithFormat:@"%@\n%@", [self accessibility_titleForItem:doc], doc.resourceTitle];
        
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
    
    // accessibility
    headerCell.isAccessibilityElement = NO;
    headerCell.accessibilityElementsHidden = YES;
    
    return headerCell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 22.0f;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    MOODLEDocumentViewController *newViewController = (MOODLEDocumentViewController *)[storyboard instantiateViewControllerWithIdentifier:@"courseSectionItemViewController"];
    MOODLECourseSectionItem *item = self.tableViewSegments[indexPath.section][indexPath.row];
    newViewController.resourceURL = item.resourceURL;
    if (item.itemType == MoodleItemTypeDocument) newViewController.isAudio = (item.documentType == MoodleDocumentTypeAudioFile);
    [self.navigationController pushViewController:newViewController animated:YES];
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

    // +10 for imprecise calculation
    return size.height+10.0f;
}


- (UITextView *)heightCalculationTextView {
    
    if (!_heightCalculationTextView) {
        
        _heightCalculationTextView = [[UITextView alloc] init];
    }
    return _heightCalculationTextView;
}


#pragma mark -
@end



#pragma mark - ACCESSIBILITY
///-----------------------
/// @name ACCESSIBILITY
///-----------------------



@implementation MOODLECourseSectionDetailViewController (Accessibility)


- (NSString *)accessibility_titleForItem:(MOODLECourseSectionItem *)item {
    
    MoodleItemType itemType = item.itemType;
    
    NSString *title = @"";
    
    switch (itemType) {
        case MoodleItemTypeDocument:
            title = [self accessibility_titleFromDocumentType:item.documentType];
            break;
            
        case MoodleItemTypeURL:
            title = NSLocalizedString(@"Link", @"voice over item type title Link");
            break;
            
        case MoodleItemTypeForum:
            title = @""; // the title of the forum is forum so we dont need to describe it ...
            break;
            
        case MoodleItemTypeGlossary:
            title = @""; // the title of the glossary is glossary so we dont need to describe it ...
            break;
            
        case MoodleItemTypeAssignment:
            title = NSLocalizedString(@"Abgabe", @"voice over item type title");
            break;
            
        case MoodleItemTypeGallery:
            title = NSLocalizedString(@"Gallerie", @"voice over item type title");
            break;
            
        case MoodleItemTypeFolder:
            title = NSLocalizedString(@"Ordner", @"voice over item type title");
            break;
            
        default:
            title = NSLocalizedString(@"Anderes Item", @"voice over item type title");
            break;
    }
    
    return title;
}


- (NSString *)accessibility_titleFromDocumentType:(MoodleDocumentType)documentType {
    
    NSString *title = nil;
    
    switch (documentType) {
        case MoodleDocumentTypePDF:
            title = NSLocalizedString(@"PDF Datei", @"voice over document type title PDF");
            break;
            
        case MoodleDocumentTypePPT:
            title = NSLocalizedString(@"PowerPoint Datei", @"voice over document type title PPT");
            break;
            
        case MoodleDocumentTypeWordDocument:
            title = NSLocalizedString(@"Word Datei", @"voice over document type title WORD");
            break;
            
        case MoodleDocumentTypeAudioFile:
            title = NSLocalizedString(@"Audio Datei", @"voice over document type title Audio");
            break;
            
        default:
            title = NSLocalizedString(@"Andere Datei", @"voice over document type title other document");
            break;
    }
    
    return title;
}


#pragma mark -
@end

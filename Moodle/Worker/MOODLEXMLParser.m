/*
 *  MOODLEXMLParser.m
 *  Moodle
 *
 *  Created by Simon Gaus on 03.06.17.
 *  Copyright © 2017 Simon Gaus. All rights reserved.
 *
 */

@import UIKit;

#import "MOODLEXMLParser.h"

/* Entities */
#import "MOODLECourse.h"
#import "MOODLECourseSection.h"
#import "MOODLECourseSectionItem.h"
#import "MOODLEForum.h"
#import "MOODLEForumEntry.h"
#import "MOODLEForumPost.h"

/* Parser */
#import "TFHpple.h"

///-----------------------
/// @name CONSTANTS
///-----------------------



/* Resource Identifier */
static NSString * const kResourceIdentifier = @"modtype_resource";
static NSString * const kWikiIdentifier = @"modtype_ouwiki";
static NSString * const kLabelIdentifier = @"modtype_label";
static NSString * const kAssignmentIdentifier = @"modtype_assign";
static NSString * const kURLIdentifier = @"modtype_url";
static NSString * const kForumIdentifier = @"modtype_forum";
static NSString * const kGlossaryIdentifier = @"modtype_glossary";
static NSString * const kGalleryIdentifier = @"modtype_lightboxgallery";
static NSString * const kFolderIdentifier = @"modtype_folder";
static NSString * const kPageIdentifier = @"modtype_page";

/* Document Type Identifier */
static NSString * const kDocIconURLPowerPoint = @"powerpoint-24";
static NSString * const kDocIconURLPDF = @"pdf-24";
static NSString * const kDocIconURLWordDocument = @"document-24";
static NSString * const kDocIconURLAudio = @"mp3-24";



///-----------------------
/// @name CATEGORIES
///-----------------------



@interface MOODLEXMLParser (/* Private */)

@property (nonatomic, strong) NSNumberFormatter *numberFormatter;
@property (nonatomic, strong) NSArray<NSString *> *semesterArray;

@end



///-----------------------
/// @name IMPLEMENTATION
///-----------------------



@implementation MOODLEXMLParser
#pragma mark - API Methodes


- (nullable NSString *)sessionKeyFromData:(NSData *)data {
    
    TFHpple *courseParser = [TFHpple hppleWithHTMLData:data];
    
    NSString *courseXpathQueryString = @"//div[@class='logininfo']";
    NSArray *courseNodes = [courseParser searchWithXPathQuery:courseXpathQueryString];

    NSString *sessionKey = nil;
    for (TFHppleElement *element in courseNodes) {

        if (element.children.count == 4) {
            
            TFHppleElement *secondChild = element.children[2];

            if ([secondChild.content isEqualToString:@"Logout"]) {
                
                sessionKey = [secondChild objectForKey:@"href"];
                sessionKey = [sessionKey componentsSeparatedByString:@"logout.php?sesskey="].lastObject;
                break;
            }
        }
    }
    return sessionKey;
}


- (nullable NSArray<MOODLECourse *> *)searchResultsFromData:(NSData *)data {
    
    NSMutableArray *mutableSearchResults = [NSMutableArray array];
    
    TFHpple *searchParser = [TFHpple hppleWithHTMLData:data];
    NSString *searchString = @"//div[@class='courses course-search-result course-search-result-search']/div";
    NSArray *searchNodes = [searchParser searchWithXPathQuery:searchString];
    for (TFHppleElement *element in searchNodes) {
        
        if (element.children.count > 1) {
            
            MOODLECourse *item = nil;
            
            TFHppleElement *infoElement = element.children[0];
            if ([[infoElement objectForKey:@"class"] isEqualToString:@"info"]) {
                
                item = [[MOODLECourse alloc] init];
                
                // title
                NSString *name = [infoElement.firstChild content];
                if (name) {
                  
                    item.courseTitle = name;
                }
                else {
                    
                    break;
                }
                
                NSString *url = [infoElement.firstChild.firstChild objectForKey:@"href"];
                if (url) {
                    item.url = [NSURL URLWithString:url];
                }
                
                if (infoElement.children.count > 2) {
                    
                    NSString *semesterName = nil;
                    
                    // semester and enrolement
                    TFHppleElement *rightInfoNode = infoElement.children[2];
                    for (TFHppleElement *node in rightInfoNode.children) {

                        if ([[node objectForKey:@"class"] isEqualToString:@"semname"]) {

                            semesterName = [node content];
                            if (semesterName) {
                                
                                item.semester = semesterName;
                            }
                        }
                        if ([[node objectForKey:@"class"] isEqualToString:@"enrolmenticons"]) {
                            
                            for (TFHppleElement *enrolementNode in node.children) {
                                
                                if ([[enrolementNode objectForKey:@"title"] isEqualToString:@"Selbsteinschreibung"]) {
                                    
                                    item.selfSubscribe = YES;
                                }
                                if ([[enrolementNode objectForKey:@"title"] isEqualToString:@"Gastzugang"]) {
                                    
                                    item.guestSubscribe = YES;
                                }
                            }
                        }
                    }
                }
            }
            else { NSLog(@"class is not 'info' but '%@'", [infoElement objectForKey:@"class"]); }
            
            // content
            
            TFHppleElement *contentElement = element.children[1];
            if ([[contentElement objectForKey:@"class"] isEqualToString:@"content"]) {
                if (contentElement.children.count > 2) {
                    
                    // get summary
                    TFHppleElement *summaryElement = contentElement.children[0];
                    NSString *summary = [summaryElement raw];
                    if (summary.length > 5) {
                        
                        item.courseDescriptionRaw = summary;
                    }
                    
                    // get teacher
                    TFHppleElement *teachersElement = contentElement.children[1];
                    NSMutableArray *muteTeacherArray = [NSMutableArray array];
                    for (TFHppleElement *teachersNode in teachersElement.children) {
                        
                        if (teachersNode.children.count > 1) {
                            
                            NSString *teacher = (NSString *)[teachersNode.children[1] content];
                            if (teacher) [muteTeacherArray addObject:teacher];
                        }
                    }
                    if (muteTeacherArray.count > 0) { item.teacher = [muteTeacherArray copy]; }
                    
                    // get course category
                    TFHppleElement *courseCategoryElement = contentElement.children[2];
                    if (courseCategoryElement.children.count > 1) {
                        
                        NSString *categorie = (NSString *)[courseCategoryElement.children[1] content];
                        if (categorie) item.courseCategory = categorie;
                    }
                }
                
                
            }
            else { NSLog(@"class is not 'content' but '%@'", [contentElement objectForKey:@"class"]); }
            
            if (item) [mutableSearchResults addObject:item];
        }
    }
    
    if (mutableSearchResults.count == 0) {
        
        return nil;
    }
    
    return [mutableSearchResults copy];
}


- (NSArray<MOODLECourse *> *)createCourseItemsFromData:(NSData *)data {
    
    TFHpple *courseParser = [TFHpple hppleWithHTMLData:data];
    
    NSString *courseXpathQueryString = @"//li[@class='type_course depth_3 contains_branch']/p/a";
    NSArray *courseNodes = [courseParser searchWithXPathQuery:courseXpathQueryString];
    
    NSMutableArray *courses = [[NSMutableArray alloc] initWithCapacity:courseNodes.count];
    for (TFHppleElement *element in courseNodes) {
        
        @try {
            
            NSString *title = [element objectForKey:@"title"];
            NSString *url = [element objectForKey:@"href"];
            NSString *moodleID = [[element firstChild] content];
            
            if (title && url && moodleID) {
                
                MOODLECourse *item = [[MOODLECourse alloc] init];
                item.courseTitle = title;
                item.url = [NSURL URLWithString:url];
                item.moodleCourseID = [(NSString *)[[url componentsSeparatedByString:@"id="] lastObject] integerValue];
                
                [self setSemesterAndMoodleNameFromString:moodleID forCourse:item];
                
                [courses addObject:item];
            }
            
        } @catch (NSException *exception) {
            
            NSLog(@"Error during course parsing: %@", exception);
        }
    }
    
    return [courses copy];
}


- (NSArray<MOODLECourseSection *> *)createCourseSectionsFromData:(NSData *)data {
    
    NSArray<MOODLECourseSection *> *sections = @[];
    
    NSArray<TFHppleElement *> *sectionNodes = [self courseSectionNodesFromData:data];
    if (sectionNodes.count > 0) {
        
        NSMutableArray<MOODLECourseSection *> *muteSections = [[NSMutableArray alloc] initWithCapacity:sectionNodes.count];
        for (TFHppleElement *sectionElement in sectionNodes) {
            
            if (sectionElement.children.count == 3) {
                
                TFHppleElement *sectionNameElement = sectionElement.children[0];
                
                // section title (we set defaults to silence memory warnings, as if this code fails it doesent matter anyways)
                NSString *name = @"no name";
                NSString *urlString = @"no url";
                
                // element is node < div class='sectionname' (or 'sectionname accesshide' or 'section-title')>
                if (sectionNameElement.hasChildren) {
                    
                    sectionNameElement = [sectionNameElement firstChild];
                    
                    // title node <a ... may be inside a <span> element ...
                    TFHppleElement *maybeSectionNameElement = [sectionNameElement firstChild];
                    
                    name = [(maybeSectionNameElement.raw) ? maybeSectionNameElement : sectionNameElement content];
                    urlString = [(maybeSectionNameElement.raw) ? maybeSectionNameElement : sectionNameElement objectForKey:@"href"];
                }
                
                BOOL canLoadContent = !([urlString containsString:@"&section="]);
                
                NSURL *sectionURL = [NSURL URLWithString:urlString];
                NSString *sectionSummary = [self sectionSummary:sectionElement.children[1]];
                
                MOODLECourseSection *section = [[MOODLECourseSection alloc] init];
                
                section.sectionTitle = name;
                section.sectionDescriptionRaw = sectionSummary;
                section.sectionURL = sectionURL;
                
                // set flags
                section.hasContenLoaded = canLoadContent;
                section.isIndependentSection = !canLoadContent;
                
                
                if (canLoadContent) {
                    
                    NSArray<MOODLECourseSectionItem *> *items = [self sectionItems:sectionElement.children[2]];
                    
                    NSMutableArray *muteDocArray = [NSMutableArray array];
                    NSMutableArray *muteAssignArray = [NSMutableArray array];
                    NSMutableArray *muteWikiArray = [NSMutableArray array];
                    NSMutableArray *muteOtherArray = [NSMutableArray array];
                    
                    for (MOODLECourseSectionItem *item in items) {
                        
                        // add to right category
                        if (item.itemType == MoodleItemTypeDocument ) {
                            [muteDocArray addObject:item];
                        }
                        
                        else if (item.itemType == MoodleItemTypeAssignment) {
                            [muteAssignArray addObject:item];
                        }
                        
                        else if (item.itemType == MoodleItemTypeWiki) {
                            [muteWikiArray addObject:item];
                        }
                        
                        else {
                            
                            [muteOtherArray addObject:item];
                        }
                    }
                    
                    section.documentItemArray = (muteDocArray.count > 0) ? [muteDocArray copy] : nil;
                    section.assignmentsItemArray = (muteAssignArray.count > 0) ? [muteAssignArray copy] : nil;
                    section.wikisItemArray = (muteWikiArray.count > 0) ? [muteWikiArray copy] : nil;
                    section.otherItemArray = (muteOtherArray.count > 0) ? [muteOtherArray copy] : nil;
                }
                
                [muteSections addObject:section];
            }
            else if (sectionElement.children.count == 2) {
                
                TFHppleElement *sectionNameElement = sectionElement.children[0];
                
                // section title (we set defaults to silence memory warnings, as if this code fails it doesent matter anyways)
                NSString *name = @"no name";
                NSString *urlString = @"no url";
                
                // element is node < div class='sectionname' (or 'sectionname accesshide' or 'section-title')>
                if (sectionNameElement.hasChildren) {
                    
                    sectionNameElement = [sectionNameElement firstChild];
                    
                    // title node <a ... may be inside a <span> element ...
                    TFHppleElement *maybeSectionNameElement = [sectionNameElement firstChild];
                    
                    name = [(maybeSectionNameElement.raw) ? maybeSectionNameElement : sectionNameElement content];
                    urlString = [(maybeSectionNameElement.raw) ? maybeSectionNameElement : sectionNameElement objectForKey:@"href"];
                    
                }
                
                NSURL *sectionURL = [NSURL URLWithString:urlString];
                
                NSString *sectionSummary = [self sectionSummary:sectionElement.children[1]];
                
                MOODLECourseSection *section = [[MOODLECourseSection alloc] init];
                
                section.sectionTitle = name;
                section.sectionDescriptionRaw = sectionSummary;
                section.sectionURL = sectionURL;
                
                // set flags
                section.hasContenLoaded = NO;
                section.isIndependentSection = NO;
                
                [muteSections addObject:section];
            }
        }
        
        sections = [muteSections copy];
    }
    
    return sections;
}


- (BOOL)createContentForCourseSections:(MOODLECourseSection *)section fromData:(NSData *)data {
    
    NSArray *sectionNodes = [self singleSectionCourseSectionNodesFromData:data];
    if (sectionNodes.count > 0) {
        
        TFHppleElement *sectionElement = sectionNodes[0];
        if (sectionElement.children.count == 3) {
            
            NSString *name = [self sectionName:sectionElement.children[0]];
            NSString *sectionSummary = [self sectionSummary:sectionElement.children[1]];
            NSArray<MOODLECourseSectionItem *> *items = [self sectionItems:sectionElement.children[2]];
            
            section.sectionTitle = name;
            section.sectionDescriptionRaw = sectionSummary;
            
            NSMutableArray *muteDocArray = [NSMutableArray array];
            NSMutableArray *muteAssignArray = [NSMutableArray array];
            NSMutableArray *muteWikiArray = [NSMutableArray array];
            NSMutableArray *muteOtherArray = [NSMutableArray array];
            
            for (MOODLECourseSectionItem *item in items) {
                
                // add to right category
                if (item.itemType == MoodleItemTypeDocument ) {
                    [muteDocArray addObject:item];
                }
                
                else if (item.itemType == MoodleItemTypeAssignment) {
                    [muteAssignArray addObject:item];
                }
                
                else if (item.itemType == MoodleItemTypeWiki) {
                    [muteWikiArray addObject:item];
                }
                
                else {
                    
                    [muteOtherArray addObject:item];
                }
            }
            
            section.documentItemArray = (muteDocArray.count > 0) ? [muteDocArray copy] : nil;
            section.assignmentsItemArray = (muteAssignArray.count > 0) ? [muteAssignArray copy] : nil;
            section.wikisItemArray = (muteWikiArray.count > 0) ? [muteWikiArray copy] : nil;
            section.otherItemArray = (muteOtherArray.count > 0) ? [muteOtherArray copy] : nil;
            
            section.hasContenLoaded = YES;
        }
    }
    
    return section.hasContenLoaded;
}


- (MOODLEForum *)forumFromData:(NSData *)data {
    
    TFHpple *courseParser = [TFHpple hppleWithHTMLData:data];
    
    NSString *courseXpathQueryString = @"//table[@class='forumheaderlist']/tbody/tr";
    NSArray *courseNodes = [courseParser searchWithXPathQuery:courseXpathQueryString];
    
    NSMutableArray *muteEntryArray = [NSMutableArray array];
    MOODLEForum *forum = [[MOODLEForum alloc] init];
    
    for (TFHppleElement *element in courseNodes) {
        
        MOODLEForumEntry *entry = [[MOODLEForumEntry alloc] init];
        BOOL isFirstRepliesEntry = YES;
    
        for (TFHppleElement *child in element.children) {
            
            NSString *className = [child objectForKey:@"class"];
            
            if ([className isEqualToString:@"topic starter"]) {
                
                entry.entryURL = [NSURL URLWithString:[child.children.firstObject objectForKey:@"href"]];
                entry.title = child.content;
            }
            
            else if ([className isEqualToString:@"author"]) {
                
                entry.author = child.content;
            }
            
            else if ([className isEqualToString:@"replies"]) {
                
                if (isFirstRepliesEntry) {
                    
                    entry.replies = child.content.integerValue;
                    isFirstRepliesEntry = NO;
                }
                else {
                    
                    entry.unreadReplies = child.content.integerValue;
                }
                
            }
            
            /*
            if ([className isEqualToString:@"picture"]) {
             
            }
            
            if ([className isEqualToString:@"lastpost"]) {
                
            }
             
            if ([className isEqualToString:@"discussionsubscription"]) {
             
            }
             */
        }
        [muteEntryArray addObject:entry];
        
    }
    
    if (muteEntryArray.count > 0) {
        
        forum.entries = [muteEntryArray copy];
    }
    
    return forum;
}


- (NSArray<MOODLEForumPost *> *)forumEntryItemsFromData:(NSData *)data {
    
    
    TFHpple *courseParser = [TFHpple hppleWithHTMLData:data];
    
    NSMutableArray *mutePostArray = [NSMutableArray array];

    NSString *courseXpathQueryStringReply = @"//div[@class='indent']/div";
    NSArray *courseNodesReply = [courseParser searchWithXPathQuery:courseXpathQueryStringReply];
    for (TFHppleElement *element in courseNodesReply) {

        MOODLEForumPost *post = [[MOODLEForumPost alloc] init];
        
        NSArray *topicNodes = [element searchWithXPathQuery:@"//div[@class='topic']"];
        TFHppleElement *topic = topicNodes.firstObject;
        if (topic) {
            
            TFHppleElement *titleELement = topic.children.firstObject;
            NSString *title = titleELement.content;
            
            post.title = title;
            
            if (topic.children.count > 1) {
                
                TFHppleElement *authorELement = topic.children[1];
                NSString *autohr = authorELement.content;
                post.author = autohr;
            }
            
        }
        
        
        NSArray *contentNodes = [element searchWithXPathQuery:@"//div[@class='posting fullpost']"];
        TFHppleElement *contentElement = contentNodes.firstObject;
        if (contentElement) {
            
            post.rawContent = contentElement.raw;
        }
        
        if (post.author && post.title && post.content) {
            
            post.isOP = NO;
            [mutePostArray addObject:post];
        }
        
        
        /// get attachments
        NSArray *attachmentNodes = [element searchWithXPathQuery:@"//div[@class='attachments']"];
        if (attachmentNodes.firstObject) {
            
            TFHppleElement *attachments = (TFHppleElement *)attachmentNodes.firstObject;
            
            if (attachments.children.count > 2) {
                
                TFHppleElement *docNode = attachments.children[2];
                
                NSString *title = docNode.content;
                NSString *urlString = [docNode objectForKey:@"href"];
                
                
                MOODLECourseSectionItem *item = [[MOODLECourseSectionItem alloc] init];
                item = [[MOODLECourseSectionItem alloc] init];
                
                
                if ([[urlString pathExtension] isEqualToString:@"pdf"]) {
                    item.itemType = MoodleItemTypeDocument;
                    item.documentType = MoodleDocumentTypePDF;
                } else {
                    item.itemType = MoodleItemTypeOther;
                }
                
                item.resourceURL = [NSURL URLWithString:urlString];
                
                item.resourceTitle = title;
                
                post.attachments = @[item];
            }
            
        }
    }

    
    
    NSArray *xQueryArray = @[@"//div[@class='forumpost clearfix read firstpost starter']",
                             @"//div[@class='forumpost clearfix read lastpost firstpost starter']"];
    for (NSString *searchQuery in xQueryArray) {
        
        NSArray *courseNodesStarter = [courseParser searchWithXPathQuery:searchQuery];
        if (courseNodesStarter.count > 0) {
            for (TFHppleElement *starterelement in courseNodesStarter) {
                
                MOODLEForumPost *starterpost = [[MOODLEForumPost alloc] init];
                
                NSArray *startertopicNodes = [starterelement searchWithXPathQuery:@"//div[@class='topic firstpost starter']"];
                
                TFHppleElement *startertopic = startertopicNodes.firstObject;
                if (startertopic) {
                    
                    TFHppleElement *startertitleELement = startertopic.children.firstObject;
                    NSString *startertitle = startertitleELement.content;
                    
                    starterpost.title = startertitle;
                    
                    if (startertopic.children.count > 1) {
                        
                        TFHppleElement *starterauthorELement = startertopic.children[1];
                        NSString *starterautohr = starterauthorELement.content;
                        starterpost.author = starterautohr;
                    }
                    
                }
                
                NSArray *startercontentNodes = [starterelement searchWithXPathQuery:@"//div[@class='posting fullpost']"];
                TFHppleElement *startercontentElement = startercontentNodes.firstObject;
                if (startercontentElement) {
                    
                    starterpost.rawContent = startercontentElement.raw;
                }
                
                if (starterpost.author && starterpost.title && starterpost.content) {
                    
                    starterpost.isOP = YES;
                    [mutePostArray insertObject:starterpost atIndex:0];
                }
                
                /// get attachments
                NSArray *attachmentNodes = [starterelement searchWithXPathQuery:@"//div[@class='attachments']"];
                if (attachmentNodes.firstObject) {
                 
                    TFHppleElement *attachments = (TFHppleElement *)attachmentNodes.firstObject;
                    
                    if (attachments.children.count > 2) {
                        
                        TFHppleElement *docNode = attachments.children[2];

                        NSString *title = docNode.content;
                        NSString *urlString = [docNode objectForKey:@"href"];
                        
                        
                        MOODLECourseSectionItem *item = [[MOODLECourseSectionItem alloc] init];
                        item = [[MOODLECourseSectionItem alloc] init];
                        
                        
                        if ([[urlString pathExtension] isEqualToString:@"pdf"]) {
                            item.itemType = MoodleItemTypeDocument;
                            item.documentType = MoodleDocumentTypePDF;
                        } else {
                            item.itemType = MoodleItemTypeOther;
                        }
                        
                        item.resourceURL = [NSURL URLWithString:urlString];
                       
                        item.resourceTitle = title;

                        starterpost.attachments = @[item];
                    }

                }
                
                break;
            }
            
            break;
        }
    }
  
    return [mutePostArray copy];
}


#pragma mark - Helper Methodes


- (nullable NSArray<TFHppleElement *> *)courseSectionNodesFromData:(NSData *)data {

    TFHpple *courseParser = [TFHpple hppleWithHTMLData:data];
    
    NSArray<NSString *> *sectionsXpathQueryStringsArray = @[
                                                            @"//ul[@class='topics']/li/div[@class='content']",
                                                            @"//ul[@class='weeks']/li/div[@class='content']"
                                                            ];
    
    for (NSString *searchQuery in sectionsXpathQueryStringsArray) {
        
        NSArray<TFHppleElement *> *sectionNodes = [courseParser searchWithXPathQuery:searchQuery];
        if (sectionNodes.count > 0) {
            return sectionNodes;
        }
    }
    
    return nil;
}


- (nullable NSArray<TFHppleElement *> *)singleSectionCourseSectionNodesFromData:(NSData *)data {
    
    TFHpple *courseParser = [TFHpple hppleWithHTMLData:data];
    
    NSArray<NSString *> *sectionsXpathQueryStringsArray = @[
                                                            @"//div[@class='single-section']/ul[@class='topics']/li/div[@class='content']",
                                                            @"//div[@class='single-section']/ul[@class='weeks']/li/div[@class='content']"
                                                            ];
    
    for (NSString *searchQuery in sectionsXpathQueryStringsArray) {
        
        NSArray<TFHppleElement *> *sectionNodes = [courseParser searchWithXPathQuery:searchQuery];
        if (sectionNodes.count > 0) {
            return sectionNodes;
        }
    }
    
    return nil;
}

/**
 
 element is node < div class='sectionname' (or class='sectionname accesshide')>
 
 */
- (nullable NSString *)sectionName:(TFHppleElement *)element {
    
    NSString *name = nil;
    if (element.hasChildren) {
        
        element = [element firstChild];
        
        if (element.hasChildren) {
            
            element = [element firstChild];
            name = [element content];
        }
    }

    return name;
}
/**
 
 element is node < div class='summary'>
 
 */
- (nullable NSString *)sectionSummary:(TFHppleElement *)element {
    
    NSString *summary = nil;
    
    if (element.hasChildren) {
        
        element = [element firstChild];
        summary = [element raw];
    }
    return summary;
}
/**
 
 element is node < ul class='section img-text'>
 
 */
- (nullable NSArray<MOODLECourseSectionItem *> *)sectionItems:(TFHppleElement *)element {
    
    NSArray<MOODLECourseSectionItem *> *items = nil;
    if (element.hasChildren) {
        
        NSArray<TFHppleElement *> *itemElements = element.children;
        NSMutableArray *muteItems = [NSMutableArray arrayWithCapacity:itemElements.count];
        
        for (TFHppleElement *itemElement in itemElements) {
            
            MOODLECourseSectionItem *item = [self itemFromElement:itemElement];
            if (item) [muteItems addObject:item];
        }
        
        items = [muteItems copy];
    }
    
    return items;
}
/**
 
 element is node <li class='activity *** ***'>
 
 */
- (nullable MOODLECourseSectionItem *)itemFromElement:(TFHppleElement *)element {
    
    MOODLECourseSectionItem *item = nil;
    
    NSArray *searchQueryArray = @[
                                  @"//div[@class='contentwithoutlink ']",
                                  @"//div[@class='activityinstance']/a"
                                  ];
    for (int i = 0 ; i < searchQueryArray.count ; i++) {
        
        NSString *query = searchQueryArray[i];
        NSArray<TFHppleElement *> *nodesArray = [element searchWithXPathQuery:query];
        if (nodesArray.count > 0) {
            
            if (i == 0) {
                
                // get type
                item = [[MOODLECourseSectionItem alloc] init];
                item.itemType = MoodleItemTypeComment;
                
                TFHppleElement *itemElement = nodesArray.firstObject;
                
                BOOL continueWhile = YES;
                
                while (continueWhile) {
                    
                    if  (itemElement.hasChildren ) {
                        
                        NSString *className = [itemElement.firstChild objectForKey:@"class"];
                        if (className) {
                            
                            if ([className isEqualToString:@"no-overflow"]) {
                                itemElement = itemElement.firstChild;
                            }
                        }
                        else {
                            
                            continueWhile = NO;
                        }
                    }
                }
                item.textRaw = [itemElement raw];
                item.resourceURL = nil;
                
            }
            else {
                
                TFHppleElement *itemElement = nodesArray.firstObject;
                if (itemElement.hasChildren) {
                    
                    // get type
                    item = [[MOODLECourseSectionItem alloc] init];
                    item.itemType = [self itemTypeFromString:[element objectForKey:@"class"]];
                    
                    // get url
                    NSString *urlString = [itemElement objectForKey:@"href"];
                    item.resourceURL = [NSURL URLWithString:urlString];
                    
                    // get title
                    NSArray<TFHppleElement *> *children = itemElement.children;
                    NSString *ressourceTitle = @"- Kein Titel -";
                    if (children.count == 2) {
                        
                        TFHppleElement *titleNode = itemElement.children[1];
                        ressourceTitle = [[titleNode firstChild] content];
                        
                        // get doc type if item type is MoodleItemTypeDocument
                        if (item.itemType == MoodleItemTypeDocument) {
                            
                            TFHppleElement *docIconElement = itemElement.children[0];
                            NSString *url = [docIconElement objectForKey:@"src"];
                            item.documentType = [self documentTypeFromString:url];
                        }
                    }
                    item.resourceTitle = ressourceTitle;
                }
            }
            
            break;
        }
    }
    
    return item;
}


- (void)setSemesterAndMoodleNameFromString:(NSString *)string forCourse:(MOODLECourse *)course {
    
    /*
     2017-05-17 12:52:58.196 Moodle[8018:2550318] moodleID: 5210028 (WiSe 2016/17)
     2017-05-17 12:52:58.198 Moodle[8018:2550318] moodleID: 5210029 (SoSe 2017)
     2017-05-17 12:52:58.198 Moodle[8018:2550318] moodleID: 5210041 (WiSe 2016/17)
     2017-05-17 12:52:58.199 Moodle[8018:2550318] moodleID: 5210045 (WiSe 2016/17)
     2017-05-17 12:52:58.199 Moodle[8018:2550318] moodleID: 5210061 (SoSe 2017)
     2017-05-17 12:52:58.200 Moodle[8018:2550318] moodleID: 53478 WiSe 2016/17
     2017-05-17 12:52:58.200 Moodle[8018:2550318] moodleID: 91302 Russisch A1 TL SoSe 2017
     2017-05-17 12:52:58.200 Moodle[8018:2550318] moodleID: Musiktheorie
     2017-05-17 12:52:58.201 Moodle[8018:2550318] moodleID: 5210204 (WS 12/13)
     */
    
    for (NSString *sem in self.semesterArray) {
        
        if ([string containsString:sem]) {
            
            if ([sem isEqualToString:@"(SoSe "]) {
                //(SoSe 2017)
                course.semester = [string substringWithRange:NSMakeRange(string.length-10, 9)];
                course.moodleTitle = [string stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@" (%@)", course.semester] withString:@""];
                course.moodleTitle = [course.moodleTitle stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"(%@)", course.semester] withString:@""];
                
            }
            else if ([sem isEqualToString:@"(WiSe "]) {
                
                //(WiSe 2016/17)
                if (string.length > 14) {
                    
                    course.semester = [string substringWithRange:NSMakeRange(string.length-13, 12)];
                    course.moodleTitle = [string stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@" (%@)", course.semester] withString:@""];
                    course.moodleTitle = [course.moodleTitle stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"(%@)", course.semester] withString:@""];
                }
                
            } else if ([sem isEqualToString:@" SoSe "]) {
                
                //(WiSe 2016/17)
                course.semester = [string substringWithRange:NSMakeRange(string.length-9, 9)];
                course.moodleTitle = [string stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@" %@", course.semester] withString:@""];
                course.moodleTitle = [course.moodleTitle stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@", course.semester] withString:@""];
                
            } else if ([sem isEqualToString:@" WiSe "]) {
                
                // WiSe 2016/17
                course.semester = [string substringWithRange:NSMakeRange(string.length-12, 12)];
                course.moodleTitle = [string stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@" %@", course.semester] withString:@""];
                course.moodleTitle = [course.moodleTitle stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@", course.semester] withString:@""];
            }
            
        }
    }
    
    if (!course.moodleTitle || !course.semester) {
        course.moodleTitle = string;
        course.semester = @"-";
    }
}


- (MoodleItemType)itemTypeFromString:(NSString *)string {
    
    MoodleItemType itemType = MoodleItemTypeOther;
    NSArray<NSString *> *partArray = [string componentsSeparatedByString:@" "];
    if (partArray.count == 3) {

        
        NSString *identifier = partArray.lastObject;
        
        if ([identifier isEqualToString:kResourceIdentifier]) {
            
            itemType = MoodleItemTypeDocument;
        }
        else if ([identifier isEqualToString:kWikiIdentifier]) {
            
            itemType = MoodleItemTypeWiki;
        }
        else if ([identifier isEqualToString:kLabelIdentifier]) {
            
            itemType = MoodleItemTypeComment;
        }
        else if ([identifier isEqualToString:kAssignmentIdentifier]) {
            
            itemType = MoodleItemTypeAssignment;
        }
        else if ([identifier isEqualToString:kURLIdentifier]) {
            
            itemType = MoodleItemTypeURL;
        }
        else if ([identifier isEqualToString:kGlossaryIdentifier]) {
            
            itemType = MoodleItemTypeGlossary;
        }
        else if ([identifier isEqualToString:kForumIdentifier]) {
            
            itemType = MoodleItemTypeForum;
        }
        else if ([identifier isEqualToString:kGalleryIdentifier]) {

            itemType = MoodleItemTypeGallery;
        }
        else if ([identifier isEqualToString:kFolderIdentifier]) {

            itemType = MoodleItemTypeFolder;
        }
        /* WE SHOW THE STANDART "OTHER" ICON
        else if ([[string lastPathComponent] isEqualToString:kPageIdentifier]) {
            
            itemType = MoodleItemTypeFolder;
        }
        */
    
    }
    return itemType;
}


- (MoodleDocumentType)documentTypeFromString:(NSString *)string {
    
    MoodleDocumentType documentType = MoodleDocumentTypeOther;
    
    NSString *identifier = [string lastPathComponent];
    
    if ([identifier isEqualToString:kDocIconURLPDF]) {
        
        documentType = MoodleDocumentTypePDF;
    }
    else if ([identifier isEqualToString:kDocIconURLPowerPoint]) {
        
        documentType = MoodleDocumentTypePPT;
    }
    else if ([identifier isEqualToString:kDocIconURLWordDocument]) {
        
        documentType = MoodleDocumentTypeWordDocument;
    }
    else if ([identifier isEqualToString:kDocIconURLAudio]) {
        
        documentType = MoodleDocumentTypeAudioFile;
    }
    
    return documentType;
}


#pragma mark - Lazy/Getter


- (NSNumberFormatter *)numberFormatter {
    
    if (!_numberFormatter) {
        
        _numberFormatter = [[NSNumberFormatter alloc] init];
        _numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    }
    return _numberFormatter;
}


- (NSArray<NSString *> *)semesterArray {
    
    if (!_semesterArray) {
        _semesterArray = @[@"(SoSe ", @"(WiSe ", @" SoSe ", @" WiSe "];
    }
    return _semesterArray;
}


#pragma mark -
@end

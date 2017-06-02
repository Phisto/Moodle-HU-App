/*
 *  MOODLEXMLParser.m
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

#import "MOODLEXMLParser.h"

#import "MOODLECourse.h"
#import "MOODLECourseSection.h"
#import "MOODLECourseSectionItem.h"
#import "MOODLESearchItem.h"

#import "TFHpple.h"

#define kResourceIdentifier @"modtype_resource"
#define kWikiIdentifier @"modtype_ouwiki"
#define kLabelIdentifier @"modtype_label"
#define kAssignmentIdentifier @"modtype_assign"
#define kURLIdentifier @"modtype_url"
#define kForumIdentifier @"modtype_forum"
#define kGlossaryIdentifier @"modtype_glossary"
#define kGalleryIdentifier @"modtype_lightboxgallery"
#define kFolderIdentifier @"modtype_folder"
#define kPageIdentifier @"modtype_page"

#define kDocIconURLPowerPoint @"powerpoint-24"
#define kDocIconURLPDF @"pdf-24"
#define kDocIconURLWordDocument @"document-24"
#define kDocIconURLAudio @"mp3-24"

#define kSemesterArray @[@"(SoSe ", @"(WiSe ", @" SoSe ", @" WiSe "]

#define kHTMLStart @"<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01//EN\"http://www.w3.org/TR/html4/strict.dtd\"><HTML><HEAD><TITLE></TITLE></HEAD><BODY>"
#define kHTMLEnd @"</BODY></HTML>"


@interface MOODLEXMLParser (/* Private */)

@property (nonatomic, strong) NSNumberFormatter *numberFormatter;

@end



///-----------------------
/// @name IMPLEMENTATION
///-----------------------



@implementation MOODLEXMLParser

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

- (nullable NSArray<MOODLESearchItem *> *)searchResultsFromData:(NSData *)data {
    
    NSMutableArray *mutableSearchResults = [NSMutableArray array];
    
    TFHpple *searchParser = [TFHpple hppleWithHTMLData:data];
    NSString *searchString = @"//div[@class='courses course-search-result course-search-result-search']/div";
    NSArray *searchNodes = [searchParser searchWithXPathQuery:searchString];
    for (TFHppleElement *element in searchNodes) {
        
        if (element.children.count > 1) {
            
            MOODLESearchItem *item = nil;
            
            TFHppleElement *infoElement = element.children[0];
            if ([[infoElement objectForKey:@"class"] isEqualToString:@"info"]) {
                
                item = [[MOODLESearchItem alloc] init];
                
                // title
                NSString *name = [infoElement.firstChild content];
                if (name) {
                  
                    item.title = name;
                }
                else {
                    
                    break;
                }
                
                NSString *url = [infoElement.firstChild.firstChild objectForKey:@"href"];
                if (url) {
                    item.courseURL = [NSURL URLWithString:url];
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
                    NSString *summary = [summaryElement content];
                    if (summary.length > 5) {
                        
                        item.courseDescription = [NSString stringWithFormat:@"%@%@%@", kHTMLStart, summary, kHTMLEnd];
                    }
                    
                    // get teacher
                    TFHppleElement *teachersElement = contentElement.children[1];
                    NSMutableArray *muteTeacherArray = [NSMutableArray array];
                    for (TFHppleElement *teachersNode in teachersElement.children) {
                        
                        if (teachersNode.children.count > 1) {
                            
                            NSString *teacher = [teachersNode.children[1] content];
                            if (teacher) [muteTeacherArray addObject:teacher];
                        }
                    }
                    if (muteTeacherArray.count > 0) { item.teacher = [muteTeacherArray copy]; }
                    
                    // get course category
                    TFHppleElement *courseCategoryElement = contentElement.children[2];
                    if (courseCategoryElement.children.count > 1) {
                        
                        NSString *categorie = [courseCategoryElement.children[1] content];
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
                
                // section title
                NSString *name = nil;
                NSString *urlString = nil;
                
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
                section.sectionDescription = sectionSummary;
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
                
                // section title
                NSString *name = nil;
                NSString *urlString = nil;
                
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
                section.sectionDescription = sectionSummary;
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
            section.sectionDescription = sectionSummary;
            
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
    
    //NSLog(@"NAME: %@", name);
    return name;
}
/**
 
 element is node < div class='summary'>
 
 */
- (nullable NSString *)sectionSummary:(TFHppleElement *)element {
    
    NSString *summary = nil;
    
    if (element.hasChildren) {
        
        element = [element firstChild];
        summary = [element content];
        if (summary.length < 5) {
            summary = nil;
        }
        // add proper html markup
        else {

            summary = [NSString stringWithFormat:@"%@%@%@", kHTMLStart, summary, kHTMLEnd];
        }
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
                item.text = [itemElement content];
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
    
    /*
    ///!!!: we are using query not .childred because the node hierarchy is quite deep... check performance
    NSString *queryString = @"//div[@class='activityinstance']/a";
    NSArray<TFHppleElement *> *nodesArray = [element searchWithXPathQuery:queryString];
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
    */
    
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
    
    for (NSString *sem in kSemesterArray) {
        
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
    
    /*
     #define kDocIconURLPowerPoint @"powerpoint-24"
     #define kDocIconURLPDF @"pdf-24"
     #define kDocIconURLWordDocument @"document-24"
     #define kDocIconURLAudio @"mp3-24"
     */
    
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

#pragma mark -
@end









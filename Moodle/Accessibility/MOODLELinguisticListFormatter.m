/*
 *
 *  MOODLELinguisticListFormater.m
 *  Moodle
 *
 *  Copyright © 2017 Simon Gaus. All rights reserved.
 *
 */

#import "MOODLELinguisticListFormatter.h"

@interface MOODLELinguisticListFormatter (/* Private */)

@property (nonatomic, strong) NSMutableArray<NSString *> *listItems;

@end

@implementation MOODLELinguisticListFormatter


- (instancetype)init {
    
    self = [super init];
    if (self) {
        
        _listItems = [NSMutableArray array];
    }
    return self;
}


- (void)addItemToList:(NSString *)item {
    
    [self.listItems addObject:item];
}

- (NSString *)list {
    
    NSInteger numberOfItems = self.listItems.count;
    
    if (numberOfItems == 0) { return @"<empty list>"; }

    else if (numberOfItems == 1) {
        
        return self.listItems.firstObject;
    }
    else if (numberOfItems == 2) {
        
        NSString *locString = NSLocalizedString(@"%@ und %@", @"LinguisticList formatter two items");
        return [NSString stringWithFormat:locString, self.listItems[0], self.listItems[1]];
    }
    else {
        
        NSString *listString = self.listItems.firstObject;
        
        for (int i = 1 ; i < numberOfItems ; i++) {
        
            listString = [listString stringByAppendingString:@", "];
            listString = [listString stringByAppendingString:self.listItems[i]];
        }
        
        NSString *locString = NSLocalizedString(@"%@ und %@", @"LinguisticList formatter two items");
        return [NSString stringWithFormat:locString, listString, self.listItems.lastObject];
    }
}

@end

/*
 *
 *  MOODLEActivityView.m
 *  Moodle
 *
 *  Copyright © 2017 Simon Gaus. All rights reserved.
 *
 */

#import "MOODLEActivityView.h"

/* Custom Views */
#import "HUProgressIndicator.h"

///-----------------------
/// @name CONSTANTS
///-----------------------



static NSString * const kBlurryBackgroundImageName = @"blurry_bg";



///-----------------------
/// @name IMPLEMENTATION
///-----------------------



@implementation MOODLEActivityView
#pragma mark - Object Creation


+ (instancetype)activityViewWithText:(NSString *)text {
    
    CGRect frame = CGRectMake(0.0f, 0.0f, 120.0f, 120.0f);
    MOODLEActivityView *view = [[[self class] alloc] initWithFrame:frame];

    // create spinner
    HUProgressIndicator *spinning = [[HUProgressIndicator alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 80.0f, 80.0f)];
    spinning.backgroundColor = [UIColor clearColor];
    spinning.color = [UIColor blackColor];
    [spinning setCenter:CGPointMake(frame.size.width/2.0f, frame.size.height*0.43f)];
    [view addSubview:spinning];
    [spinning startAnimating];
    
    [NSMutableArray array];
    
    // create label
    UILabel *loadLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 90.0f, 22.0f)];
    loadLabel.text = text;
    loadLabel.font = [UIFont systemFontOfSize:18.0f weight:UIFontWeightLight];
    
    loadLabel.textAlignment = NSTextAlignmentCenter;
    loadLabel.textColor = [UIColor blackColor];
    loadLabel.backgroundColor = [UIColor clearColor];
    [loadLabel setCenter:CGPointMake(view.frame.size.width/2.0f, view.frame.size.height*0.88f)];
    [view addSubview:loadLabel];
    
    return view;
}


+ (instancetype)activityView {
    
    CGRect frame = CGRectMake(0.0f, 0.0f, 120.0f, 120.0f);
    MOODLEActivityView *view = [[[self class] alloc] initWithFrame:frame];
    
    // create label
    HUProgressIndicator *spinning = [[HUProgressIndicator alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
    spinning.backgroundColor = [UIColor clearColor];
    spinning.color = [UIColor blackColor];
    [spinning setCenter:CGPointMake(frame.size.width/2.0f, frame.size.height/2.0f)];
    [view addSubview:spinning];
    [spinning startAnimating];
    
    return view;
}


- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.clipsToBounds = YES;
        self.layer.cornerRadius = 15;
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:self.bounds];
        imgView.image = [UIImage imageNamed:kBlurryBackgroundImageName];
        [self addSubview:imgView];
        
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
        UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        [blurEffectView setFrame:self.bounds];
        [self addSubview:blurEffectView];
    }
    return self;
}


#pragma mark -
@end

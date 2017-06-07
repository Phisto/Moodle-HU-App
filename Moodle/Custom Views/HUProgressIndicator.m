/*
 *  HUProgressIndicator.m
 *  Moodle
 *
 *  Created by Simon Gaus on 03.06.17.
 *  Copyright © 2017 Simon Gaus. All rights reserved.
 *
 */

#import "HUProgressIndicator.h"

///-----------------------
/// @name CONSTANTS
///-----------------------



static NSString * const kSmallBezierPathData = @"bezierdata_w80_h80";
static NSString * const kBigBezierPathData = @"bezierdata_w120_h120";



///-----------------------
/// @name CATEGORIES
///-----------------------



@interface HUProgressIndicator (/* Private */)

@property (nonatomic, readwrite) NSInteger count;
@property (nonatomic, readwrite) NSInteger maxCount;
@property (nonatomic, readwrite) BOOL forward;

@property (nonatomic, strong) dispatch_source_t timer;
@property (nonatomic, strong) NSArray<UIBezierPath *> *bezierPathArray;

@end



///-----------------------
/// @name IMPLEMENTATION
///-----------------------



@implementation HUProgressIndicator
#pragma mark - View Class Methodes


+ (Class)layerClass {
    return [CAShapeLayer class];
}


#pragma mark - View Methodes


- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        _animating = NO;
        _hidesWhenStopped = NO;
        _color = [UIColor blackColor];
        _style = (frame.size.height < 120.0f ) ? HUProgressIndicatorStyleSmall : HUProgressIndicatorStyleLarge;
        _count = 0;
        _forward = YES;
        
        [self setUnarchiveBezierPaths];
        
        _maxCount = _bezierPathArray.count;
        
        CAShapeLayer *shapeLayer = (CAShapeLayer *)self.layer;
        shapeLayer.lineWidth = 0.1;
        shapeLayer.strokeColor = _color.CGColor;
        shapeLayer.fillColor = _color.CGColor;
    }
    return self;
}


- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        _animating = NO;
        _hidesWhenStopped = NO;
        _color = [UIColor blackColor];
        _style = (self.frame.size.height < 120.0f ) ? HUProgressIndicatorStyleSmall : HUProgressIndicatorStyleLarge;
        _count = 0;
        _forward = YES;
        
        [self setUnarchiveBezierPaths];
        
        _maxCount = _bezierPathArray.count;
        
        CAShapeLayer *shapeLayer = (CAShapeLayer *)self.layer;
        shapeLayer.lineWidth = 0.1f;
        shapeLayer.strokeColor = _color.CGColor;
        shapeLayer.fillColor = _color.CGColor;
    }
    return self;
}


- (void)awakeFromNib {
    
    // call super
    [super awakeFromNib];

    if (self.animating) {
        [self startAnimating];
    }
}


- (void)dealloc {

    self.timer = nil;
}

#pragma mark - Drawing Methodes


- (void)drawRect:(CGRect)rect {
    
    // sett frame so circle will be inside frame (line stroke is 0.5 outside)
    CGRect circleRect = CGRectMake(
                                   self.bounds.origin.x+0.5f,
                                   self.bounds.origin.y+0.5f,
                                   self.bounds.size.width-1,
                                   self.bounds.size.height-1
                                   );
    
    
    //// Circle Drawing
    UIBezierPath* circlePath1 = [UIBezierPath bezierPathWithOvalInRect:circleRect];
    [self.color setStroke];
    circlePath1.lineWidth = 1.0f;
    circlePath1.lineJoinStyle = kCGLineJoinRound;
    [circlePath1 stroke];
    
    
    circleRect = CGRectMake(
                            circleRect.origin.x+3.0f,
                            circleRect.origin.y+3.0f,
                            circleRect.size.width-6.0f,
                            circleRect.size.height-6.0f
                            );
    
    //// Circle Drawing
    UIBezierPath* circlePath2 = [UIBezierPath bezierPathWithOvalInRect:circleRect];
    [self.color setStroke];
    circlePath2.lineWidth = 0.5f;
    circlePath2.lineJoinStyle = kCGLineJoinRound;
    [circlePath2 stroke];
}


#pragma mark - Animation Methodes


///!!!: Refactor when quiting iOS 9.x support
- (void)startAnimating {
    
    
    // if we are already animating
    if (self.animating) {
        
        self.timer = nil;
    }
    
    self.hidden = NO;
    
    self.animating = YES;
    
    /*
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.015f
                                                 repeats:YES
                                                   block:^(NSTimer * _Nonnull timer) {
     
                                                       [weakSelf customDrawShape];
                                                   }];
    */
    
    // i use this to prevent a retain cycle
    // when just using a nstimer the timer will hold
    // a strong reference to self and dealloc will
    // newer be called to invalidate the timer,
    // hence the timer will never stop
    typeof(self) __weak weakSelf = self;
    
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    dispatch_source_set_timer(self.timer, DISPATCH_TIME_NOW, 0.015f * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(self.timer, ^{
        
        [weakSelf customDrawShape];
    });
    dispatch_resume(self.timer);
}


- (void)stopAnimating {
    
    self.timer = nil;
    
    if (self.hidesWhenStopped) {
        
        self.hidden = YES;
    }
    
    self.animating = NO;
}


#pragma mark - Drawing Methodes


- (void)customDrawShape {
    
    // set fill color
    CAShapeLayer *shapeLayer = (CAShapeLayer *)self.layer;
    NSInteger counter = self.count;
    NSInteger maxIndex = self.maxCount-1;
    BOOL reverse = YES;
    
    UIBezierPath *currentPath = [[UIBezierPath alloc] init];
    
    if (self.forward) {
        
        for (NSInteger i = 0 ; i <= counter ; i++) {
            
            [currentPath appendPath:self.bezierPathArray[( (reverse) ? (maxIndex-i) : i )]];
            reverse = !reverse;
        }
        
        shapeLayer.path = currentPath.CGPath;
    }
    else {
        
        for (NSInteger i = maxIndex ; i >= counter ; i--) {
            
            [currentPath appendPath:self.bezierPathArray[( (reverse) ? (maxIndex-i) : i )]];
            reverse = !reverse;
        }
        
        shapeLayer.path = currentPath.CGPath;
    }
    
    // increment counter
    self.count++;
    
    // reset counter
    if (self.count == self.maxCount) {
        self.count = 0;
        self.forward = !self.forward;
    }
}


#pragma mark - Helper Methodes


- (void)setUnarchiveBezierPaths {
    
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *resourceName = (self.style == HUProgressIndicatorStyleSmall) ? kSmallBezierPathData : kBigBezierPathData;
    NSString* myImage = [mainBundle pathForResource:resourceName ofType:@"archive"];
    NSMutableArray *dataArray = [NSKeyedUnarchiver unarchiveObjectWithFile:myImage];
    _bezierPathArray = dataArray;
}


#pragma mark -
@end

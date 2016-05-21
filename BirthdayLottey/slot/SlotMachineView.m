//
//  SlotMachineView.m
//  Lottey
//
//  Created by yexifeng on 15/12/24.
//  Copyright © 2015年 moregood. All rights reserved.
//


#import <QuartzCore/QuartzCore.h>
#import <QuartzCore/CATextLayer.h>

#import "SlotMachineView.h"
#import "MyCATextLayer.h"
#import "DataBaseManager.h"



static BOOL isSliding = NO;


/********************************************************************************************/

@implementation SlotMachineView {
}

#pragma mark - View LifeCycle

- (id)init{
    self = [super init];
    if (self) {
        contentInset = UIEdgeInsetsMake(25, 8, 25, 20);
        backgroundImageView = [[UIImageView alloc] init];
        backgroundImageView.image = [UIImage imageNamed:@"SlotMachineBackground.png"];
        CGSize viewSize = backgroundImageView.image.size;
        [self addSubview:backgroundImageView];
         CGRect r = CGRectMake(contentInset.left, contentInset.top, viewSize.width - contentInset.left - contentInset.right, viewSize.height - contentInset.top - contentInset.bottom);
        contentView = [[UIView alloc] initWithFrame:r];
#if SHOW_BORDER
        contentView.layer.borderColor = [NSColor blueColor].CGColor;
        contentView.layer.borderWidth = 1;
#endif
        
        [self addSubview:contentView];
        coverImageView = [[UIImageView alloc] init];
        coverImageView.image = [UIImage imageNamed:@"SlotMachineCover.png"];
        [self addSubview:coverImageView];
        
        slotScrollLayerArray = [NSMutableArray array];
        
        self.singleUnitDuration = 1.5f/(NUMBER_UNIT_OF_A_COLUMN*kMinTurn);
        
        [self initView];
    }
    return self;
}


-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    CGSize viewSize = frame.size;
    CGRect r = CGRectMake(0, 0, viewSize.width, viewSize.height);
    backgroundImageView.frame = r;
    contentView.frame = CGRectMake(contentInset.left, contentInset.top, viewSize.width - contentInset.left - contentInset.right, viewSize.height - contentInset.top - contentInset.bottom);
    coverImageView.frame = r;
    [self setLayersSize];
    [self reloadData];
}

#pragma mark - Properties Methods



- (UIEdgeInsets)contentInset {
    return contentInset;
}

- (void)setContentInset:(UIEdgeInsets)inset {
    contentInset = inset;
    
    CGRect viewFrame = self.frame;
    CGRect r = CGRectMake(contentInset.left, contentInset.top, viewFrame.size.width - contentInset.left - contentInset.right, viewFrame.size.height - contentInset.top - contentInset.bottom);
    contentView.frame = r;
}


- (void)setSlotResults:(NSArray *)results {
    if (!isSliding) {
        _slotResults = results;
    }
}

- (id<SlotMachineDataSource>)dataSource {
    return dataSource;
}

- (void)setDataSource:(id<SlotMachineDataSource>)data {
    dataSource = data;
    slotData = [self.dataSource textForSlotsInSlotMachine:self];
    [self reloadData];
}

-(void)initView{
    for ( int i=0;i< contentView.layer.sublayers.count;i++) {
        CALayer *containerLayer = contentView.layer.sublayers[i];
        [containerLayer removeFromSuperlayer];
    }
    [contentView setNeedsLayout];
    slotScrollLayerArray = [NSMutableArray array];
    
    CGFloat slotSpacing = 0;
    if ([self.dataSource respondsToSelector:@selector(slotSpacingInSlotMachine:)]) {
        slotSpacing = [self.dataSource slotSpacingInSlotMachine:self];
    }
    
    CGFloat slotWidth = contentView.frame.size.width / NUMBER_OF_SLOT_IN_SLOTMACHINE;
    if ([self.dataSource respondsToSelector:@selector(slotWidthInSlotMachine:)]) {
        slotWidth = [self.dataSource slotWidthInSlotMachine:self];
    }
    
    for (int i = 0; i < NUMBER_OF_SLOT_IN_SLOTMACHINE; i++) {
        CALayer *slotContainerLayer = [[CALayer alloc] init];
        slotContainerLayer.frame = CGRectMake(i * (slotWidth + slotSpacing), 0, slotWidth, contentView.frame.size.height);
        slotContainerLayer.masksToBounds = YES;
        
        CATextLayer *slotScrollLayer = [[MyCATextLayer alloc] init];
        slotScrollLayer.frame = CGRectMake(0, 0, slotWidth, contentView.frame.size.height);
        [slotScrollLayer setFont:TEXT_FONT];
#if SHOW_BORDER
        slotScrollLayer.borderColor = [NSColor greenColor].CGColor;
        slotScrollLayer.borderWidth = 1;
#endif
        [slotContainerLayer addSublayer:slotScrollLayer];
        
        [contentView.layer addSublayer:slotContainerLayer];
        
        [slotScrollLayerArray addObject:slotScrollLayer];
    }
    
    CGFloat singleUnitHeight = contentView.frame.size.height / 2-contentInset.top*2;
    
    for (int i = 0; i < NUMBER_OF_SLOT_IN_SLOTMACHINE; i++) {
        CALayer *slotScrollLayer = [slotScrollLayerArray objectAtIndex:i];
        NSInteger scrollLayerTopIndex = (i + kMinTurn + 3) * NUMBER_UNIT_OF_A_COLUMN;
        //            NSLog(@"scrollLayerTopIndex=%ld",(long)scrollLayerTopIndex);
        for (int j = 0; j < scrollLayerTopIndex; j++) {
           CATextLayer *textStringLayer = [[CATextLayer alloc] init];
            // adjust the beginning offset of the first unit
            NSInteger offsetYUnit = j + 1 - NUMBER_UNIT_OF_A_COLUMN;
//            [textStringLayer setBackgroundColor:i==1?j%2==0?[NSColor blueColor].CGColor:[NSColor greenColor].CGColor:[NSColor purpleColor].CGColor];
            [self setCaLayerProperty:textStringLayer rect:CGRectMake(0, offsetYUnit * singleUnitHeight-singleUnitHeight*0.6, slotScrollLayer.frame.size.width, singleUnitHeight)];
            [slotScrollLayer addSublayer:textStringLayer];
        }
    }
}

-(void)setLayersSize{
    CGFloat slotSpacing = 0;
    if ([self.dataSource respondsToSelector:@selector(slotSpacingInSlotMachine:)]) {
        slotSpacing = [self.dataSource slotSpacingInSlotMachine:self];
    }
    
    CGFloat slotWidth = contentView.frame.size.width / NUMBER_OF_SLOT_IN_SLOTMACHINE;
    
    NSArray* contentViewLayers = contentView.layer.sublayers;
    for (int i = 0; i < NUMBER_OF_SLOT_IN_SLOTMACHINE; i++) {
        CALayer *slotContainerLayer = contentViewLayers[i];
        slotContainerLayer.frame = CGRectMake(i * (slotWidth + slotSpacing), 0, slotWidth, contentView.frame.size.height);
        CATextLayer *slotScrollLayer = slotScrollLayerArray[i];
        slotScrollLayer.frame = CGRectMake(0, 0, slotWidth, contentView.frame.size.height);
        
    }
    
    CGFloat singleUnitHeight = contentView.frame.size.height / 2;
    
    for (int i = 0; i < NUMBER_OF_SLOT_IN_SLOTMACHINE; i++) {
        CALayer *slotScrollLayer = [slotScrollLayerArray objectAtIndex:i];
        NSInteger scrollLayerTopIndex = (i + kMinTurn + 3) * NUMBER_UNIT_OF_A_COLUMN;
        for (int j = 0; j < scrollLayerTopIndex; j++) {
            CATextLayer *textStringLayer = slotScrollLayer.sublayers[i];
            [textStringLayer setFontSize:MIN(MAX_TEXT_FONT_SIZE, 10)];
            NSInteger offsetYUnit = j + 1 - NUMBER_UNIT_OF_A_COLUMN;
            [self setCaLayerProperty:textStringLayer rect:CGRectMake(0, offsetYUnit * singleUnitHeight-singleUnitHeight*0.6, slotScrollLayer.frame.size.width, singleUnitHeight)];
//            if(j==10){
//                NSLog(@"textStringLayer=%@",NSStringFromRect(textStringLayer.frame));
//            }
        }
    }
}


- (void)reloadData {
    if (self.dataSource) {
        NSUInteger numberOfSlots = [self.dataSource numberOfSlotsInSlotMachine:self];
        
         CGFloat singleUnitHeight = contentView.frame.size.height / 2;
        for (int i = 0; i < numberOfSlots; i++) {
            NSArray* arrayOfAColumn = slotData[i];//单列数据
            CALayer *slotScrollLayer = [slotScrollLayerArray objectAtIndex:i];
            NSArray* textStringLayers = slotScrollLayer.sublayers;
            for (int j = 0; j < textStringLayers.count; j++) {
                NSString *textString = [arrayOfAColumn objectAtIndex:abs(j) % NUMBER_UNIT_OF_A_COLUMN];
                CATextLayer *textStringLayer = textStringLayers[j];
                if(![textString hasPrefix:@"empty"]){
                    NSInteger offsetYUnit = j + 1 - NUMBER_UNIT_OF_A_COLUMN;
                    [self setCaLayerProperty:textStringLayer rect:CGRectMake(0, offsetYUnit * singleUnitHeight-singleUnitHeight*0.4, slotScrollLayer.frame.size.width, singleUnitHeight)];
                    textStringLayer.string = textString;
                }else{
                    textStringLayer.string = @"";
                }
            }
        }
    }
}

-(void)setCaLayerProperty:(CATextLayer*)textStringLayer rect:(CGRect)rect{
    textStringLayer.frame = rect;
    [textStringLayer setFont:TEXT_FONT];
    textStringLayer.contentsGravity = kCAGravityBottom;
//    [textStringLayer setBackgroundColor:random()%2==0?[UIColor blackColor].CGColor:[UIColor redColor].CGColor];
    [textStringLayer setFontSize:MIN(MAX_TEXT_FONT_SIZE, rect.size.height*0.7)];
#if SHOW_BORDER
    textStringLayer.borderColor = [NSColor redColor].CGColor;
    textStringLayer.borderWidth = 1;
#endif
    
    [textStringLayer setAlignmentMode:kCAAlignmentCenter];
    [textStringLayer setNeedsLayout];

}



#pragma mark - Public Methods

- (void)startSliding {
    
    if (isSliding) {
        return;
    }
    else {
        isSliding = YES;
        
        if ([self.delegate respondsToSelector:@selector(slotMachineWillStartSliding:)]) {
            [self.delegate slotMachineWillStartSliding:self];
        }
        
//        NSArray *slotTextData = [self.dataSource textForSlotsInSlotMachine:self];
        
        [CATransaction begin];
        
        [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];//[CAMediaTimingFunction functionWithControlPoints:0 :0.5 :0.75 :1]];
        [CATransaction setDisableActions:YES];
        [CATransaction setCompletionBlock:^{
            isSliding = NO;
            if ([self.delegate respondsToSelector:@selector(slotMachineDidEndSliding:)]) {
                [self.delegate slotMachineDidEndSliding:self];
            }

        }];
        
        static NSString * const keyPath = @"position.y";
        
        for (int i = 0; i < [slotScrollLayerArray count]; i++) {
            NSArray* arrayOfAColumn = slotData[i];//单列数据
            NSUInteger slotIconsCount = [arrayOfAColumn count];
            CALayer *slotScrollLayer = [slotScrollLayerArray objectAtIndex:i];
//            NSLog(@"columnResult=%@",_slotResults[i]);
            NSUInteger resultIndex = [arrayOfAColumn indexOfObject:_slotResults[i]];
//            NSLog(@"%d,resultIndex=%ld",i,resultIndex);
            NSUInteger howManyUnit = (i + kMinTurn) * slotIconsCount + resultIndex;
            CGFloat slideY = howManyUnit * (contentView.frame.size.height / 2);
            
            CABasicAnimation *slideAnimation = [CABasicAnimation animationWithKeyPath:keyPath];
            slideAnimation.fillMode = kCAFillModeForwards;
            slideAnimation.duration = howManyUnit * self.singleUnitDuration;
            slideAnimation.toValue = [NSNumber numberWithFloat:slotScrollLayer.position.y - slideY];
            slideAnimation.removedOnCompletion = NO;
            
            [slotScrollLayer addAnimation:slideAnimation forKey:@"slideAnimation"];
        }
        
        [CATransaction commit];
    }
}

-(void)scaleLayer{
    [self reloadData];
}

@end

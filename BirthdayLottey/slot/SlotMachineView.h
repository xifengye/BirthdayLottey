//
//  SlotMachineView.h
//  Lottey
//
//  Created by yexifeng on 15/12/24.
//  Copyright © 2015年 moregood. All rights reserved.
//


#import <UIKit/UIKit.h>

#define SHOW_BORDER 0
#define TEXT_FONT       @"Helvetica-Bold"
#define MAX_TEXT_FONT_SIZE  70
//#define SINGLE_UNIT_DURATION  0.09

#define NUMBER_UNIT_OF_A_COLUMN 13
#define NUMBER_OF_SLOT_IN_SLOTMACHINE   3
#define textColor   [NSColor yellowColor]

static const NSUInteger kMinTurn = 2;
@class SlotMachineView;


@protocol SlotMachineDelegate <NSObject>

@optional
- (void)slotMachineWillStartSliding:(SlotMachineView *)slotMachine;
- (void)slotMachineDidEndSliding:(SlotMachineView *)slotMachine;

@end

@protocol SlotMachineDataSource <NSObject>

@required
- (NSUInteger)numberOfSlotsInSlotMachine:(SlotMachineView *)slotMachine;
- (NSArray*)textForSlotsInSlotMachine:(SlotMachineView *)slotMachine;

@optional
- (CGFloat)slotWidthInSlotMachine:(SlotMachineView *)slotMachine;
- (CGFloat)slotSpacingInSlotMachine:(SlotMachineView *)slotMachine;

@end

#pragma mark - SlotMachineView

@interface SlotMachineView : UIView{
    UIImageView *backgroundImageView;
    UIImageView *coverImageView;
    UIView *contentView;
    UIEdgeInsets contentInset;
    NSMutableArray *slotScrollLayerArray;
    
    // Data
    NSArray *slotData;
    
    __weak id<SlotMachineDataSource> dataSource;

}

/****** UI Properties ******/
@property (nonatomic) UIEdgeInsets contentInset;
@property (nonatomic, strong) UIImage *backgroundImage;
@property (nonatomic, strong) UIImage *coverImage;

/****** Data Properties ******/
@property (nonatomic, strong) NSArray *slotResults;

/****** Animation ******/

// You can use this property to control the spinning speed, default to 0.14f
@property (nonatomic) CGFloat singleUnitDuration;

@property (nonatomic, weak) id <SlotMachineDelegate> delegate;
@property (nonatomic, weak) id <SlotMachineDataSource> dataSource;

- (void)startSliding;

- (void)reloadData;


@end

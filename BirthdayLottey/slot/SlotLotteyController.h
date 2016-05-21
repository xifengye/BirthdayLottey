//
//  SlotLotteyController.h
//  Lottey
//
//  Created by yexifeng on 16/1/7.
//  Copyright © 2016年 moregood. All rights reserved.
//

#import "SlotMachineView.h"
#import "Employee.h"
#import "RandomHelper.h"
#import "NSMutableArray+NSMutableArrayList.h"

@interface SlotLotteyController : UIViewController{
    BOOL slotTextWithAwardName;
    Employee* currentRewardEmployee;
    RandomHelper* randomHelper;
    
 
}
   @property (weak, nonatomic) IBOutlet UIButton  *start;
@property(weak,nonatomic)IBOutlet UIImageView* bgView;
@end

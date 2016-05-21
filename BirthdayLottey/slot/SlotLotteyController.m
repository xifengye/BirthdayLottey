//
//  SlotLotteyController.m
//  Lottey
//
//  Created by yexifeng on 16/1/7.
//  Copyright © 2016年 moregood. All rights reserved.
//

#import "SlotLotteyController.h"

#import "SlotMachineView.h"
#import "DataBaseManager.h"
#import "MyCAHelper.h"
#define DELAY_SHOW_RESULT   3



static NSString* word = @"实际上它是一个很奇怪的函数先加速然后减速最后快到达终点的时候又加速那么标准的缓冲函数又该如何用这条曲线的斜率代表了速度斜率的改变代表了加速度原则上来说任何加速的曲线都可以用这种图像来表示但是使用了一个叫做三次贝塞尔曲线";

@interface SlotLotteyController ()

@property(nonatomic,weak)SlotMachineView *slotMachine;
@property(nonatomic,weak)UIButton *startButton;


@property(nonatomic,strong)NSMutableArray* employees;

@property(nonatomic,strong)NSArray* partOfSlotTextArray;


@property(nonatomic,assign)NSUInteger slotResultIndex;

@end

@implementation SlotLotteyController


- (void)viewDidLoad {
    [super viewDidLoad];
    randomHelper = [[RandomHelper alloc]init];
    [self initData];
    [self initViews];
    [self setViewSize];
    
}

-(void)viewWillAppear:(BOOL)animated{
    
}

-(void)viewDidAppear:(BOOL)animated{
    self.bgView.frame = self.view.frame;
}

-(void)initData{
    slotTextWithAwardName = true;
    self.employees = [NSMutableArray arrayWithArray:[[DataBaseManager sharedManager] employeeByBirthday]];
    if(self.employees.count<=0){
        [self.employees addObject:[Employee employeeWithParam:@"" name:@"人不够" sex:0 country:@"" url:@"" mob:1 dob:1 dept:@"" accession_data:@""]];
    }
    NSLog(@"有 %lu 人",(unsigned long)self.employees.count);
    [self.slotMachine setDataSource:self];

}


#pragma mark - initViews
-(void)initViews{
    
    //老虎机
    SlotMachineView* slotMachine = [[SlotMachineView alloc] init];
    
    
    slotMachine.delegate = self;
    slotMachine.dataSource = self;
    
    [self.view addSubview:slotMachine];
    self.slotMachine = slotMachine;
    
    
    
    //开始按钮
    [_start setTitle:@"开始" forState:UIControlStateNormal];
    //[_start setBackgroundImage:[UIImage imageNamed:@"btn_lottey"] forState:UIControlStateNormal];
    [_start addTarget:self action:@selector(start:) forControlEvents:UIControlEventTouchDown];
    
}




-(void)setViewSize{
    CGSize viewSize = self.view.frame.size;
    
    
    //老虎机
    CGFloat slotHeight = viewSize.height*0.3;
    CGSize slotSize = CGSizeMake(slotHeight*2.025 , slotHeight);
    
    self.slotMachine.frame = CGRectMake((viewSize.width-slotSize.width)/2, (viewSize.height-slotSize.height)/3, slotSize.width,slotSize.height);
    

  }


-(void)randomIndex{
    int index = [randomHelper random:self.employees.count-1];
    self.slotResultIndex = index;
    [self slotIndexReslut];
}

-(void)slotIndexReslut{
    currentRewardEmployee = self.employees[self.slotResultIndex];
   }

//从列表中删除已中奖员工
-(void)deleteRewardEmployeeFromArray{
    
}

//-(void)randomIndexOfArrayIndex{
//    NSMutableArray<NSNumber*>* arrayIndex = [NSMutableArray array];
//    for(int i=0;i<10;i++){
//        NSUInteger index = arc4random()%self.employees.count;
//        [arrayIndex addObject:[NSNumber numberWithInteger:index]];
//    }
//    int randomIndex = arc4random()%arrayIndex.count;
//    self.slotResultIndex = [arrayIndex objectAtIndex:randomIndex].integerValue;
//    [self slotIndexReslut];
//}

#pragma mark - 点击抽奖

- (void)start:(id)sender {
    if(self.employees.count<=0){
        return;
    }
    [self randomIndex];
    NSLog(@"中奖Index=%lu,name=%@",(unsigned long)self.slotResultIndex,currentRewardEmployee.name);
    NSString* value = currentRewardEmployee.name;
//    self.rewardResultView.stringValue = value;
    
    self.slotMachine.slotResults = [self splitorName:value];
    [self.slotMachine setDataSource:self];
    
    [self.slotMachine startSliding];
}

#pragma mark - UIResponder

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    
    _startButton.highlighted = YES;
    [_startButton performSelector:@selector(setHighlighted:) withObject:[NSNumber numberWithBool:NO] afterDelay:0.8];
    
    [self start:nil];
}


#pragma mark - SlotMachineViewDelegate

- (void)slotMachineWillStartSliding:(SlotMachineView *)slotMachine {
    self.startButton.enabled = NO;
}

- (void)slotMachineDidEndSliding:(SlotMachineView *)slotMachine {
    self.startButton.enabled = YES;
    if(currentRewardEmployee!=nil){
        [self.employees removObject:currentRewardEmployee];
    }
    
}









#pragma mark - SlotMachineViewDataSource


- (NSArray *)textForSlotsInSlotMachine:(SlotMachineView *)slotMachine {
    Employee* e = self.employees[self.slotResultIndex];
    NSString* rewardName = e.name;
    NSArray* nameSplit = [self splitorName:rewardName];
    NSMutableArray* result = [NSMutableArray array];
    [result addObject:[NSArray arrayWithObject:nameSplit[0]]];
    [result addObject:[NSArray arrayWithObject:nameSplit[1]]];
    [result addObject:[NSArray arrayWithObject:nameSplit[2]]];
    result = [self fillArray:result];
//    NSLog(@"names:%@",[self stringFromArray:result]);
    return result;
}

-(NSString*)stringFromArray:(NSArray*) array{
    NSMutableString* result = [NSMutableString string];
    for(int i=0;i<array.count;i++){
        NSObject* arr = array[i];
        if([arr isKindOfClass:[NSArray class]]){
            [result appendString:[NSString stringWithFormat:@"\n[%@]",[self stringFromArray:arr]]];
        }else{
            [result appendString:[NSString stringWithFormat:@"%@,",arr]];
        }
    }
    return result;
}

-(int)randomTempIndex{
    int index = arc4random()%self.employees.count;
    while (index==self.slotResultIndex && self.employees.count>1) {
        return [self randomTempIndex];
    }
    return index;
}

-(NSArray*)fillArray:(NSArray*)array{
    NSMutableArray* resultArray = [NSMutableArray array];
    for(int i=0;i<array.count;i++){
        NSMutableArray* ms = [NSMutableArray arrayWithArray:array[i]];
        int doCount = 0;
        while (ms.count<NUMBER_UNIT_OF_A_COLUMN) {
            Employee* e = self.employees[[self randomTempIndex]];
            NSString* name = e.name;
            if(name.length>2){
                NSArray* nameSplite = [self splitorName:name];
                [self addObject:ms useObject:nameSplite[i]];
            }
            
            if(doCount++>NUMBER_UNIT_OF_A_COLUMN*2 && ms.count<NUMBER_UNIT_OF_A_COLUMN){
                
                [self addObject:ms useObject:[word substringWithRange: NSMakeRange(arc4random()%(word.length-1)+1, 1)]];
            }
        }
        id obj = ms[0];
        int index=NUMBER_UNIT_OF_A_COLUMN/2+i;
        ms[0] = ms[index];
        ms[index] = obj;
        
        [resultArray addObject:ms];
    }
    return resultArray;
}

-(void)addObject:(NSMutableArray*)array useObject:(NSString*)value{
    if(![array containsObject:value]){
        [array addObject:value];
    }
}

- (NSUInteger)numberOfSlotsInSlotMachine:(SlotMachineView *)slotMachine {
    return NUMBER_OF_SLOT_IN_SLOTMACHINE;
}

- (CGFloat)slotWidthInSlotMachine:(SlotMachineView *)slotMachine {
    return 65.0f;
}

- (CGFloat)slotSpacingInSlotMachine:(SlotMachineView *)slotMachine {
    return 5.0f;
}

-(NSArray*)splitorName:(NSString*)value{
    NSString* s1=nil;
    NSString* s2 = nil;
    NSString* s3 = nil;
    if(value.length<=2){//两个字
        s1 = [value substringWithRange:NSMakeRange(0, 1)];
        s2 = @"empty";
        s3 = [value substringWithRange:NSMakeRange(1, 1)];
    }else if(value.length==3){//三个字
        s1 = [value substringWithRange:NSMakeRange(0, 1)];
        s2 = [value substringWithRange:NSMakeRange(1, 1)];
        s3 = [value substringWithRange:NSMakeRange(2, 1)];
        
    }else{//大于三个字
        int q = value.length/3;
        s1 = [value substringWithRange:NSMakeRange(0, q)];
        s2 = [value substringWithRange:NSMakeRange(q, q)];
        s3 = [value substringWithRange:NSMakeRange(q*2, value.length-q*2)];
    }
    return @[s1,s2,s3];
}




@end

//
//  TodayBirthdayViewController.h
//  BirthdayLottey
//
//  Created by yexifeng on 16/4/22.
//  Copyright © 2016年 moregood. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TodayBirthdayViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView* tableView;
@property (weak, nonatomic) IBOutlet UIDatePicker* datePicker;
@property (weak, nonatomic) IBOutlet UISwitch* btnMonth;
@property (weak, nonatomic) IBOutlet UILabel* numberLabel;
@end

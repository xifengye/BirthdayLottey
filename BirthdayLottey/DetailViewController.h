//
//  DetailViewController.h
//  BirthdayLottey
//
//  Created by yexifeng on 16/4/21.
//  Copyright © 2016年 moregood. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "model/Employee.h"

@interface DetailViewController : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate>{
    BOOL addMode;
}

@property (strong, nonatomic) Employee* detailItem;
@property (weak, nonatomic) IBOutlet UILabel  *labelName;
@property (weak, nonatomic) IBOutlet UILabel  *labelDept;
@property (weak, nonatomic) IBOutlet UILabel  *labelNumber;
@property (weak, nonatomic) IBOutlet UILabel  *labelBirthday;
@property (weak, nonatomic) IBOutlet UILabel  *labelAccessionDate;
@property (weak, nonatomic) IBOutlet UILabel  *labelCountry;
@property (weak, nonatomic) IBOutlet UIImageView  *profile;



@property(weak,nonatomic) IBOutlet UIView* addPanel;
@property(weak,nonatomic) IBOutlet UIView* detailPanel;

@property (weak, nonatomic) IBOutlet UITextField* tfName;
@property (weak, nonatomic) IBOutlet UITextField* tfNumber;
@property (weak, nonatomic) IBOutlet UISwitch* sSex;
@property (weak, nonatomic) IBOutlet UIPickerView* pvMonth;
@property (weak, nonatomic) IBOutlet UIPickerView* pvDay;
@property (weak, nonatomic) IBOutlet UIPickerView* pvDept;


-(void)showAddEmployeePanel;

@end


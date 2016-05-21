//
//  Employee.h
//  BirthdayLottey
//
//  Created by yexifeng on 16/4/21.
//  Copyright © 2016年 moregood. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ModelBase.h"

@interface Employee : ModelBase
@property(nonatomic,copy)NSString* number;//工号
@property(nonatomic,copy)NSString* name;//姓名
@property(nonatomic,assign)int sex;
@property(nonatomic,copy)NSString* country;//国家
@property(nonatomic,copy)NSString* profile_image_url;//头像
@property(nonatomic,assign)int mob;//生日月
@property(nonatomic,assign)int dob;//生日天
@property(nonatomic,copy)NSString* dept;//部门
@property(nonatomic,copy)NSString* accession_date;//入职时间

-(NSString*) sexStr;

-(instancetype)initWithParam:(NSString*)number name:(NSString*)name sex:(int)sex country:(NSString*)country url:(NSString*)url mob:(int)monthOfBirthday dob:(int)dayOfBirthday dept:(NSString*)dept accession_data:(NSString*)accession_data;

+(instancetype)employeeWithParam:(NSString*)number name:(NSString*)name sex:(int)sex country:(NSString*)country url:(NSString*)url mob:(int)monthOfBirthday dob:(int)dayOfBirthday dept:(NSString*)dept accession_data:(NSString*)accession_data;

@end

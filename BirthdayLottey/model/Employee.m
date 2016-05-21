//
//  Employee.m
//  BirthdayLottey
//
//  Created by yexifeng on 16/4/21.
//  Copyright © 2016年 moregood. All rights reserved.
//

#import "Employee.h"

@implementation Employee

-(instancetype)initWithParam:(NSString *)number name:(NSString *)name sex:(int)sex country:(NSString *)country url:(NSString *)url mob:(int)monthOfBirthday dob:(int)dayOfBirthday dept:(NSString *)dept accession_data:(NSString *)accession_data{
    self = [super init];
    if(self){
        self.number = number;
        self.name = name;
        self.sex = sex;
        self.country = country;
        self.profile_image_url = url;
        self.mob = monthOfBirthday;
        self.dob = dayOfBirthday;
        self.dept = dept;
        self.accession_date = accession_data;
    }
    return self;
}

+(instancetype)employeeWithParam:(NSString *)number name:(NSString *)name sex:(int)sex country:(NSString *)country url:(NSString *)url mob:(int)monthOfBirthday dob:(int)dayOfBirthday dept:(NSString *)dept accession_data:(NSString *)accession_data{
    Employee* e = [[Employee alloc] initWithParam:number name:name sex:sex country:country url:url mob:monthOfBirthday dob:dayOfBirthday dept:dept accession_data:accession_data];
    return e;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@  %@", _name,_number];
}

-(NSString *)sexStr{
    return _sex==0?@"男":@"女";
}

@end

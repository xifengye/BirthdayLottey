//
//  DataBaseTool.h
//  Lottey
//
//  Created by yexifeng on 15/12/30.
//  Copyright © 2015年 moregood. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"

#import "Employee.h"

#define TableEmployee   @"employees"

#define log false


@interface DataBaseManager : NSObject{
   BOOL isMonthBirthday;
    int monthOfBirthday;
    int dayOfBirthday;
}

+(instancetype)sharedManager;


@property(nonatomic,strong)FMDatabase* dataBase;
//@property(nonatomic,assign)BOOL isMonthBirthday;
//@property(nonatomic,assign)int monthOfBirthday;
//@property(nonatomic,assign)int dayOfBirthday;

-(Employee*) employee:(NSString*)ID;
@property(nonatomic,strong)NSMutableArray* employees;
@property NSMutableArray<Employee*>* todayBirthdayEmployees;
@property NSArray<NSString*>* deptNames;

-(NSUInteger)insertEmployee:(Employee*)employee;
-(void)updateBirthdayDate:(int)monthOfBirthday dayOfBirthday:(int)dayOfBirthday isMonthBirthday:(BOOL)isMonthBirthday;
-(BOOL)updateEmployee:(Employee*)employee;
-(void)insertEmployees:(NSArray<Employee*>*)employees;
-(BOOL)deleteEmployee:(Employee *)employee;
-(BOOL)deleteEmployeeByIndex:(int)index;
-(void)clearEmployee;
- (BOOL) dropTable:(NSString *)tableName;
- (BOOL) deleteTable:(NSString *)tableName;
-(void)resetAppDataBase;
-(NSArray<Employee*>*)employeeByBirthday;

@end

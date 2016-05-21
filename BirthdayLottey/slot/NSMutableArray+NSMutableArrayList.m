//
//  NSMutableArray+NSMutableArrayList.m
//  Lottey
//
//  Created by yexifeng on 16/1/22.
//  Copyright © 2016年 moregood. All rights reserved.
//

#import "NSMutableArray+NSMutableArrayList.h"

@implementation NSMutableArray (NSMutableArrayList)
-(void)removObject:(Employee *)employee{
    NSMutableArray* willDelete = [NSMutableArray array];
    for(int i=0;i<self.count;i++){
        Employee* e = [self objectAtIndex:i];
        if([e.number isEqualToString:employee.number]){
            [willDelete addObject:e];
        }
    }
    for(int i=0;i<willDelete.count;i++){
        [self removeObject:willDelete[i]];
    }
}
@end

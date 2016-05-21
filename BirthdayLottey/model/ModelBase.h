//
//  ModelBase.h
//  Lottey
//
//  Created by yexifeng on 15/12/31.
//  Copyright © 2015年 moregood. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModelBase : NSObject
@property(nonatomic,assign)NSUInteger ID;
- (NSArray *)filterPropertys;
- (NSDictionary *)toDictionary;
@end

//
//  RandomHelper.m
//  Lottey
//
//  Created by yexifeng on 16/1/21.
//  Copyright © 2016年 moregood. All rights reserved.
//

#import "RandomHelper.h"
#include <random>

@implementation RandomHelper


 std::mt19937 &getEngine() {
    static std::random_device seed_gen;
    static std::mt19937 engine(seed_gen());
    return engine;
}

-(int)random:(NSUInteger)max{
        std::uniform_int_distribution<int> dist(0, max);
//        std::uniform_real_distribution<double> dist(0, 1);
        auto &mt = getEngine();
        int r = dist(mt);
        return r;
}

@end

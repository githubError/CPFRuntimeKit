//
//  CPFWeakSingleton.m
//  CPFRuntimeKit
//
//  Created by 崔鹏飞 on 2017/11/20.
//  Copyright © 2017年 崔鹏飞. All rights reserved.
//

#import "CPFWeakSingleton.h"

@implementation CPFWeakSingleton

+ (instancetype)sharedInstacne {
    return [[self alloc] init];
}


+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static __weak CPFWeakSingleton *weakInstance;
    CPFWeakSingleton *strongInstance = weakInstance;
    @synchronized(self) {
        if (strongInstance == nil) {
            strongInstance = [super allocWithZone:zone];
            weakInstance = strongInstance;
        }
    }
    return strongInstance;
}

@end

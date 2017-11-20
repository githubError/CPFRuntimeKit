//
//  CPFWeakSingleton.h
//  CPFRuntimeKit
//
//  Created by 崔鹏飞 on 2017/11/20.
//  Copyright © 2017年 崔鹏飞. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CPFWeakSingleton : NSObject

@property (nonatomic, copy) NSString *testStr;

+ (instancetype)sharedInstacne;

@end

//
//  CPFRuntimeInvoker.h
//  CPFRuntimeKit
//
//  Created by 崔鹏飞 on 2017/11/17.
//  Copyright © 2017年 崔鹏飞. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CPFRuntimeConst.h"

@interface NSObject (CPFRuntimeInvoker)


/**
 实例方法，runtime 执行方法，以下提供 可变参数 和 参数数组 两种形式

 @param selector 方法签名
 @return return value
 */
- (id)invoke:(NSString *)selector;


- (id)invoke:(NSString *)selector args:(id)arg, ... ;


- (id)invoke:(NSString *)selector arguments:(NSArray *)arguments;



/**
 类方法，runtime 执行方法，以下提供 可变参数 和 参数数组 两种形式

 @param selector 方法签名
 @return return value
 */
+ (id)invoke:(NSString *)selector;


+ (id)invoke:(NSString *)selector args:(id)arg, ... ;


+ (id)invoke:(NSString *)selector arguments:(NSArray *)arguments;

@end



@interface NSString (CPFRuntimeInvoker)


/**
 根据 字符串类名 ，runtime 执行方法，以下提供 可变参数 和 参数数组 两种形式

 @param selector 方法签名
 @return return value
 */
- (id)invokeClassMethod:(NSString *)selector;


- (id)invokeClassMethod:(NSString *)selector args:(id)arg, ... ;


- (id)invokeClassMethod:(NSString *)selector arguments:(NSArray *)arguments;


@end

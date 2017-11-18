//
//  CPFRuntimeHelper.h
//  CPFRuntimeKit
//
//  Created by 崔鹏飞 on 2017/11/17.
//  Copyright © 2017年 崔鹏飞. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CPFRuntimeConst.h"

@interface CPFRuntimeHelper : NSObject


/**
 获取类实例的成员变量列表

 @param class 类实例
 @return return value
 */
+ (NSArray *)fetchIvarList:(Class)class;


/**
 获取类实例的属性列表

 @param class 类实例
 @return return value
 */
+ (NSArray *)fetchPropertyList:(Class)class;


/**
 获取类实例的方法列表

 @param class 类实例
 @return return value
 */
+ (NSArray *)fetchMethodList:(Class)class;


/**
 获取类方法列表

 @param class 类对象
 @return return value
 */
+ (NSArray *)fetchClassMethodList:(Class)class;


/**
 获取类实例遵循的协议列表

 @param class 类实例
 @return return value
 */
+ (NSArray *)fetchProtocolList:(Class)class;


/**
 为类实例动态添加实例方法，或者改变某methodSel的methodSelImpl

 @param class 类实例
 @param methodSel 方法签名
 @param methodSelImpl 方面实现签名
 */
+ (void)addMethod:(Class)class method:(SEL)methodSel method:(SEL)methodSelImpl;


/**
 交换类实例的方法实现

 @param class 类实例
 @param method1 method1 签名
 @param method2 method2 签名
 */
+ (void)methodSwap:(Class)class firstMethod:(SEL)method1 secondMethod:(SEL)method2;

@end

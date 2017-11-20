//
//  AppDelegate.m
//  CPFRuntimeKit
//
//  Created by 崔鹏飞 on 2017/11/17.
//  Copyright © 2017年 崔鹏飞. All rights reserved.
//

#import "AppDelegate.h"
#import "CPFTestClass.h"
#import "CPFRuntimeKit.h"
#import "CPFWeakSingleton.h"

@interface AppDelegate ()

@property (nonatomic, strong) CPFWeakSingleton *strongInstance;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    CPFTestClass *test = CPFTestClass.new;
    test.testPublicProperty = @"测试属性";
    
    // 执行一个并不存在的方法，参见CPFTestClass类中 实现消息的转发
    [test performSelector:NSSelectorFromString(@"noThisMethod:") withObject:@"实例方法参数"];
    
    // runtime 获取属性列表
    NSArray *runtimePropertyArr = [CPFRuntimeHelper fetchPropertyList:[CPFTestClass class]];
    NSLog(@"runtimePropertyArr ---> %@",runtimePropertyArr);
    
    // runtime 获取类方法列表
    NSArray *runtimeClassMethodArr = [CPFRuntimeHelper fetchClassMethodList:[CPFTestClass class]];
    NSLog(@"runtimeMethodArr ---> %@",runtimeClassMethodArr);
    
    // 根据方法名和参数，runtime 执行方法
    [test invoke:@"testInvokSelectorWithArguments:arg2:" args:@"参数1",@"参数2",nil];
    
    // 根据 字符串类名，runtime 执行方法
    [@"CPFTestClass" invokeClassMethod:@"testClassMethod"];
    
    
    // 可自动释放的单例模式
    /**
    
//    [self testWeakInstanceMethod];
    
    _strongInstance = [CPFWeakSingleton sharedInstacne];
    NSLog(@"1---%p",_strongInstance);
    _strongInstance.testStr = @"保留所有权";
    NSLog(@"2---%p",_strongInstance);
    
    _strongInstance = nil;
    
    sleep(5);
    NSLog(@"3---%p",[CPFWeakSingleton sharedInstacne]);
    
     */
    
    return YES;
}

- (void)testWeakInstanceMethod {
    
    CPFWeakSingleton *testInstance = [CPFWeakSingleton sharedInstacne];
    NSLog(@"4---%p",testInstance);
    testInstance.testStr = @"保留所有权";
    NSLog(@"5---%p",testInstance);
    testInstance.testStr = nil;
}

@end

//
//  CPFTestClass.m
//  CPFRuntimeKit
//
//  Created by 崔鹏飞 on 2017/11/17.
//  Copyright © 2017年 崔鹏飞. All rights reserved.
//

#import "CPFTestClass.h"
#import "CPFRuntimeKit.h"
#import "CPFTestTransmitClass.h"

@interface CPFTestClass ()

@property (nonatomic, copy) NSString *testPrivateproperty;

@end

@implementation CPFTestClass

- (instancetype)init {
    if (self = [super init]) {
        _testPrivateproperty = @"测试私有属性";
    }
    return self;
}

- (void)testInvokSelectorWithArguments:(NSString *)arg1 arg2:(NSString *)arg2 {
    NSLog(@"-----> arg1: %@   -----> arg2: %@",arg1, arg2);
}

+ (void)testClassMethod {
    NSLog(@"执行私有类方法");
}



- (void)exceptionHandleMethod:(NSString *) value {
    NSLog(@"没找到方法，执行异常处理：%@", value);
}


#pragma mark - 消息转发相关

+ (BOOL)resolveInstanceMethod:(SEL)sel {
//    return NO;    //当返回NO时，会接着执行forwordingTargetForSelector:方法
    
    // 如果 执行下面方式，会将 sel 方法的实现指针强行更改为本类实例方法exceptionHandleMethod: 达到异常处理的操作
    [CPFRuntimeHelper addMethod:[self class] method:sel method:@selector(exceptionHandleMethod:)];
    return YES;
}


- (id)forwardingTargetForSelector:(SEL)aSelector {
    return self;
    
//    return [CPFTestTransmitClass new];  // 此时如果返回CPFTestTransmitClass实例，则需在CPFTestTransmitClass类中解决转发的异常
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector {
    
    NSMethodSignature *signature = [super methodSignatureForSelector:selector];
    if(signature == nil) {
        signature = [NSMethodSignature signatureWithObjCTypes:"@@:"];
        
    }
    return signature;  // 如果返回 nil 则不会去执行 forwardInvocation:
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    CPFTestTransmitClass * forwardClass = [CPFTestTransmitClass new];
    
    NSString *testTransmitMethodStr = [CPFRuntimeHelper fetchMethodList:[CPFTestTransmitClass class]].firstObject;
    
    [invocation setSelector:NSSelectorFromString(testTransmitMethodStr)];
    
    SEL sel = invocation.selector;
    
    if ([forwardClass respondsToSelector:sel]) {
        [invocation invokeWithTarget:forwardClass];
    } else {
        [self doesNotRecognizeSelector:sel];
    }
}

@end

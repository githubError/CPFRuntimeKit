//
//  CPFCPFRuntimeInvoker.m
//  CPFRuntimeKit
//
//  Created by 崔鹏飞 on 2017/11/17.
//  Copyright © 2017年 崔鹏飞. All rights reserved.
//

#import "CPFRuntimeInvoker.h"
#import <UIKit/UIKit.h>

@implementation NSMethodSignature (CPFRuntimeInvoker)


- (CPFRuntimeArgumentType)returnType {
    return [NSMethodSignature argumentTypeWithEncode:[self methodReturnType]];
}


+ (CPFRuntimeArgumentType)argumentTypeWithEncode:(const char *)encode {
    
    if (strcmp(encode, @encode(char)) == 0) {
        return CPFRuntimeArgumentTypeChar;
    } else if (strcmp(encode, @encode(int)) == 0) {
        return CPFRuntimeArgumentTypeInt;
    } else if (strcmp(encode, @encode(short)) == 0) {
        return CPFRuntimeArgumentTypeShort;
    } else if (strcmp(encode, @encode(long)) == 0) {
        return CPFRuntimeArgumentTypeLong;
    } else if (strcmp(encode, @encode(long long)) == 0) {
        return CPFRuntimeArgumentTypeLongLong;
    } else if (strcmp(encode, @encode(unsigned char)) == 0) {
        return CPFRuntimeArgumentTypeUnsignedChar;
    } else if (strcmp(encode, @encode(unsigned int)) == 0) {
        return CPFRuntimeArgumentTypeUnsignedInt;
    } else if (strcmp(encode, @encode(unsigned short)) == 0) {
        return CPFRuntimeArgumentTypeUnsignedShort;
    } else if (strcmp(encode, @encode(unsigned long)) == 0) {
        return CPFRuntimeArgumentTypeUnsignedLong;
    } else if (strcmp(encode, @encode(unsigned long long)) == 0) {
        return CPFRuntimeArgumentTypeUnsignedLongLong;
    } else if (strcmp(encode, @encode(float)) == 0) {
        return CPFRuntimeArgumentTypeFloat;
    } else if (strcmp(encode, @encode(double)) == 0) {
        return CPFRuntimeArgumentTypeDouble;
    } else if (strcmp(encode, @encode(BOOL)) == 0) {
        return CPFRuntimeArgumentTypeBool;
    } else if (strcmp(encode, @encode(void)) == 0) {
        return CPFRuntimeArgumentTypeVoid;
    } else if (strcmp(encode, @encode(char *)) == 0) {
        return CPFRuntimeArgumentTypeCharacterString;
    } else if (strcmp(encode, @encode(id)) == 0) {
        return CPFRuntimeArgumentTypeObject;
    } else if (strcmp(encode, @encode(Class)) == 0) {
        return CPFRuntimeArgumentTypeClass;
    } else if (strcmp(encode, @encode(CGPoint)) == 0) {
        return CPFRuntimeArgumentTypeCGPoint;
    } else if (strcmp(encode, @encode(CGSize)) == 0) {
        return CPFRuntimeArgumentTypeCGSize;
    } else if (strcmp(encode, @encode(CGRect)) == 0) {
        return CPFRuntimeArgumentTypeCGRect;
    } else if (strcmp(encode, @encode(UIEdgeInsets)) == 0) {
        return CPFRuntimeArgumentTypeUIEdgeInsets;
    } else {
        return CPFRuntimeArgumentTypeUnknown;
    }
}


- (CPFRuntimeArgumentType)argumentTypeAtIndex:(NSInteger)index {
    const char *encode = [self getArgumentTypeAtIndex:index];
    return [NSMethodSignature argumentTypeWithEncode:encode];
}


- (NSInvocation *)invocationWithArguments:(NSArray *)arguments {
    
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:self];
    
    NSAssert(arguments == nil || [arguments isKindOfClass:[NSArray class]], @"# CPFRuntimeInvoker # arguments is not an array");
    
    [arguments enumerateObjectsUsingBlock:^(id  _Nonnull argument, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSInteger index = idx + 2; // 参数从 2 开始
        CPFRuntimeArgumentType type = [self argumentTypeAtIndex:index];
        
        switch (type) {
            case CPFRuntimeArgumentTypeChar: {
                char value = [argument charValue];
                [invocation setArgument:&value atIndex:index];
            } break;
            case CPFRuntimeArgumentTypeInt: {
                int value = [argument intValue];
                [invocation setArgument:&value atIndex:index];
            } break;
            case CPFRuntimeArgumentTypeShort: {
                short value = [argument shortValue];
                [invocation setArgument:&value atIndex:index];
            } break;
            case CPFRuntimeArgumentTypeLong: {
                long value = [argument longValue];
                [invocation setArgument:&value atIndex:index];
            } break;
            case CPFRuntimeArgumentTypeLongLong: {
                long long value = [argument longLongValue];
                [invocation setArgument:&value atIndex:index];
            } break;
            case CPFRuntimeArgumentTypeUnsignedChar: {
                unsigned char value = [argument unsignedCharValue];
                [invocation setArgument:&value atIndex:index];
            } break;
            case CPFRuntimeArgumentTypeUnsignedInt: {
                unsigned int value = [argument unsignedIntValue];
                [invocation setArgument:&value atIndex:index];
            } break;
            case CPFRuntimeArgumentTypeUnsignedShort: {
                unsigned short value = [argument unsignedShortValue];
                [invocation setArgument:&value atIndex:index];
            } break;
            case CPFRuntimeArgumentTypeUnsignedLong: {
                unsigned long value = [argument unsignedLongValue];
                [invocation setArgument:&value atIndex:index];
            } break;
            case CPFRuntimeArgumentTypeUnsignedLongLong: {
                unsigned long long value = [argument unsignedLongLongValue];
                [invocation setArgument:&value atIndex:index];
            } break;
            case CPFRuntimeArgumentTypeFloat: {
                float value = [argument floatValue];
                [invocation setArgument:&value atIndex:index];
            } break;
            case CPFRuntimeArgumentTypeDouble: {
                double value = [argument doubleValue];
                [invocation setArgument:&value atIndex:index];
            } break;
            case CPFRuntimeArgumentTypeBool: {
                BOOL value = [argument boolValue];
                [invocation setArgument:&value atIndex:index];
            } break;
            case CPFRuntimeArgumentTypeVoid: {
                
            } break;
            case CPFRuntimeArgumentTypeCharacterString: {
                const char *value = [argument UTF8String];
                [invocation setArgument:&value atIndex:index];
            } break;
            case CPFRuntimeArgumentTypeObject: {
                [invocation setArgument:&argument atIndex:index];
            } break;
            case CPFRuntimeArgumentTypeClass: {
                Class value = [argument class];
                [invocation setArgument:&value atIndex:index];
            } break;
                
            default: break;
        }
    }];
    
    return invocation;
}

@end

#pragma mark - NSInvocation Category

@implementation NSInvocation (CPFRuntimeInvoker)


- (id)invoke:(id)target selector:(SEL)selector returnType:(CPFRuntimeArgumentType)type {
    self.target = target;
    self.selector = selector;
    [self invoke];
    return [self returnValueForType:type];
}


- (id)returnValueForType:(CPFRuntimeArgumentType)type {
    
    __unsafe_unretained id returnValue;
    
    switch (type) {
        case CPFRuntimeArgumentTypeChar: {
            char value;
            [self getReturnValue:&value];
            returnValue = @(value);
        } break;
        case CPFRuntimeArgumentTypeInt:  {
            int value;
            [self getReturnValue:&value];
            returnValue = @(value);
        } break;
        case CPFRuntimeArgumentTypeShort:  {
            short value;
            [self getReturnValue:&value];
            returnValue = @(value);
        } break;
        case CPFRuntimeArgumentTypeLong:  {
            long value;
            [self getReturnValue:&value];
            returnValue = @(value);
        } break;
        case CPFRuntimeArgumentTypeLongLong:  {
            long long value;
            [self getReturnValue:&value];
            returnValue = @(value);
        } break;
        case CPFRuntimeArgumentTypeUnsignedChar:  {
            unsigned char value;
            [self getReturnValue:&value];
            returnValue = @(value);
        } break;
        case CPFRuntimeArgumentTypeUnsignedInt:  {
            unsigned int value;
            [self getReturnValue:&value];
            returnValue = @(value);
        } break;
        case CPFRuntimeArgumentTypeUnsignedShort:  {
            unsigned short value;
            [self getReturnValue:&value];
            returnValue = @(value);
        } break;
        case CPFRuntimeArgumentTypeUnsignedLong:  {
            unsigned long value;
            [self getReturnValue:&value];
            returnValue = @(value);
        } break;
        case CPFRuntimeArgumentTypeUnsignedLongLong:  {
            unsigned long long value;
            [self getReturnValue:&value];
            returnValue = @(value);
        } break;
        case CPFRuntimeArgumentTypeFloat:  {
            float value;
            [self getReturnValue:&value];
            returnValue = @(value);
        } break;
        case CPFRuntimeArgumentTypeDouble:  {
            double value;
            [self getReturnValue:&value];
            returnValue = @(value);
        } break;
        case CPFRuntimeArgumentTypeBool: {
            BOOL value;
            [self getReturnValue:&value];
            returnValue = @(value);
        } break;
        case CPFRuntimeArgumentTypeCharacterString: {
            const char *value;
            [self getReturnValue:&value];
            returnValue = [NSString stringWithUTF8String:value];
        } break;
        case CPFRuntimeArgumentTypeCGPoint: {
            CGPoint value;
            [self getReturnValue:&value];
            returnValue = [NSValue valueWithCGPoint:value];
        } break;
        case CPFRuntimeArgumentTypeCGSize: {
            CGSize value;
            [self getReturnValue:&value];
            returnValue = [NSValue valueWithCGSize:value];
        } break;
        case CPFRuntimeArgumentTypeCGRect: {
            CGRect value;
            [self getReturnValue:&value];
            returnValue = [NSValue valueWithCGRect:value];
        } break;
        case CPFRuntimeArgumentTypeUIEdgeInsets: {
            UIEdgeInsets value;
            [self getReturnValue:&value];
            returnValue = [NSValue valueWithUIEdgeInsets:value];
        } break;
        case CPFRuntimeArgumentTypeObject:
        case CPFRuntimeArgumentTypeClass:
            [self getReturnValue:&returnValue];
            break;
        default: break;
    }
    return returnValue;
}

@end



#pragma mark - NSObject Category

@implementation NSObject (CPFRuntimeInvoker)

id _invoke(id target, NSString *selector, NSArray *arguments) {
    SEL sel = NSSelectorFromString(selector);
    NSMethodSignature *signature = [target methodSignatureForSelector:sel];
    if (signature) {
        NSInvocation *invocation = [signature invocationWithArguments:arguments];
        id returnValue = [invocation invoke:target selector:sel returnType:signature.returnType];
        return returnValue;
    } else {
        NSLog(@"# CPFRuntimeInvoker # selector: \"%@\" NOT FOUND", selector);
        return nil;
    }
}

- (id)invoke:(NSString *)selector arguments:(NSArray *)arguments {
    return _invoke(self, selector, arguments);
}

- (id)invoke:(NSString *)selector {
    return [self invoke:selector arguments:nil];
}

- (id)invoke:(NSString *)selector args:(id)arg, ... {
    k_COVERT_ARRAY_FROM_args(array,arg);
    return [self invoke:selector arguments:array];
}

+ (id)invoke:(NSString *)selector {
    return [self.class invoke:selector arguments:nil];
}

+ (id)invoke:(NSString *)selector args:(id)arg, ... {
    k_COVERT_ARRAY_FROM_args(array,arg);
    return [self.class invoke:selector arguments:array];
}

+ (id)invoke:(NSString *)selector arguments:(NSArray *)arguments {
    return _invoke(self.class, selector, arguments);
}

@end

@implementation NSString (CPFRuntimeInvoker)

- (id)invokeClassMethod:(NSString *)selector {
    return [self invokeClassMethod:selector arguments:nil];
}

- (id)invokeClassMethod:(NSString *)selector args:(id)arg, ... {
    k_COVERT_ARRAY_FROM_args(array,arg);
    return [self invokeClassMethod:selector arguments:array];
}

- (id)invokeClassMethod:(NSString *)selector arguments:(NSArray *)arguments {
    return [NSClassFromString(self) invoke:selector arguments:arguments];
}

@end

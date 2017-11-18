//
//  CPFRuntimeConst.h
//  CPFRuntimeKit
//
//  Created by 崔鹏飞 on 2017/11/17.
//  Copyright © 2017年 崔鹏飞. All rights reserved.
//

#ifndef CPFRuntimeConst_h
#define CPFRuntimeConst_h


    #import <objc/runtime.h>
    #import <objc/message.h>

    typedef NS_ENUM(NSInteger, CPFRuntimeArgumentType) {
        CPFRuntimeArgumentTypeUnknown             = 0,
        CPFRuntimeArgumentTypeChar,
        CPFRuntimeArgumentTypeInt,
        CPFRuntimeArgumentTypeShort,
        CPFRuntimeArgumentTypeLong,
        CPFRuntimeArgumentTypeLongLong,
        CPFRuntimeArgumentTypeUnsignedChar,
        CPFRuntimeArgumentTypeUnsignedInt,
        CPFRuntimeArgumentTypeUnsignedShort,
        CPFRuntimeArgumentTypeUnsignedLong,
        CPFRuntimeArgumentTypeUnsignedLongLong,
        CPFRuntimeArgumentTypeFloat,
        CPFRuntimeArgumentTypeDouble,
        CPFRuntimeArgumentTypeBool,
        CPFRuntimeArgumentTypeVoid,
        CPFRuntimeArgumentTypeCharacterString,
        CPFRuntimeArgumentTypeCGPoint,
        CPFRuntimeArgumentTypeCGSize,
        CPFRuntimeArgumentTypeCGRect,
        CPFRuntimeArgumentTypeUIEdgeInsets,
        CPFRuntimeArgumentTypeObject,
        CPFRuntimeArgumentTypeClass
    };


    #define k_COVERT_ARRAY_FROM_args(array,arg) \
    NSMutableArray *array = [NSMutableArray arrayWithObject:arg];\
    va_list args;\
    va_start(args, arg);\
    id next = nil;\
    while ((next = va_arg(args,id))) {\
    [array addObject:next];\
    }\
    va_end(args);\

#endif /* CPFRuntimeConst_h */

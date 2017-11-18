//
//  CPFTestClass+category.m
//  CPFRuntimeKit
//
//  Created by 崔鹏飞 on 2017/11/18.
//  Copyright © 2017年 崔鹏飞. All rights reserved.
//

#import "CPFTestClass+category.h"
#import <objc/runtime.h>

@implementation CPFTestClass (category)

static NSString *const kCategoryStringKey = @"kCategoryStringKey";

- (void)setCategoryString:(NSString *)categoryString {
    if (!categoryString) { return; }
    objc_setAssociatedObject(self, &kCategoryStringKey, categoryString, OBJC_ASSOCIATION_COPY);
}

- (NSString *)categoryString {
    return objc_getAssociatedObject(self, &kCategoryStringKey);
}


@end

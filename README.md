# CPFRuntimeKit
一个用来处理 Objective-C Runtime 骚操作的小工具，包含一下几个功能：
* CPFRuntimeHelper  —— 为你指定的Class提供便捷的Hacker方法；
* CPFRuntimeInvoker —— 为你指定的Class提供便捷的响应方法；
* CPFWeakSingleton —— 一种另类的单例模式实现方式，解决单例在生命周期不释放的问题。
* CPFTestClass —— 结合CPFRuntimeHelper，处理Runtime消息转发。


### CPFRuntimeHelper
提供简单易用的API用于快速获取**成员变量列表**、**属性列表**、**类方法列表**、**实例方法列表**、**协议列表**，此外还支持**动态注入实例方法**、**交换实例方法实现**等。

API如下：

1. 获取类实例的成员变量列表
```objc
+ (NSArray *)fetchIvarList:(Class)class;
```

2. 获取类实例的属性列表
```objc
+ (NSArray *)fetchPropertyList:(Class)class;
```

3. 获取类实例的方法列表
```objc
+ (NSArray *)fetchMethodList:(Class)class;
```

4. 为类实例动态添加实例方法，或者改变某methodSel的methodSelImpl
```objc
+ (void)addMethod:(Class)class method:(SEL)methodSel method:(SEL)methodSelImpl;
```

5. 交换类实例的方法实现
```objc
+ (void)methodSwap:(Class)class firstMethod:(SEL)method1 secondMethod:(SEL)method2;
```

以上仅展示一些相关API，具体说明和使用请参考Demo。

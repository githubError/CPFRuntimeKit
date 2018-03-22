# CPFRuntimeKit
一个用来处理 Objective-C Runtime 骚操作的小工具，包含一下几个功能：
* CPFRuntimeHelper  —— 为你指定的Class提供便捷的Hacker方法；
* CPFRuntimeInvoker —— 为你指定的Class提供便捷的响应方法；
* CPFWeakSingleton —— 一种另类的单例模式实现方式，解决单例在生命周期不释放的问题。
* CPFTestClass —— 结合CPFRuntimeHelper，处理Runtime消息转发。



### 一、CPFRuntimeHelper

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

以上仅展示一些相关API，具体说明和使用请参考Demo，内附有完整注释。



### 二、CPFRuntimeInvoker

与CPFRuntimeHelper不同，CPFRuntimeInvoker的实现和调用方式主要有两种，一种是为NSObject类添加Category，这样一来，就能为所有的类，包括自定义的类添加**实例方法**和**类方法**了。
CPFRuntimeInvoker就是利用了Category的特性为NSObject和NSString添加扩展，这样就能通过Object和String，直接执行私有方法，并注入可变参数。

例如：

1. 响应**实例对象**的私有方法，提供可变参数的注入，用于不确定参数个数的私有方法
```objc
CPFTestClass *test = CPFTestClass.new;
[test invoke:@"testInvokSelectorWithArguments:arg2:" args:@"参数1",@"参数2",nil];
```

2. 根据 Class Name 响应私有方法
```objc
// CPFTestClass 是自定义类的类名
[@"CPFTestClass" invokeClassMethod:@"testClassMethod"];
```
以上仅展示一些相关API，具体说明和使用请参考Demo，内附有完整注释。

除此之外，里面一些实现的细节需要简单的说明一下，最主要的是**NSInvocation**相关的理解：

1. NSInvocation对象被用于对象存储以及对象与Application之间的消息转发；
2. 自定义NSInvocation对象，需要提供相应类型的NSMethodSignature对象、arguments、target、返回值类型等，对NSInvocation对象执行 - invoke 方法，来执行响应的signature，并得到Return Type；
3. 在2中提到的响应的arguments需要特别注意参数类型的问题，一旦类型出现错误可能引发意想不到的Crash。但万幸的是NSMethodSignature对象提供 -getArgumentTypeAtIndex: 的实力方法，可以返回当前索引位置的参数类型，不过参数类型是 char * 型的；
4. @encode 关键字，可以将类型转换为 char * 型的字符串，如**@encode(int)** ，结合strcmp这个C标准函数可以判断参数类型是否相同的问题；
5. 执行的返回结果，通过NSInvocation对象的 - getReturnValue: 实力方法得到，其中的参数是一个地址指针，用来指向返回值变量；
6. 除此之外，提供k_COVERT_ARRAY_FROM_args宏定义，用于将OC方法的可变参数转换成NSArray；
7. 需要知道的是，编译器在处理可变参数的时候，是根据第一个可变参数在内存中的地址、参数类型、偏移量等动态的计算出下一个参数的位置，从而取得相应的值，直到读取到nil为止；
8. 在6中的宏定义，就是利用了这个特性将可变参数转换成NSArray的。


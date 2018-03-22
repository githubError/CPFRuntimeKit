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


### 三、CPFWeakSingleton

在开发中，我们通常会使用单例模式，但是单例会有一个不好的问题就是，**在整个程序的运行周期中，单例对象都不会被释放，从而会对内存造成一定的影响**，那么我们可以利用 weak 关键字对单例模式进行改造，达到**如果单例对象被外部持有，则永远不会被释放，一旦不被外部持有，则会在 Runloop 时被回收内存**的目的。

以名为CPFWeakSingleton的类名为例，代码如下：
```objc
@implementation CPFWeakSingleton

+ (instancetype)sharedInstacne {
return [[self alloc] init];
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
static __weak CPFWeakSingleton *weakInstance;
CPFWeakSingleton *strongInstance = weakInstance;
@synchronized(self) {
if (strongInstance == nil) {
strongInstance = [super allocWithZone:zone];
weakInstance = strongInstance;
}
}
return strongInstance;
}
@end
```
下面对其进行验证：
```
_strongInstance = [CPFWeakSingleton sharedInstacne];
NSLog(@"1---%p",_strongInstance);
_strongInstance.testStr = @"保留所有权";
NSLog(@"2---%p",_strongInstance);

sleep(5);
NSLog(@"3---%p",[CPFWeakSingleton sharedInstacne]);
```
运行结果如下：
```
1---0x604000202ea0
2---0x604000202ea0
3---0x604000202ea0
```
可以看出，当我们通过_strongInstance变量持有单例对象时，在经过 Runloop 之后，单例对象也不会被释放（sleep函数是为了验证 Runloop 后对象是否会被回收）。

然而我们对上例稍加改动，使_strongInstance被释放后会发生什么呢？
```
_strongInstance = [CPFWeakSingleton sharedInstacne];
NSLog(@"1---%p",_strongInstance);
_strongInstance.testStr = @"保留所有权";
NSLog(@"2---%p",_strongInstance);

_strongInstance = nil;

sleep(5);
NSLog(@"3---%p",[CPFWeakSingleton sharedInstacne]);
```
此时的运行结果如下：
```
1---0x600000009430
2---0x600000009430
3---0x604000007570
```
可以看出，当外部的_strongInstance对象被释放，不再持有单例对象的时候，或者超出此时单例对象的作用域时（上述代码未演示），该单例对象也会在 Runloop 中被系统回收，当我们再次使用sharedInstacne类方法获取单例对象的时候，则会创建一个新的单例对象。这样，就能即使用单例，又解决了产生的单例对象一直占用内存资源，而且在整个程序的运行周期内都不会被释放的问题。


### 四、CPFTestClass



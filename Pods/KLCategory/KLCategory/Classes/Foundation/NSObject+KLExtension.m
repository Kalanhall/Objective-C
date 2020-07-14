//
//  NSObject+KLExtension.m
//  KLCategory
//
//  Created by Kalan on 2020/7/14.
//

#import "NSObject+KLExtension.h"
#import <objc/runtime.h>

@interface KLObserverHelper : NSObject

@property (unsafe_unretained, nonatomic) id object; // 当对象释放后仍指向该内存空间
@property (strong, nonatomic) NSString *keyPath;
@property (strong, nonatomic) void (^completion)(id value);

@end

@implementation KLObserverHelper

// MARK: - NSCoding
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([object isEqual:self.object] && self.completion) {
        self.completion([change valueForKey:@"new"]);
    }
}

- (void)notificationCenterCallback:(NSNotification *)notification {
    if (self.completion) {
        self.completion(notification);
    }
}

- (void)dealloc {
    // 移除监听属性
    if (self.object && self.keyPath) {
        [self.object removeObserver:self forKeyPath:self.keyPath];
    }
}

@end

@implementation NSObject (KLExtension)

-(void)kl_encode:(NSCoder *)aCoder
{
    // 获取所有的实例变量
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList([self class], &count);
    
    // 遍历
    for (int i = 0; i < count; i ++) {
        Ivar ivar = ivars[i];
        const char *name = ivar_getName(ivar);
        NSString *key = [NSString stringWithUTF8String:name];
        // kvc
        /***
            valueForKey (总体规则 先找相关方法 再找相关变量)
         1. 先找相关方法, 如果相关方法找不到(getName name)
         2. 根据accessInstanceVariablesDirectly类方法来判断
         3. 如果判断是NO,直接执行KVC的valueForUndefineKey(系统跑出一个异常,未定义key)
         4. 如果是YES,继续找相关变量(_name _isName,naame,isName)
         ***/
        id value = [self valueForKey:key];
        // 编码
        if (value != nil) [aCoder encodeObject:value forKey:key];
    }
    
    free(ivars);
    
}

-(void)kl_decode:(NSCoder *)aDecoder
{
    // 获取所有的实例变量
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList([self class], &count);
    
    // 遍历
    for (int i = 0; i < count; i ++) {
        Ivar ivar = ivars[i];
        const char *name = ivar_getName(ivar);
        NSString *key = [NSString stringWithUTF8String:name];
        // kvc
        id value = [aDecoder decodeObjectForKey:key];
        // 解码
        if (value != nil) [self setValue:value forKey:key];
    }
    
    free(ivars);
}

// MARK: - Observer
- (void)kl_observerObject:(id)object forKeyPath:(NSString *)keyPath completion:(void (^)(id value))completion {
    KLObserverHelper *observer = KLObserverHelper.alloc.init;
    observer.object = object;
    observer.keyPath = keyPath;
    observer.completion = completion;
    objc_setAssociatedObject(self, NSSelectorFromString(observer.description), observer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [object addObserver:observer forKeyPath:keyPath options:NSKeyValueObservingOptionNew context:nil];
}

// MARK: - NSNotification
- (void)kl_postNotificationName:(NSNotificationName)name object:(nullable id)object {
    [NSNotificationCenter.defaultCenter postNotificationName:name object:object];
}

- (void)kl_observerNotificationName:(NSNotificationName)name completion:(void (^)(NSNotification *notification))completion {
    KLObserverHelper *observer = KLObserverHelper.alloc.init;
    observer.completion = completion;
    objc_setAssociatedObject(self, NSSelectorFromString(observer.description), observer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [NSNotificationCenter.defaultCenter addObserver:observer selector:@selector(notificationCenterCallback:) name:name object:nil];
}

@end

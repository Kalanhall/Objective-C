//
//  NSObject+KLExtension.h
//  KLCategory
//
//  Created by Kalan on 2020/7/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 直接在 @implementation @end 使用KLImplementationCoding
#define KLImplementationCoding \
-(void)encodeWithCoder:(NSCoder *)aCoder\
{\
    [self kl_encode:aCoder];\
}\
-(instancetype)initWithCoder:(NSCoder *)aDecoder\
{\
    if (self = [super init]) {\
        [self kl_decode:aDecoder];\
    }\
    return self; \
}

#define KeyPath(objc, keyPath) @(((void)objc.keyPath, #keyPath))

@interface NSObject (KLExtension)

// MARK: - NSCoding
/// 归档
-(void)kl_encode:(NSCoder *)aCoder;
/// 解档
-(void)kl_decode:(NSCoder *)aDecoder;

// MARK: - Observer

/// 自动移除KVO的监听扩展方法
///
/// 使用示例：
///  [self kl_observerObject:self.tableView forKeyPath:@"contentOffset" completion:^(id value) {
///     NSLog(@"%f", [value CGSizeValue].height);
///  }];
/// @param object    监听对象
/// @param keyPath  监听属性
/// @param completion  属性改变回调
- (void)kl_observerObject:(id)object forKeyPath:(NSString *)keyPath completion:(nullable void (^)(id value))completion;

// MARK: - NSNotification

/// 便捷通知发送方法
/// @param name 通知标识符
- (void)kl_postNotificationName:(NSNotificationName)name object:(nullable id)object;

/// 便捷通知接收方法
///
/// 使用示例：
///
///  [self kl_observerNotificationName:@"name" completion:^(NSNotification *notification) {
///     NSLog(@"%@", notification);
///  }];
///
/// @param name  通知标识符
/// @param completion  属性改变回调
- (void)kl_observerNotificationName:(NSNotificationName)name completion:(nullable void (^)(NSNotification *notification))completion;

@end

NS_ASSUME_NONNULL_END

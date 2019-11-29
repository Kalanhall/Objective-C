//
//  KLUserInfoManager.m
//  KLUserInfoManager
//
//  Created by Logic on 2019/11/29.
//

#import "KLUserInfoManager.h"
@import KLCache;

NSString *const com_userinfomanager_key = @"com.userinfomanager.key";
NSString *const com_userinfomanager_value = @"com.userinfomanager.value";

@interface KLUserInfoManager ()

@property (strong, nonatomic) KLCache *cache;

@end

@implementation KLUserInfoManager

+ (instancetype)shareManager
{
    static KLUserInfoManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
        
        KLCache *cache = [KLCache cacheWithName:com_userinfomanager_key];
        [cache.memoryCache setCountLimit:50];       // 内存最大缓存数据个数
        [cache.memoryCache setCostLimit:1*1024];    // 内存最大缓存开销 目前这个毫无用处
        [cache.diskCache setCostLimit:10*1024];     // 磁盘最大缓存开销
        [cache.diskCache setCountLimit:50];         // 磁盘最大缓存数据个数
        [cache.diskCache setAutoTrimInterval:60];   // 设置磁盘lru动态清理频率 默认 60秒
        instance.cache = cache;
    });
    return instance;
}

- (void)updateObject:(id<NSCoding>)object
{
    [self.cache setObject:object forKey:com_userinfomanager_value];
}

- (void)removeObject
{
    [self.cache removeObjectForKey:com_userinfomanager_value];
}

- (id<NSCoding>)object
{
    return [self.cache objectForKey:com_userinfomanager_value];
}

- (BOOL)isExist {
    return [self.cache containsObjectForKey:com_userinfomanager_value];
}

@end

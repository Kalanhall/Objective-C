//
//  KLUserInfoManager.h
//  KLUserInfoManager
//
//  Created by Logic on 2019/11/29.
//

#import <Foundation/Foundation.h>
#import "KLUserInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface KLUserInfoManager : NSObject

+ (instancetype)shareManager;

// 增、改
- (void)updateObject:(id<NSCoding>)object;

// 删
- (void)removeObject;

// 查
- (id<NSCoding>)object;

// 状态
- (BOOL)isExist;

@end

NS_ASSUME_NONNULL_END

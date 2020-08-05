//
//  NSTimer+KLExtenstion.h
//  KLCategory
//
//  Created by Kalan on 2020/8/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSTimer (KLExtentsion)

/// 效果等同于iOS10的api
+ (NSTimer *)kl_scheduledTimerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats block:(void (^)(NSTimer *timer))block;

@end

NS_ASSUME_NONNULL_END

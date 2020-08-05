//
//  NSTimer+KLExtenstion.m
//  KLCategory
//
//  Created by Kalan on 2020/8/5.
//

#import "NSTimer+KLExtentsion.h"

@implementation NSTimer (KLExtentsion)

+ (NSTimer *)kl_scheduledTimerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats block:(void (^)(NSTimer *timer))block {
    NSTimer *temp = [self scheduledTimerWithTimeInterval:interval target:self selector:@selector(kl_blockCallBlock:) userInfo:[block copy] repeats:repeats];
    [NSRunLoop.mainRunLoop addTimer:temp forMode:NSRunLoopCommonModes];
    return temp;
}
 
+ (void)kl_blockCallBlock:(NSTimer *)timer {
    void (^block)(NSTimer *timer) = timer.userInfo;
    if (block) block(timer);
}

@end

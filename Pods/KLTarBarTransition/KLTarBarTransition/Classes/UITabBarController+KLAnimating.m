//
//  UITabBarController+KLAnimating.m
//  KLTarBarTransition
//
//  Created by Kalan on 2019/8/28.
//

#import "UITabBarController+KLAnimating.h"
#import <objc/runtime.h>

static const NSString *key = @"KLAnimating";

@implementation UITabBarController (KLAnimating)

- (void)setIsAnimating:(BOOL)isAnimating {
    objc_setAssociatedObject(self, &key, @(isAnimating), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isAnimating {
    return [objc_getAssociatedObject(self, &key) boolValue];
}

@end

#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "KLTabBarTransitionAnimator.h"
#import "KLTabBarTransitionDelegate.h"
#import "KLTabBarTransitionInteractionController.h"
#import "UITabBarController+KLAnimating.h"

FOUNDATION_EXPORT double KLTarBarTransitionVersionNumber;
FOUNDATION_EXPORT const unsigned char KLTarBarTransitionVersionString[];


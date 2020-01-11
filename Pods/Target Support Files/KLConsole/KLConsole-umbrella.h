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

#import "KLConsole.h"
#import "KLConsoleCell.h"
#import "KLConsoleConfig.h"
#import "KLConsoleController.h"
#import "KLConsoleInfoController.h"
#import "NSObject+KLConsole.h"
#import "UIDevice+KLConsole.h"

FOUNDATION_EXPORT double KLConsoleVersionNumber;
FOUNDATION_EXPORT const unsigned char KLConsoleVersionString[];


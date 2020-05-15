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

#import "KLImageCache.h"
#import "KLWebImage.h"
#import "KLWebImageManager.h"
#import "KLWebImageOperation.h"
#import "CALayer+KLWebImage.h"
#import "MKAnnotationView+KLWebImage.h"
#import "UIButton+KLWebImage.h"
#import "UIImage+KLWebImage.h"
#import "UIImageView+KLWebImage.h"
#import "KLFrameImage.h"
#import "KLImage.h"
#import "KLImageCoder.h"
#import "KLImageView.h"
#import "KLSpriteSheetImage.h"

FOUNDATION_EXPORT double KLImageViewVersionNumber;
FOUNDATION_EXPORT const unsigned char KLImageViewVersionString[];


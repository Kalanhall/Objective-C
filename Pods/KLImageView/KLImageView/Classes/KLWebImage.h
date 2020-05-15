//
//  KLWebImage.h
//  KLWebImage <https://github.com/kalanhall/KLWebImage>
//
//  Created by kalan on 19/2/23.
//  Copyright (c) 2019 kalan.


#import <UIKit/UIKit.h>

#if __has_include(<KLWebImage/KLWebImage.h>)
FOUNDATION_EXPORT double KLWebImageVersionNumber;
FOUNDATION_EXPORT const unsigned char KLWebImageVersionString[];
#import <KLWebImage/KLImageCache.h>
#import <KLWebImage/KLWebImageOperation.h>
#import <KLWebImage/KLWebImageManager.h>
#import <KLWebImage/UIImage+KLWebImage.h>
#import <KLWebImage/UIImageView+KLWebImage.h>
#import <KLWebImage/UIButton+KLWebImage.h>
#import <KLWebImage/CALayer+KLWebImage.h>
#import <KLWebImage/MKAnnotationView+KLWebImage.h>
#else
#import "KLImageCache.h"
#import "KLWebImageOperation.h"
#import "KLWebImageManager.h"
#import "UIImage+KLWebImage.h"
#import "UIImageView+KLWebImage.h"
#import "UIButton+KLWebImage.h"
#import "CALayer+KLWebImage.h"
#import "MKAnnotationView+KLWebImage.h"
#endif

#if __has_include(<KLImage/KLImage.h>)
#import <KLImage/KLImage.h>
#elif __has_include(<KLWebImage/KLImage.h>)
#import <KLWebImage/KLImage.h>
#import <KLWebImage/KLFrameImage.h>
#import <KLWebImage/KLSpriteSheetImage.h>
#import <KLWebImage/KLImageCoder.h>
#import <KLWebImage/KLImageView.h>
#else
#import "KLImage.h"
#import "KLFrameImage.h"
#import "KLSpriteSheetImage.h"
#import "KLImageCoder.h"
#import "KLImageView.h"
#endif

#if __has_include(<KLCache/KLCache.h>)
#import <KLCache/KLCache.h>
#elif __has_include(<KLWebImage/KLCache.h>)
#import <KLWebImage/KLCache.h>
#import <KLWebImage/KLMemoryCache.h>
#import <KLWebImage/KLDiskCache.h>
#import <KLWebImage/KLKVStorage.h>
#else
#import "KLCache.h"
#import "KLMemoryCache.h"
#import "KLDiskCache.h"
#import "KLKVStorage.h"
#endif


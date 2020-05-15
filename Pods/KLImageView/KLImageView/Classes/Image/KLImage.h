//
//  KLImage.h
//  KLImage <https://github.com/kalan/KLImage>
//
//  Created by kalan on 14/10/20.
//  Copyright (c) 2019 kalan.


#import <UIKit/UIKit.h>

#if __has_include(<KLImage/KLImage.h>)
FOUNDATION_EXPORT double KLImageVersionNumber;
FOUNDATION_EXPORT const unsigned char KLImageVersionString[];
#import <KLImage/KLFrameImage.h>
#import <KLImage/KLSpriteSheetImage.h>
#import <KLImage/KLImageCoder.h>
#import <KLImage/KLImageView.h>
#elif __has_include(<KLWebImage/KLImage.h>)
#import <KLWebImage/KLFrameImage.h>
#import <KLWebImage/KLSpriteSheetImage.h>
#import <KLWebImage/KLImageCoder.h>
#import <KLWebImage/KLImageView.h>
#else
#import "KLFrameImage.h"
#import "KLSpriteSheetImage.h"
#import "KLImageCoder.h"
#import "KLImageView.h"
#endif

NS_ASSUME_NONNULL_BEGIN


/**
 A KLImage object is a high-level way to display animated image data.
 
 @discussion It is a fully compatible `UIImage` subclass. It extends the UIImage
 to support animated WebP, APNG and GIF format image data decoding. It also 
 support NSCoding protocol to archive and unarchive multi-frame image data.
 
 If the image is created from multi-frame image data, and you want to play the 
 animation, try replace UIImageView with `KLImageView`.
 
 Sample Code:
 
     // animation@3x.webp
     KLImage *image = [KLImage imageNamed:@"animation.webp"];
     KLImageView *imageView = [KLImageView alloc] initWithImage:image];
     [view addSubView:imageView];
    
 */
@interface KLImage : UIImage <KLAnimatedImage>

+ (nullable KLImage *)imageNamed:(NSString *)name; // no cache!
+ (nullable KLImage *)imageWithContentsOfFile:(NSString *)path;
+ (nullable KLImage *)imageWithData:(NSData *)data;
+ (nullable KLImage *)imageWithData:(NSData *)data scale:(CGFloat)scale;

/**
 If the image is created from data or file, then the value indicates the data type.
 */
@property (nonatomic, readonly) KLImageType animatedImageType;

/**
 If the image is created from animated image data (multi-frame GIF/APNG/WebP),
 this property stores the original image data.
 */
@property (nullable, nonatomic, readonly) NSData *animatedImageData;

/**
 The total memory usage (in bytes) if all frame images was loaded into memory.
 The value is 0 if the image is not created from a multi-frame image data.
 */
@property (nonatomic, readonly) NSUInteger animatedImageMemorySize;

/**
 Preload all frame image to memory.
 
 @discussion Set this property to `YES` will block the calling thread to decode 
 all animation frame image to memory, set to `NO` will release the preloaded frames.
 If the image is shared by lots of image views (such as emoticon), preload all
 frames will reduce the CPU cost.
 
 See `animatedImageMemorySize` for memory cost.
 */
@property (nonatomic) BOOL preloadAllAnimatedImageFrames;

@end

NS_ASSUME_NONNULL_END

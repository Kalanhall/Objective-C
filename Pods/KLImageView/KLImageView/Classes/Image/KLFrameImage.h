//
//  KLFrameImage.h
//  KLImage <https://github.com/kalan/KLImage>
//
//  Created by kalan on 14/12/9.
//  Copyright (c) 2019 kalan.


#import <UIKit/UIKit.h>

#if __has_include(<KLImage/KLImage.h>)
#import <KLImage/KLImageView.h>
#elif __has_include(<KLWebImage/KLImage.h>)
#import <KLWebImage/KLImageView.h>
#else
#import "KLImageView.h"
#endif

NS_ASSUME_NONNULL_BEGIN

/**
 An image to display frame-based animation.
 
 @discussion It is a fully compatible `UIImage` subclass.
 It only support system image format such as png and jpeg.
 The animation can be played by KLImageView.
 
 Sample Code:
     
     NSArray *paths = @[@"/ani/frame1.png", @"/ani/frame2.png", @"/ani/frame3.png"];
     NSArray *times = @[@0.1, @0.2, @0.1];
     KLFrameImage *image = [KLFrameImage alloc] initWithImagePaths:paths frameDurations:times repeats:YES];
     KLImageView *imageView = [KLImageView alloc] initWithImage:image];
     [view addSubView:imageView];
 */
@interface KLFrameImage : UIImage <KLAnimatedImage>

/**
 Create a frame animated image from files.
 
 @param paths            An array of NSString objects, contains the full or 
                         partial path to each image file.
                         e.g. @[@"/ani/1.png",@"/ani/2.png",@"/ani/3.png"]
 
 @param oneFrameDuration The duration (in seconds) per frame.
 
 @param loopCount        The animation loop count, 0 means infinite.
 
 @return An initialized KLFrameImage object, or nil when an error occurs.
 */
- (nullable instancetype)initWithImagePaths:(NSArray<NSString *> *)paths
                           oneFrameDuration:(NSTimeInterval)oneFrameDuration
                                  loopCount:(NSUInteger)loopCount;

/**
 Create a frame animated image from files.
 
 @param paths          An array of NSString objects, contains the full or
                       partial path to each image file.
                       e.g. @[@"/ani/frame1.png",@"/ani/frame2.png",@"/ani/frame3.png"]
 
 @param frameDurations An array of NSNumber objects, contains the duration (in seconds) per frame.
                       e.g. @[@0.1, @0.2, @0.3];
 
 @param loopCount      The animation loop count, 0 means infinite.
 
 @return An initialized KLFrameImage object, or nil when an error occurs.
 */
- (nullable instancetype)initWithImagePaths:(NSArray<NSString *> *)paths
                             frameDurations:(NSArray<NSNumber *> *)frameDurations
                                  loopCount:(NSUInteger)loopCount;

/**
 Create a frame animated image from an array of data.
 
 @param dataArray        An array of NSData objects.
 
 @param oneFrameDuration The duration (in seconds) per frame.
 
 @param loopCount        The animation loop count, 0 means infinite.
 
 @return An initialized KLFrameImage object, or nil when an error occurs.
 */
- (nullable instancetype)initWithImageDataArray:(NSArray<NSData *> *)dataArray
                               oneFrameDuration:(NSTimeInterval)oneFrameDuration
                                      loopCount:(NSUInteger)loopCount;

/**
 Create a frame animated image from an array of data.
 
 @param dataArray      An array of NSData objects.
 
 @param frameDurations An array of NSNumber objects, contains the duration (in seconds) per frame.
                       e.g. @[@0.1, @0.2, @0.3];
 
 @param loopCount      The animation loop count, 0 means infinite.
 
 @return An initialized KLFrameImage object, or nil when an error occurs.
 */
- (nullable instancetype)initWithImageDataArray:(NSArray<NSData *> *)dataArray
                                 frameDurations:(NSArray *)frameDurations
                                      loopCount:(NSUInteger)loopCount;

@end

NS_ASSUME_NONNULL_END

//
//  CALayer+KLWebImage.h
//  KLWebImage <https://github.com/kalanhall/KLWebImage>
//
//  Created by kalan on 19/2/23.
//  Copyright (c) 2019 kalan.


#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#if __has_include(<KLWebImage/KLWebImage.h>)
#import <KLWebImage/KLWebImageManager.h>
#else
#import "KLWebImageManager.h"
#endif

NS_ASSUME_NONNULL_BEGIN

/**
 Web image methods for CALayer.
 It will set image to layer.contents.
 */
@interface CALayer (KLWebImage)

#pragma mark - image

/**
 Current image URL.
 
 @discussion Set a new value to this property will cancel the previous request
 operation and create a new request operation to fetch image. Set nil to clear
 the image and image URL.
 */
@property (nullable, nonatomic, strong) NSURL *kl_imageURL;

/**
 Set the view's `image` with a specified URL.
 
 @param imageURL    The image url (remote or local file path).
 @param placeholder The image to be set initially, until the image request finishes.
 */
- (void)kl_setImageWithURL:(nullable NSURL *)imageURL placeholder:(nullable UIImage *)placeholder;

/**
 Set the view's `image` with a specified URL.
 
 @param imageURL The image url (remote or local file path).
 @param options  The options to use when request the image.
 */
- (void)kl_setImageWithURL:(nullable NSURL *)imageURL options:(KLWebImageOptions)options;

/**
 Set the view's `image` with a specified URL.
 
 @param imageURL    The image url (remote or local file path).
 @param placeholder The image to be set initially, until the image request finishes.
 @param options     The options to use when request the image.
 @param completion  The block invoked (on main thread) when image request completed.
 */
- (void)kl_setImageWithURL:(nullable NSURL *)imageURL
               placeholder:(nullable UIImage *)placeholder
                   options:(KLWebImageOptions)options
                completion:(nullable KLWebImageCompletionBlock)completion;

/**
 Set the view's `image` with a specified URL.
 
 @param imageURL    The image url (remote or local file path).
 @param placeholder The image to be set initially, until the image request finishes.
 @param options     The options to use when request the image.
 @param progress    The block invoked (on main thread) during image request.
 @param transform   The block invoked (on background thread) to do additional image process.
 @param completion  The block invoked (on main thread) when image request completed.
 */
- (void)kl_setImageWithURL:(nullable NSURL *)imageURL
               placeholder:(nullable UIImage *)placeholder
                   options:(KLWebImageOptions)options
                  progress:(nullable KLWebImageProgressBlock)progress
                 transform:(nullable KLWebImageTransformBlock)transform
                completion:(nullable KLWebImageCompletionBlock)completion;

/**
 Set the view's `image` with a specified URL.
 
 @param imageURL    The image url (remote or local file path).
 @param placeholder he image to be set initially, until the image request finishes.
 @param options     The options to use when request the image.
 @param manager     The manager to create image request operation.
 @param progress    The block invoked (on main thread) during image request.
 @param transform   The block invoked (on background thread) to do additional image process.
 @param completion  The block invoked (on main thread) when image request completed.
 */
- (void)kl_setImageWithURL:(nullable NSURL *)imageURL
               placeholder:(nullable UIImage *)placeholder
                   options:(KLWebImageOptions)options
                   manager:(nullable KLWebImageManager *)manager
                  progress:(nullable KLWebImageProgressBlock)progress
                 transform:(nullable KLWebImageTransformBlock)transform
                completion:(nullable KLWebImageCompletionBlock)completion;

/**
 Cancel the current image request.
 */
- (void)kl_cancelCurrentImageRequest;

@end

NS_ASSUME_NONNULL_END

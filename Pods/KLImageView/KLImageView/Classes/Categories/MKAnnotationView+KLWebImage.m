//
//  MKAnnotationView+KLWebImage.m
//  KLWebImage <https://github.com/kalanhall/KLWebImage>
//
//  Created by kalan on 19/2/23.
//  Copyright (c) 2019 kalan.


#import "MKAnnotationView+KLWebImage.h"
#import "KLWebImageOperation.h"
#import "_KLWebImageSetter.h"
#import <objc/runtime.h>

// Dummy class for category
@interface MKAnnotationView_KLWebImage : NSObject @end
@implementation MKAnnotationView_KLWebImage @end


static int _KLWebImageSetterKey;

@implementation MKAnnotationView (KLWebImage)

- (NSURL *)kl_imageURL {
    _KLWebImageSetter *setter = objc_getAssociatedObject(self, &_KLWebImageSetterKey);
    return setter.imageURL;
}

- (void)setKl_imageURL:(NSURL *)imageURL {
    [self kl_setImageWithURL:imageURL
              placeholder:nil
                  options:kNilOptions
                  manager:nil
                 progress:nil
                transform:nil
               completion:nil];
}

- (void)kl_setImageWithURL:(NSURL *)imageURL placeholder:(UIImage *)placeholder {
    [self kl_setImageWithURL:imageURL
                 placeholder:placeholder
                     options:kNilOptions
                     manager:nil
                    progress:nil
                   transform:nil
                  completion:nil];
}

- (void)kl_setImageWithURL:(NSURL *)imageURL options:(KLWebImageOptions)options {
    [self kl_setImageWithURL:imageURL
                 placeholder:nil
                     options:options
                     manager:nil
                    progress:nil
                   transform:nil
                  completion:nil];
}

- (void)kl_setImageWithURL:(NSURL *)imageURL
               placeholder:(UIImage *)placeholder
                   options:(KLWebImageOptions)options
                completion:(KLWebImageCompletionBlock)completion {
    [self kl_setImageWithURL:imageURL
                 placeholder:placeholder
                     options:options
                     manager:nil
                    progress:nil
                   transform:nil
                  completion:completion];
}

- (void)kl_setImageWithURL:(NSURL *)imageURL
               placeholder:(UIImage *)placeholder
                   options:(KLWebImageOptions)options
                  progress:(KLWebImageProgressBlock)progress
                 transform:(KLWebImageTransformBlock)transform
                completion:(KLWebImageCompletionBlock)completion {
    [self kl_setImageWithURL:imageURL
                 placeholder:placeholder
                     options:options
                     manager:nil
                    progress:progress
                   transform:transform
                  completion:completion];
}

- (void)kl_setImageWithURL:(NSURL *)imageURL
               placeholder:(UIImage *)placeholder
                   options:(KLWebImageOptions)options
                   manager:(KLWebImageManager *)manager
                  progress:(KLWebImageProgressBlock)progress
                 transform:(KLWebImageTransformBlock)transform
                completion:(KLWebImageCompletionBlock)completion {
    if ([imageURL isKindOfClass:[NSString class]]) imageURL = [NSURL URLWithString:(id)imageURL];
    manager = manager ? manager : [KLWebImageManager sharedManager];
    
    _KLWebImageSetter *setter = objc_getAssociatedObject(self, &_KLWebImageSetterKey);
    if (!setter) {
        setter = [_KLWebImageSetter new];
        objc_setAssociatedObject(self, &_KLWebImageSetterKey, setter, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    int32_t sentinel = [setter cancelWithNewURL:imageURL];
    
    _kl_dispatch_sync_on_main_queue(^{
        if ((options & KLWebImageOptionSetImageWithFadeAnimation) &&
            !(options & KLWebImageOptionAvoidSetImage)) {
            if (!self.highlighted) {
                [self.layer removeAnimationForKey:_KLWebImageFadeAnimationKey];
            }
        }
        if (!imageURL) {
            if (!(options & KLWebImageOptionIgnorePlaceHolder)) {
                self.image = placeholder;
            }
            return;
        }
        
        // get the image from memory as quickly as possible
        UIImage *imageFromMemory = nil;
        if (manager.cache &&
            !(options & KLWebImageOptionUseNSURLCache) &&
            !(options & KLWebImageOptionRefreshImageCache)) {
            imageFromMemory = [manager.cache getImageForKey:[manager cacheKeyForURL:imageURL] withType:KLImageCacheTypeMemory];
        }
        if (imageFromMemory) {
            if (!(options & KLWebImageOptionAvoidSetImage)) {
                self.image = imageFromMemory;
            }
            if(completion) completion(imageFromMemory, imageURL, KLWebImageFromMemoryCacheFast, KLWebImageStageFinished, nil);
            return;
        }
        
        if (!(options & KLWebImageOptionIgnorePlaceHolder)) {
            self.image = placeholder;
        }
        
        __weak typeof(self) _self = self;
        dispatch_async([_KLWebImageSetter setterQueue], ^{
            KLWebImageProgressBlock _progress = nil;
            if (progress) _progress = ^(NSInteger receivedSize, NSInteger expectedSize) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    progress(receivedSize, expectedSize);
                });
            };
            
            __block int32_t newSentinel = 0;
            __block __weak typeof(setter) weakSetter = nil;
            KLWebImageCompletionBlock _completion = ^(UIImage *image, NSURL *url, KLWebImageFromType from, KLWebImageStage stage, NSError *error) {
                __strong typeof(_self) self = _self;
                BOOL setImage = (stage == KLWebImageStageFinished || stage == KLWebImageStageProgress) && image && !(options & KLWebImageOptionAvoidSetImage);
                BOOL showFade = ((options & KLWebImageOptionSetImageWithFadeAnimation) && !self.highlighted);
                dispatch_async(dispatch_get_main_queue(), ^{
                    BOOL sentinelChanged = weakSetter && weakSetter.sentinel != newSentinel;
                    if (setImage && self && !sentinelChanged) {
                        if (showFade) {
                            CATransition *transition = [CATransition animation];
                            transition.duration = stage == KLWebImageStageFinished ? _KLWebImageFadeTime : _KLWebImageProgressiveFadeTime;
                            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                            transition.type = kCATransitionFade;
                            [self.layer addAnimation:transition forKey:_KLWebImageFadeAnimationKey];
                        }
                        self.image = image;
                    }
                    if (completion) {
                        if (sentinelChanged) {
                            completion(nil, url, KLWebImageFromNone, KLWebImageStageCancelled, nil);
                        } else {
                            completion(image, url, from, stage, error);
                        }
                    }
                });
            };
            
            newSentinel = [setter setOperationWithSentinel:sentinel url:imageURL options:options manager:manager progress:_progress transform:transform completion:_completion];
            weakSetter = setter;
        });
    });
}

- (void)kl_cancelCurrentImageRequest {
    _KLWebImageSetter *setter = objc_getAssociatedObject(self, &_KLWebImageSetterKey);
    if (setter) [setter cancel];
}

@end

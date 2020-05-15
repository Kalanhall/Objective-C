//
//  UIButton+KLWebImage.m
//  KLWebImage <https://github.com/kalanhall/KLWebImage>
//
//  Created by kalan on 19/2/23.
//  Copyright (c) 2019 kalan.


#import "UIButton+KLWebImage.h"
#import "KLWebImageOperation.h"
#import "_KLWebImageSetter.h"
#import <objc/runtime.h>

// Dummy class for category
@interface UIButton_KLWebImage : NSObject @end
@implementation UIButton_KLWebImage @end

static inline NSNumber *UIControlStateSingle(UIControlState state) {
    if (state & UIControlStateHighlighted) return @(UIControlStateHighlighted);
    if (state & UIControlStateDisabled) return @(UIControlStateDisabled);
    if (state & UIControlStateSelected) return @(UIControlStateSelected);
    return @(UIControlStateNormal);
}

static inline NSArray *UIControlStateMulti(UIControlState state) {
    NSMutableArray *array = [NSMutableArray new];
    if (state & UIControlStateHighlighted) [array addObject:@(UIControlStateHighlighted)];
    if (state & UIControlStateDisabled) [array addObject:@(UIControlStateDisabled)];
    if (state & UIControlStateSelected) [array addObject:@(UIControlStateSelected)];
    if ((state & 0xFF) == 0) [array addObject:@(UIControlStateNormal)];
    return array;
}

static int _KLWebImageSetterKey;
static int _KLWebImageBackgroundSetterKey;


@interface _KLWebImageSetterDicForButton : NSObject
- (_KLWebImageSetter *)setterForState:(NSNumber *)state;
- (_KLWebImageSetter *)lazySetterForState:(NSNumber *)state;
@end

@implementation _KLWebImageSetterDicForButton {
    NSMutableDictionary *_dic;
    dispatch_semaphore_t _lock;
}
- (instancetype)init {
    self = [super init];
    _lock = dispatch_semaphore_create(1);
    _dic = [NSMutableDictionary new];
    return self;
}
- (_KLWebImageSetter *)setterForState:(NSNumber *)state {
    dispatch_semaphore_wait(_lock, DISPATCH_TIME_FOREVER);
    _KLWebImageSetter *setter = _dic[state];
    dispatch_semaphore_signal(_lock);
    return setter;
    
}
- (_KLWebImageSetter *)lazySetterForState:(NSNumber *)state {
    dispatch_semaphore_wait(_lock, DISPATCH_TIME_FOREVER);
    _KLWebImageSetter *setter = _dic[state];
    if (!setter) {
        setter = [_KLWebImageSetter new];
        _dic[state] = setter;
    }
    dispatch_semaphore_signal(_lock);
    return setter;
}
@end


@implementation UIButton (KLWebImage)

#pragma mark - image

- (void)_kl_setImageWithURL:(NSURL *)imageURL
             forSingleState:(NSNumber *)state
                placeholder:(UIImage *)placeholder
                    options:(KLWebImageOptions)options
                    manager:(KLWebImageManager *)manager
                   progress:(KLWebImageProgressBlock)progress
                  transform:(KLWebImageTransformBlock)transform
                 completion:(KLWebImageCompletionBlock)completion {
    if ([imageURL isKindOfClass:[NSString class]]) imageURL = [NSURL URLWithString:(id)imageURL];
    manager = manager ? manager : [KLWebImageManager sharedManager];
    
    _KLWebImageSetterDicForButton *dic = objc_getAssociatedObject(self, &_KLWebImageSetterKey);
    if (!dic) {
        dic = [_KLWebImageSetterDicForButton new];
        objc_setAssociatedObject(self, &_KLWebImageSetterKey, dic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    _KLWebImageSetter *setter = [dic lazySetterForState:state];
    int32_t sentinel = [setter cancelWithNewURL:imageURL];
    
    _kl_dispatch_sync_on_main_queue(^{
        if (!imageURL) {
            if (!(options & KLWebImageOptionIgnorePlaceHolder)) {
                [self setImage:placeholder forState:state.integerValue];
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
                [self setImage:imageFromMemory forState:state.integerValue];
            }
            if(completion) completion(imageFromMemory, imageURL, KLWebImageFromMemoryCacheFast, KLWebImageStageFinished, nil);
            return;
        }
        
        
        if (!(options & KLWebImageOptionIgnorePlaceHolder)) {
            [self setImage:placeholder forState:state.integerValue];
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
                dispatch_async(dispatch_get_main_queue(), ^{
                    BOOL sentinelChanged = weakSetter && weakSetter.sentinel != newSentinel;
                    if (setImage && self && !sentinelChanged) {
                        [self setImage:image forState:state.integerValue];
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

- (void)_kl_cancelImageRequestForSingleState:(NSNumber *)state {
    _KLWebImageSetterDicForButton *dic = objc_getAssociatedObject(self, &_KLWebImageSetterKey);
    _KLWebImageSetter *setter = [dic setterForState:state];
    if (setter) [setter cancel];
}

- (NSURL *)kl_imageURLForState:(UIControlState)state {
    _KLWebImageSetterDicForButton *dic = objc_getAssociatedObject(self, &_KLWebImageSetterKey);
    _KLWebImageSetter *setter = [dic setterForState:UIControlStateSingle(state)];
    return setter.imageURL;
}

- (void)kl_setImageWithURL:(NSURL *)imageURL
                  forState:(UIControlState)state
               placeholder:(UIImage *)placeholder {
    [self kl_setImageWithURL:imageURL
                 forState:state
              placeholder:placeholder
                  options:kNilOptions
                  manager:nil
                 progress:nil
                transform:nil
               completion:nil];
}

- (void)kl_setImageWithURL:(NSURL *)imageURL
                  forState:(UIControlState)state
                   options:(KLWebImageOptions)options {
    [self kl_setImageWithURL:imageURL
                    forState:state
                 placeholder:nil
                     options:options
                     manager:nil
                    progress:nil
                   transform:nil
                  completion:nil];
}

- (void)kl_setImageWithURL:(NSURL *)imageURL
                  forState:(UIControlState)state
               placeholder:(UIImage *)placeholder
                   options:(KLWebImageOptions)options
                completion:(KLWebImageCompletionBlock)completion {
    [self kl_setImageWithURL:imageURL
                    forState:state
                 placeholder:placeholder
                     options:options
                     manager:nil
                    progress:nil
                   transform:nil
                  completion:completion];
}

- (void)kl_setImageWithURL:(NSURL *)imageURL
                  forState:(UIControlState)state
               placeholder:(UIImage *)placeholder
                   options:(KLWebImageOptions)options
                  progress:(KLWebImageProgressBlock)progress
                 transform:(KLWebImageTransformBlock)transform
                completion:(KLWebImageCompletionBlock)completion {
    [self kl_setImageWithURL:imageURL
                    forState:state
                 placeholder:placeholder
                     options:options
                     manager:nil
                    progress:progress
                   transform:transform
                  completion:completion];
}

- (void)kl_setImageWithURL:(NSURL *)imageURL
                  forState:(UIControlState)state
               placeholder:(UIImage *)placeholder
                   options:(KLWebImageOptions)options
                   manager:(KLWebImageManager *)manager
                  progress:(KLWebImageProgressBlock)progress
                 transform:(KLWebImageTransformBlock)transform
                completion:(KLWebImageCompletionBlock)completion {
    for (NSNumber *num in UIControlStateMulti(state)) {
        [self _kl_setImageWithURL:imageURL
                   forSingleState:num
                      placeholder:placeholder
                          options:options
                          manager:manager
                         progress:progress
                        transform:transform
                       completion:completion];
    }
}

- (void)kl_cancelImageRequestForState:(UIControlState)state {
    for (NSNumber *num in UIControlStateMulti(state)) {
        [self _kl_cancelImageRequestForSingleState:num];
    }
}


#pragma mark - background image

- (void)_kl_setBackgroundImageWithURL:(NSURL *)imageURL
                       forSingleState:(NSNumber *)state
                          placeholder:(UIImage *)placeholder
                              options:(KLWebImageOptions)options
                              manager:(KLWebImageManager *)manager
                             progress:(KLWebImageProgressBlock)progress
                            transform:(KLWebImageTransformBlock)transform
                           completion:(KLWebImageCompletionBlock)completion {
    if ([imageURL isKindOfClass:[NSString class]]) imageURL = [NSURL URLWithString:(id)imageURL];
    manager = manager ? manager : [KLWebImageManager sharedManager];
    
    _KLWebImageSetterDicForButton *dic = objc_getAssociatedObject(self, &_KLWebImageBackgroundSetterKey);
    if (!dic) {
        dic = [_KLWebImageSetterDicForButton new];
        objc_setAssociatedObject(self, &_KLWebImageBackgroundSetterKey, dic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    _KLWebImageSetter *setter = [dic lazySetterForState:state];
    int32_t sentinel = [setter cancelWithNewURL:imageURL];
    
    _kl_dispatch_sync_on_main_queue(^{
        if (!imageURL) {
            if (!(options & KLWebImageOptionIgnorePlaceHolder)) {
                [self setBackgroundImage:placeholder forState:state.integerValue];
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
                [self setBackgroundImage:imageFromMemory forState:state.integerValue];
            }
            if(completion) completion(imageFromMemory, imageURL, KLWebImageFromMemoryCacheFast, KLWebImageStageFinished, nil);
            return;
        }
        
        
        if (!(options & KLWebImageOptionIgnorePlaceHolder)) {
            [self setBackgroundImage:placeholder forState:state.integerValue];
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
                dispatch_async(dispatch_get_main_queue(), ^{
                    BOOL sentinelChanged = weakSetter && weakSetter.sentinel != newSentinel;
                    if (setImage && self && !sentinelChanged) {
                        [self setBackgroundImage:image forState:state.integerValue];
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

- (void)_kl_cancelBackgroundImageRequestForSingleState:(NSNumber *)state {
    _KLWebImageSetterDicForButton *dic = objc_getAssociatedObject(self, &_KLWebImageBackgroundSetterKey);
    _KLWebImageSetter *setter = [dic setterForState:state];
    if (setter) [setter cancel];
}

- (NSURL *)kl_backgroundImageURLForState:(UIControlState)state {
    _KLWebImageSetterDicForButton *dic = objc_getAssociatedObject(self, &_KLWebImageBackgroundSetterKey);
    _KLWebImageSetter *setter = [dic setterForState:UIControlStateSingle(state)];
    return setter.imageURL;
}

- (void)kl_setBackgroundImageWithURL:(NSURL *)imageURL
                            forState:(UIControlState)state
                         placeholder:(UIImage *)placeholder {
    [self kl_setBackgroundImageWithURL:imageURL
                              forState:state
                           placeholder:placeholder
                               options:kNilOptions
                               manager:nil
                              progress:nil
                             transform:nil
                            completion:nil];
}

- (void)kl_setBackgroundImageWithURL:(NSURL *)imageURL
                            forState:(UIControlState)state
                             options:(KLWebImageOptions)options {
    [self kl_setBackgroundImageWithURL:imageURL
                              forState:state
                           placeholder:nil
                               options:options
                               manager:nil
                              progress:nil
                             transform:nil
                            completion:nil];
}

- (void)kl_setBackgroundImageWithURL:(NSURL *)imageURL
                            forState:(UIControlState)state
                         placeholder:(UIImage *)placeholder
                             options:(KLWebImageOptions)options
                          completion:(KLWebImageCompletionBlock)completion {
    [self kl_setBackgroundImageWithURL:imageURL
                              forState:state
                           placeholder:placeholder
                               options:options
                               manager:nil
                              progress:nil
                             transform:nil
                            completion:completion];
}

- (void)kl_setBackgroundImageWithURL:(NSURL *)imageURL
                            forState:(UIControlState)state
                         placeholder:(UIImage *)placeholder
                             options:(KLWebImageOptions)options
                            progress:(KLWebImageProgressBlock)progress
                           transform:(KLWebImageTransformBlock)transform
                          completion:(KLWebImageCompletionBlock)completion {
    [self kl_setBackgroundImageWithURL:imageURL
                              forState:state
                           placeholder:placeholder
                               options:options
                               manager:nil
                              progress:progress
                             transform:transform
                            completion:completion];
}

- (void)kl_setBackgroundImageWithURL:(NSURL *)imageURL
                            forState:(UIControlState)state
                         placeholder:(UIImage *)placeholder
                             options:(KLWebImageOptions)options
                             manager:(KLWebImageManager *)manager
                            progress:(KLWebImageProgressBlock)progress
                           transform:(KLWebImageTransformBlock)transform
                          completion:(KLWebImageCompletionBlock)completion {
    for (NSNumber *num in UIControlStateMulti(state)) {
        [self _kl_setBackgroundImageWithURL:imageURL
                             forSingleState:num
                                placeholder:placeholder
                                    options:options
                                    manager:manager
                                   progress:progress
                                  transform:transform
                                 completion:completion];
    }
}

- (void)kl_cancelBackgroundImageRequestForState:(UIControlState)state {
    for (NSNumber *num in UIControlStateMulti(state)) {
        [self _kl_cancelBackgroundImageRequestForSingleState:num];
    }
}

@end

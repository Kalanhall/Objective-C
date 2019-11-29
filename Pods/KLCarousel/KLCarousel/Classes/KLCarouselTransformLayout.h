//
//  KLCarouselViewLayout.h
//  KLCarouselViewDemo
//
//  Created by kalan on 2019/6/19.
//  Copyright © 2017年 kalan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, KLCarouselTransformLayoutType) {
    KLCarouselTransformLayoutTypeNormal,
    KLCarouselTransformLayoutTypeLinear,
    KLCarouselTransformLayoutTypeCoverflow,
};

@class KLCarouselTransformLayout;
@protocol KLCarouselTransformLayoutDelegate <NSObject>

// initialize layout attributes
- (void)carouselViewTransformLayout:(KLCarouselTransformLayout *)carouselViewTransformLayout initializeTransformAttributes:(UICollectionViewLayoutAttributes *)attributes;

// apply layout attributes
- (void)carouselViewTransformLayout:(KLCarouselTransformLayout *)carouselViewTransformLayout applyTransformToAttributes:(UICollectionViewLayoutAttributes *)attributes;

@end


@interface KLCarouselViewLayout : NSObject

@property (nonatomic, assign) CGSize itemSize;
@property (nonatomic, assign) CGFloat itemSpacing;
@property (nonatomic, assign) UIEdgeInsets sectionInset;

@property (nonatomic, assign) KLCarouselTransformLayoutType layoutType;

@property (nonatomic, assign) CGFloat minimumScale; // sacle default 0.8
@property (nonatomic, assign) CGFloat minimumAlpha; // alpha default 1.0
@property (nonatomic, assign) CGFloat maximumAngle; // angle is % default 0.2

@property (nonatomic, assign) BOOL isInfiniteLoop;  // infinte scroll
@property (nonatomic, assign) CGFloat rateOfChange; // scale and angle change rate
@property (nonatomic, assign) BOOL adjustSpacingWhenScroling; 

/**
 carouselView cell item vertical centering
 */
@property (nonatomic, assign) BOOL itemVerticalCenter;

/**
 first and last item horizontalc enter, when isInfiniteLoop is NO
 */
@property (nonatomic, assign) BOOL itemHorizontalCenter;

// sectionInset
@property (nonatomic, assign, readonly) UIEdgeInsets onlyOneSectionInset;
@property (nonatomic, assign, readonly) UIEdgeInsets firstSectionInset;
@property (nonatomic, assign, readonly) UIEdgeInsets lastSectionInset;
@property (nonatomic, assign, readonly) UIEdgeInsets middleSectionInset;

@end


@interface KLCarouselTransformLayout : UICollectionViewFlowLayout

@property (nonatomic, strong) KLCarouselViewLayout *layout;

@property (nonatomic, weak, nullable) id<KLCarouselTransformLayoutDelegate> delegate;

@end

NS_ASSUME_NONNULL_END

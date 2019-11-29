//
//  KLCarouselControl.h
//  KLCarouselViewDemo
//
//  Created by kalan on 2019/6/20.
//  Copyright © 2017年 kalan. All rights reserved.
//

/** 使用示例
    KLCarouselControl *control = KLCarouselControl.alloc.init;
    control.currentPageIndicatorSize = CGSizeMake(5, 5);
    control.pageIndicatorSize = CGSizeMake(5, 5);
    control.currentPageIndicatorTintColor = UIColor.whiteColor;
    control.pageIndicatorTintColor = UIColor.lightGrayColor;
    control.frame = CGRectMake(0, CGRectGetHeight(frame) - 25, CGRectGetWidth(frame), 25);
    [carousel addSubview:control];
 
    代理设置
    - (void)carouselView:(KLCarouselView *)carouselView didScrollFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
        [self.control setCurrentPage:toIndex animate:YES];
    }
*/

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KLCarouselControl : UIControl

@property (nonatomic, assign) NSInteger numberOfPages;          // default is 0
@property (nonatomic, assign) NSInteger currentPage;            // default is 0.

@property (nonatomic, assign) BOOL hidesForSinglePage;          // hide the the indicator if there is only one page. default is NO

@property (nonatomic, assign) CGFloat pageIndicatorSpaing;
@property (nonatomic, assign) UIEdgeInsets contentInset;    // center will ignore this
@property (nonatomic, assign ,readonly) CGSize contentSize; // real content size

// indicatorTint color
@property (nullable, nonatomic,strong) UIColor *pageIndicatorTintColor;
@property (nullable, nonatomic,strong) UIColor *currentPageIndicatorTintColor;

// indicator image
@property (nullable, nonatomic,strong) UIImage *pageIndicatorImage;
@property (nullable, nonatomic,strong) UIImage *currentPageIndicatorImage;

@property (nonatomic, assign) UIViewContentMode indicatorImageContentMode; // default is UIViewContentModeCenter

@property (nonatomic, assign) CGSize pageIndicatorSize;         // indicator size
@property (nonatomic, assign) CGSize currentPageIndicatorSize;  // default pageIndicatorSize

@property (nonatomic, assign) CGFloat animateDuring; // default 0.3

- (void)setCurrentPage:(NSInteger)currentPage animate:(BOOL)animate;

@end

NS_ASSUME_NONNULL_END

//
//  KLCarousel.h
//  KLCarousel
//
//  Created by Logic on 2019/11/29.
//

#import "KLCarouselView.h"
#import "KLCarouselControl.h"
#import "KLCarouselCell.h"

/** 使用示例
     CGRect rect = CGRectMake(0, 0, self.view.bounds.size.width, 200);
            
 初始化1
     self.carousel = [KLCarousel carouselWithFrame:rect];
     
 初始化2
     KLCarouselViewLayout *layout = KLCarouselViewLayout.alloc.init;
     layout.itemSize = CGSizeMake(rect.size.width * 0.8, rect.size.height * 0.8);
     layout.itemSpacing = 10;
     layout.itemHorizontalCenter = YES;
     layout.itemVerticalCenter = YES;
     layout.layoutType = KLCarouselTransformLayoutTypeCoverflow;
     self.carousel = [KLCarousel carouselWithFrame:rect layout:layout cell:nil];
     
 回调
     self.carousel.didSelectedItemCell = ^(NSInteger index) {
         NSLog(@"Index - %@", @(index));
     };
     
     self.carousel.cellForItemAtIndex = ^(KLCarouselCell * _Nonnull cell, NSInteger index) {
         [cell.imageView sd_setImageWithURL:[NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1575035592451&di=bca037f79660b2bf137c3d1cfcee4c66&imgtype=0&src=http%3A%2F%2Fpic1.win4000.com%2Fwallpaper%2F2017-12-01%2F5a20c01220da2.jpg"]];
     };
     [self.view addSubview:self.carousel];
 
 赋值
     self.carousel.imageURLs = @[@"", @"", @""];
 */

NS_ASSUME_NONNULL_BEGIN

@interface KLCarousel : KLCarouselView

/** 图片地址数组*/
@property (strong, nonatomic) NSArray <NSString *> *imageURLs;
/** 页面指示器*/
@property (strong, nonatomic, readonly) KLCarouselControl *control;

// Cell代理回调
@property (copy, nonatomic) void (^cellForItemAtIndex)(KLCarouselCell *cell, NSInteger index);
// Cell选中回调
@property (copy, nonatomic) void (^didSelectedItemCell)(NSInteger index);

// 初始化方法1
+ (instancetype)carouselWithFrame:(CGRect)frame;
// 初始化方法2
+ (instancetype)carouselWithFrame:(CGRect)frame layout:(nullable KLCarouselViewLayout *)layout cell:(nullable Class)cell;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END

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
 
 *********************************特定场景使用 *********************************
 
    在不能提前确定frame的控件中，或者使用约束以后，Cell中需要重置内部控件布局

    // 控件以frame布局，需要重置控件内部控件尺寸
     - (void)layoutSubviews
     {
         [super layoutSubviews];
         self.carousel.frame = self.frame;
         self.layout.itemSize = CGSizeMake(self.frame.size.width * 0.8, self.frame.size.height * 0.8);
         self.carousel.control.frame = CGRectMake(0, CGRectGetHeight(self.frame) - 20, CGRectGetWidth(self.frame), 20);
     }
 
  *********************************特定场景使用 *********************************
 
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
     [self.view addSubview:self.carousel];
     
 回调
     self.carousel.cellForItemAtIndex = ^(KLCarouselCell * _Nonnull cell, NSInteger index) {
         [cell.imageView sd_setImageWithURL:[NSURL URLWithString:images[index]]]; // cell数据绑定，图片加载控件由外部提供 SD YY等
     };
 
     self.carousel.didSelectedItemCell = ^(NSInteger index) {
         NSLog(@"Index - %@", @(index));
     };
 
 赋值刷新
     self.carousel.images = @[@"", @"", @""]; // cell数据传入字符串数组或者模型数组等
     [self.carousel reload];
 */

NS_ASSUME_NONNULL_BEGIN

@interface KLCarousel : KLCarouselView

/** 图片urls/模型 数组*/
@property (strong, nonatomic) NSArray *images;
/** 页面指示器*/
@property (strong, nonatomic, readonly) KLCarouselControl *control;

// Cell代理回调
@property (copy, nonatomic) void (^cellForItemAtIndex)(KLCarouselCell *cell, NSArray *images, NSInteger index);
// Cell选中回调
@property (copy, nonatomic) void (^didSelectedItemCell)(NSInteger index);

// 初始化方法1
+ (instancetype)carouselWithFrame:(CGRect)frame;
// 初始化方法2
+ (instancetype)carouselWithFrame:(CGRect)frame layout:(nullable KLCarouselViewLayout *)layout cell:(nullable Class)cell;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (void)reloadData;

@end

NS_ASSUME_NONNULL_END

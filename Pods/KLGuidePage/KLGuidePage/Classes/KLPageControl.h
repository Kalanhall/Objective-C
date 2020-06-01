//
//  KLPageControl.h
//  KLGuidePage
//
//  Created by Logic on 2020/5/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KLPageControl : UIControl

/// 总页数，默认 0
@property (nonatomic, assign) NSInteger numberOfPages;
/// 当前页，默认 0
@property (nonatomic, assign) NSInteger currentPage;
/// 当只有一页是否隐藏
@property (nonatomic, assign) BOOL hidesForSinglePage;
/// 点之间的间距
@property (nonatomic, assign) CGFloat pageIndicatorSpaing;

/**
 * 居左居右样式时调整内边距，Center中间忽略
 * contentHorizontalAlignment
 * contentVerticalAlignment
 */
@property (nonatomic, assign) UIEdgeInsets contentInset;
/// 滚动范围
@property (nonatomic, assign ,readonly) CGSize contentSize;

/// 默认点颜色
@property (nullable, nonatomic,strong) UIColor *pageIndicatorTintColor;
/// 当前点颜色
@property (nullable, nonatomic,strong) UIColor *currentPageIndicatorTintColor;

/// 默认点图片
@property (nullable, nonatomic,strong) UIImage *pageIndicatorImage;
/// 当前点图片
@property (nullable, nonatomic,strong) UIImage *currentPageIndicatorImage;
/// 图片渲染模式，默认 = UIViewContentModeCenter
@property (nonatomic, assign) UIViewContentMode indicatorImageContentMode;

/// 默认点尺寸
@property (nonatomic, assign) CGSize pageIndicatorSize;
/// 当前点尺寸
@property (nonatomic, assign) CGSize currentPageIndicatorSize;
/// 点切换时动画时长 = 0.3
@property (nonatomic, assign) CGFloat animateDuring;

/// 设置当前点位置
/// @Param currentPage 当前页下标
/// @Param animate 是否动画
- (void)setCurrentPage:(NSInteger)currentPage animate:(BOOL)animate;

@end

NS_ASSUME_NONNULL_END

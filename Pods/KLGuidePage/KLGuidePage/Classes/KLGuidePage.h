//
//  KLGuidePage.h
//  KLGuidePage
//
//  Created by Logic on 2020/5/28.
//

#import <UIKit/UIKit.h>
#import "KLPageControl.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, KLGuideStyle) {
    /// 普通样式滚动
    KLGuideStyleNomal,
    /// 平移透明渐变
    KLGuideStyleTranslationFade,
    /// 当前位置透明渐变
    KLGuideStyleFade
};

typedef NS_ENUM(NSUInteger, KLGuideHideStyle) {
    /// 透明渐变消失
    KLGuideHideStyleNomal,
    /// 左边移动
    KLGuideHideStyleMoveLeft,
    /// 右边移动
    KLGuideHideStyleMoveRight,
    /// 放大1.2消失
    KLGuideHideStyleScale
};

@class KLGuidePage;

@protocol KLGuidePageDataSource <NSObject>


@required
/// 用于展示的数据集合
- (NSArray *)dataOfItems;

@optional
/// 自定义分页样式Cell
- (UICollectionViewCell *)guidePage:(KLGuidePage *)page data:(id)data cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath;

/// KLGuideStyleFade样式需要实现的代理
- (UIView *)guidePage:(KLGuidePage *)page data:(nullable id)data viewForItemAtIndexPath:(NSIndexPath *)indexPath;

@end

@protocol KLGuidePageDelegate <NSObject>

@optional

/// 滚动回调
- (void)guidePage:(KLGuidePage *)page didScroll:(UIScrollView *)scrollView atIndex:(NSInteger)index;

/// 滚动结束回调
- (void)guidePage:(KLGuidePage *)page didEndScroll:(UIScrollView *)scrollView atIndex:(NSInteger)index;

@end

@interface KLGuidePage : UIView

/// 数据源
@property (weak, nonatomic) id<KLGuidePageDataSource> dataSource;
/// 代理
@property (weak, nonatomic) id<KLGuidePageDelegate> delegate;
/// 页面指示器
@property (strong, nonatomic, readonly) KLPageControl *bottomControl;
/// 指示器高度，默认 10pt
@property (assign, nonatomic) CGFloat bottomlHeight;
/// 指示器距离底部间距，默认 10pt
/// 当有safeArea.bottom时，优先选择大的
@property (assign, nonatomic) CGFloat bottomSpace;
/// 最后一页是否隐藏页面指示器
@property (assign, nonatomic) BOOL hideForLastPage;
/// 渐变系数，影响显示页和消失页的alpha变化快慢，默认 = 1
@property (assign, nonatomic) CGFloat alphaMultiple;
/// 隐藏动画时间，默认 = 0.5
@property (assign, nonatomic) CGFloat duration;

/// MARK: - 显示方法
/// @Param style            滑动时的显示样式
+ (instancetype)pageWithStyle:(KLGuideStyle)style dataSource:(id <KLGuidePageDataSource>)dataSource;

/// MARK: - 隐藏方法
- (void)hideWithStyle:(KLGuideHideStyle)style animated:(BOOL)animated;

/// MARK: - 注册Cell
- (void)registerClass:(Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier;

/// MARK: - 复用Cell
- (UICollectionViewCell *)dequeueReusableCellWithReuseIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END

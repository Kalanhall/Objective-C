//
//  KLGuidePage.m
//  KLGuidePage
//
//  Created by Logic on 2020/5/28.
//

#import "KLGuidePage.h"
#import <Masonry/Masonry.h>

@interface KLGuidePage () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) UICollectionView *collectionView;
// 指示器
@property (strong, nonatomic) KLPageControl *bottomControl;
// 数据源
@property (strong, nonatomic) NSArray *datas;
// 当前位移
@property (assign, nonatomic) CGFloat currentX;
// 渐变样式
@property (assign, nonatomic) KLGuideStyle style;
// 回调Block
@property (copy,   nonatomic) void (^compltion)(BOOL finish, NSInteger index);

@end

@implementation KLGuidePage

- (instancetype)initWithFrame:(CGRect)frame withStyle:(KLGuideStyle)style {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.whiteColor;
        self.style = style;
        self.alphaMultiple = 1;
        self.bottomlHeight = 20;
        self.bottomSpace = 10;
        self.duration = 0.5;
        
        UICollectionViewFlowLayout *layout = UICollectionViewFlowLayout.alloc.init;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.collectionView = [UICollectionView.alloc initWithFrame:self.bounds collectionViewLayout:layout];
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        self.collectionView.pagingEnabled = YES;
        self.collectionView.backgroundColor = UIColor.clearColor;
        self.collectionView.showsHorizontalScrollIndicator = NO;
        self.collectionView.bounces = style != KLGuideStyleFade;
        [self.collectionView registerClass:UICollectionViewCell.class forCellWithReuseIdentifier:UICollectionViewCell.description];
        [self addSubview:self.collectionView];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
        
        self.bottomControl = KLPageControl.alloc.init;
        self.bottomControl.pageIndicatorSpaing = 5;
        self.bottomControl.pageIndicatorSize = CGSizeMake(8, 5);
        self.bottomControl.currentPageIndicatorSize = CGSizeMake(15, 5);
        self.bottomControl.currentPageIndicatorTintColor = UIColor.blackColor;
        self.bottomControl.pageIndicatorTintColor = UIColor.lightGrayColor;
        self.bottomControl.contentInset = UIEdgeInsetsMake(0, 0, 0, 30);
        [self addSubview:self.bottomControl];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.bottomControl mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self.bottomlHeight);
        make.bottom.mas_equalTo(-self.bottomSpace);
        make.left.right.mas_equalTo(0);
    }];
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(dataOfItems)]) {
        self.datas = [self.dataSource dataOfItems];
    }
    
    return self.bottomControl.numberOfPages = self.datas.count;
}

- (UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    // 初始化特定视图
    if (self.style == KLGuideStyleFade) {
        // 创建对应数量的图片视图
        if (self.dataSource && [self.dataSource respondsToSelector:@selector(guidePage:data:viewForItemAtIndexPath:)]) {
            UIView *view = [self viewWithTag:indexPath.row + 1000];
            if (view == nil) {
                view = [self.dataSource guidePage:self data:self.datas[indexPath.row] viewForItemAtIndexPath:indexPath];
                view.tag = indexPath.row + 1000;
                [self insertSubview:view atIndex:0];
                [view mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.mas_equalTo(UIEdgeInsetsZero);
                }];
            }
        }
    }
    
    // MARK: 有自定义Cell样式，则返回该样式
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(guidePage:data:cellForItemAtIndexPath:)]) {
        return [self.dataSource guidePage:self data:self.datas[indexPath.row] cellForItemAtIndexPath:indexPath];
    }

    // MARK: 默认Cell样式
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:UICollectionViewCell.description forIndexPath:indexPath];
    return cell;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.currentX = scrollView.contentOffset.x;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger index = roundf(scrollView.contentOffset.x / scrollView.bounds.size.width);
    [self.bottomControl setCurrentPage:index animate:YES];
    
    if (self.hideForLastPage) {
        [UIView animateWithDuration:0.25 animations:^{
            self.bottomControl.alpha = (index == self.datas.count - 1) ? 0 : 1;
        }];
    }

    NSInteger currentIndex = roundf(self.currentX / scrollView.bounds.size.width);
    NSInteger nextIndex = 0;
    NSInteger tag = currentIndex + 1000;
    NSInteger nextTag = 0;
    if (scrollView.contentOffset.x > self.currentX) {
        // 左滑
        nextIndex = currentIndex + 1;
        nextTag = tag + 1;
    } else {
        // 右滑
        nextIndex = currentIndex - 1;
        nextTag = tag - 1;
    }
    CGFloat alpha = fabs(scrollView.contentOffset.x - currentIndex * scrollView.bounds.size.width) / scrollView.bounds.size.width;
    
    switch (self.style) {
        case KLGuideStyleTranslationFade: {
            UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:currentIndex inSection:0]];
            UICollectionViewCell *nextCell = [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:nextIndex inSection:0]];
            nextCell.alpha = alpha * self.alphaMultiple;
            cell.alpha = 1 - alpha * self.alphaMultiple;
        }
            break;
        case KLGuideStyleFade: {
            UIView *view = [self viewWithTag:tag];
            UIView *nextView = [self viewWithTag:nextTag];
            if (scrollView.contentOffset.x > self.currentX) {
                // 左滑
                nextView.alpha = 1;
                view.alpha = 1 - alpha * self.alphaMultiple;
            } else {
                // 右滑
                nextView.alpha = alpha * self.alphaMultiple;
                view.alpha = 1;
            }
        }
            break;
        default:
            break;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(guidePage:didScroll:atIndex:)]) {
        [self.delegate guidePage:self didScroll:scrollView atIndex:index];
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger index = roundf(scrollView.contentOffset.x / scrollView.bounds.size.width);
    if (self.delegate && [self.delegate respondsToSelector:@selector(guidePage:didEndScroll:atIndex:)]) {
        [self.delegate guidePage:self didEndScroll:scrollView atIndex:index];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return collectionView.bounds.size;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

// MARK: - 显示方法
+ (instancetype)pageWithStyle:(KLGuideStyle)style dataSource:(id <KLGuidePageDataSource>)dataSource {
    KLGuidePage *page = [KLGuidePage.alloc initWithFrame:CGRectZero withStyle:style];
    page.dataSource = dataSource;
    [UIApplication.sharedApplication.keyWindow addSubview:page];
    [page mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    return page;
}

// MARK: - 隐藏方法
- (void)hideWithStyle:(KLGuideHideStyle)style animated:(BOOL)animated {
    [UIView animateWithDuration:animated ? self.duration : 0 animations:^{
        switch (style) {
            case KLGuideHideStyleNomal:
                self.alpha = 0;
                break;
            case KLGuideHideStyleMoveLeft:
            self.alpha = 0;
                self.transform = CGAffineTransformMakeTranslation(-self.bounds.size.width, 0);
                break;
            case KLGuideHideStyleMoveRight:
            self.alpha = 0;
            self.transform = CGAffineTransformMakeTranslation(self.bounds.size.width, 0);
                break;
            case KLGuideHideStyleScale:
                self.alpha = 0;
                self.transform = CGAffineTransformMakeScale(1.2, 1.2);
                break;
            default:
                break;
        }
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

// MARK: - Cell注册
- (void)registerClass:(Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier {
    [self.collectionView registerClass:cellClass forCellWithReuseIdentifier:identifier];
}

// MARK: - Cell复用
- (UICollectionViewCell *)dequeueReusableCellWithReuseIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath {
    return [self.collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
}

@end

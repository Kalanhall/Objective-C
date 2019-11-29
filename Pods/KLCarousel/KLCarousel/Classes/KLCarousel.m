//
//  KLCarousel.m
//  KLCarousel
//
//  Created by Logic on 2019/11/29.
//

#import "KLCarousel.h"
#import "KLCarouselCell.h"

@interface KLCarousel () <KLCarouselViewDataSource, KLCarouselViewDelegate>

@property (strong, nonatomic) KLCarouselControl *control;
@property (strong, nonatomic) KLCarouselViewLayout *customLayout;
@property (strong, nonatomic) Class cellClass;

@end

@implementation KLCarousel

+ (instancetype)carouselWithFrame:(CGRect)frame {
    return [self carouselWithFrame:frame layout:nil cell:nil];
}

+ (instancetype)carouselWithFrame:(CGRect)frame layout:(nullable KLCarouselViewLayout *)layout cell:(nullable Class)cell
{
    KLCarousel *carousel = KLCarousel.alloc.init;
    carousel.isInfiniteLoop = YES;
    carousel.autoScrollInterval = 3;
    carousel.dataSource = carousel;
    carousel.delegate = carousel;
    carousel.frame = frame;
    // registerClass or registerNib
    carousel.cellClass = cell ? : KLCarouselCell.class;
    [carousel registerClass:carousel.cellClass forCellWithReuseIdentifier:carousel.cellClass.description];
    
    KLCarouselControl *control = KLCarouselControl.alloc.init;
    control.currentPageIndicatorSize = CGSizeMake(5, 5);
    control.pageIndicatorSize = CGSizeMake(5, 5);
    control.currentPageIndicatorTintColor = UIColor.whiteColor;
    control.pageIndicatorTintColor = UIColor.lightGrayColor;
    control.frame = CGRectMake(0, CGRectGetHeight(frame) - 25, CGRectGetWidth(frame), 25);
    [carousel addSubview:control];
    
    carousel.control = control;
    carousel.customLayout = layout;
    if (layout == nil) {
        KLCarouselViewLayout *layout = KLCarouselViewLayout.alloc.init;
        layout.itemSize = frame.size;
        layout.itemSpacing = 0;
        layout.itemHorizontalCenter = YES;
        carousel.customLayout = layout;
    }
    
    return carousel;
}

- (NSInteger)numberOfItemsInCarouselView:(nonnull KLCarouselView *)carouselView {
    self.control.numberOfPages = self.imageURLs.count;
    return self.control.numberOfPages;
}

- (nonnull KLCarouselViewLayout *)layoutForCarouselView:(nonnull KLCarouselView *)carouselView {
    return self.customLayout;
}

- (nonnull __kindof UICollectionViewCell *)carouselView:(nonnull KLCarouselView *)carouselView cellForItemAtIndex:(NSInteger)index {
    KLCarouselCell *cell = [carouselView dequeueReusableCellWithReuseIdentifier:self.cellClass.description forIndex:index];
    
    if (self.cellForItemAtIndex) {
        self.cellForItemAtIndex(cell, index);
    }
    
    return cell;
}

- (void)carouselView:(KLCarouselView *)carouselView didScrollFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
    [self.control setCurrentPage:toIndex animate:YES];
}

- (void)carouselView:(KLCarouselView *)carouselView didSelectedItemCell:(__kindof UICollectionViewCell *)cell atIndex:(NSInteger)index {
    if (self.didSelectedItemCell) {
        self.didSelectedItemCell(index);
    }
}

- (void)setImageURLs:(NSArray<NSString *> *)imageURLs
{
    if ([imageURLs isEqualToArray:_imageURLs]) return;
    _imageURLs = imageURLs;
    [self reloadData];
}

@end

//
//  KLCarouselView.h
//  KLCarouselViewDemo
//
//  Created by kalan on 2019/6/14.
//  Copyright © 2017年 kalan. All rights reserved.
//

/** 使用示例
     KLCarousel *carousel = KLCarousel.alloc.init;
     carousel.isInfiniteLoop = YES;
     carousel.autoScrollInterval = 3.5;
     carousel.dataSource = carousel;
     carousel.delegate = carousel;
     carousel.frame = frame;
     [carousel registerClass:KLCarouselCell.class forCellWithReuseIdentifier:KLCarouselCell.description];
     [self.view addSubview:carousel];
 
    代理设置
     - (NSInteger)numberOfItemsInCarouselView:(nonnull KLCarouselView *)carouselView {
         self.control.numberOfPages = self.imageURLs.count;
         return self.control.numberOfPages;
     }

     - (nonnull KLCarouselViewLayout *)layoutForCarouselView:(nonnull KLCarouselView *)carouselView {
         KLCarouselViewLayout *layout = KLCarouselViewLayout.alloc.init;
         layout.itemSize = carouselView.frame.size;
         layout.itemSpacing = 0;
         layout.itemHorizontalCenter = YES;
         return layout;
     }

     - (nonnull __kindof UICollectionViewCell *)carouselView:(nonnull KLCarouselView *)carouselView cellForItemAtIndex:(NSInteger)index {
         KLCarouselCell *cell = [carouselView dequeueReusableCellWithReuseIdentifier:KLCarouselCell.description forIndex:index];
         cell.layer.borderWidth = 1;
         return cell;
     }

     - (void)carouselView:(KLCarouselView *)carouselView didScrollFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
         [self.control setCurrentPage:toIndex animate:YES];
     }

     - (void)carouselView:(KLCarouselView *)carouselView didSelectedItemCell:(__kindof UICollectionViewCell *)cell atIndex:(NSInteger)index {
         
     }
 */

#import <UIKit/UIKit.h>
#import "KLCarouselTransformLayout.h"

NS_ASSUME_NONNULL_BEGIN

typedef struct {
    NSInteger index;
    NSInteger section;
}KLIndexSection;

// carouselView scrolling direction
typedef NS_ENUM(NSUInteger, KLPagerScrollDirection) {
    KLPagerScrollDirectionLeft,
    KLPagerScrollDirectionRight,
};

@class KLCarouselView;
@protocol KLCarouselViewDataSource <NSObject>

- (NSInteger)numberOfItemsInCarouselView:(KLCarouselView *)carouselView;

- (__kindof UICollectionViewCell *)carouselView:(KLCarouselView *)carouselView cellForItemAtIndex:(NSInteger)index;

/**
 return carouselView layout,and cache layout
 */
- (KLCarouselViewLayout *)layoutForCarouselView:(KLCarouselView *)carouselView;

@end

@protocol KLCarouselViewDelegate <NSObject>

@optional

/**
 carouselView did scroll to new index page
 */
- (void)carouselView:(KLCarouselView *)carouselView didScrollFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex;

/**
 carouselView did selected item cell
 */
- (void)carouselView:(KLCarouselView *)carouselView didSelectedItemCell:(__kindof UICollectionViewCell *)cell atIndex:(NSInteger)index;
- (void)carouselView:(KLCarouselView *)carouselView didSelectedItemCell:(__kindof UICollectionViewCell *)cell atIndexSection:(KLIndexSection)indexSection;

// custom layout
- (void)carouselView:(KLCarouselView *)carouselView initializeTransformAttributes:(UICollectionViewLayoutAttributes *)attributes;

- (void)carouselView:(KLCarouselView *)carouselView applyTransformToAttributes:(UICollectionViewLayoutAttributes *)attributes;


// scrollViewDelegate

- (void)carouselViewDidScroll:(KLCarouselView *)carouselView;

- (void)carouselViewWillBeginDragging:(KLCarouselView *)carouselView;

- (void)carouselViewDidEndDragging:(KLCarouselView *)carouselView willDecelerate:(BOOL)decelerate;

- (void)carouselViewWillBeginDecelerating:(KLCarouselView *)carouselView;

- (void)carouselViewDidEndDecelerating:(KLCarouselView *)carouselView;

- (void)carouselViewWillBeginScrollingAnimation:(KLCarouselView *)carouselView;

- (void)carouselViewDidEndScrollingAnimation:(KLCarouselView *)carouselView;

@end


@interface KLCarouselView : UIView

// will be automatically resized to track the size of the carouselView
@property (nonatomic, strong, nullable) UIView *backgroundView; 

@property (nonatomic, weak, nullable) id<KLCarouselViewDataSource> dataSource;
@property (nonatomic, weak, nullable) id<KLCarouselViewDelegate> delegate;

// pager view, don't set dataSource and delegate
@property (nonatomic, weak, readonly) UICollectionView *collectionView;
// pager view layout
@property (nonatomic, strong, readonly) KLCarouselViewLayout *layout;

/**
 is infinite cycle pageview
 */
@property (nonatomic, assign) BOOL isInfiniteLoop;

/**
 carouselView automatic scroll time interval, default 0,disable automatic
 */
@property (nonatomic, assign) CGFloat autoScrollInterval;

@property (nonatomic, assign) BOOL reloadDataNeedResetIndex;

/**
 current page index
 */
@property (nonatomic, assign, readonly) NSInteger curIndex;
@property (nonatomic, assign, readonly) KLIndexSection indexSection;

// scrollView property
@property (nonatomic, assign, readonly) CGPoint contentOffset;
@property (nonatomic, assign, readonly) BOOL tracking;
@property (nonatomic, assign, readonly) BOOL dragging;
@property (nonatomic, assign, readonly) BOOL decelerating;


/**
 reload data, !!important!!: will clear layout and call delegate layoutForCarouselView
 */
- (void)reloadData;

/**
 update data is reload data, but not clear layuot
 */
- (void)updateData;

/**
 if you only want update layout
 */
- (void)setNeedUpdateLayout;

/**
 will set layout nil and call delegate->layoutForCarouselView
 */
- (void)setNeedClearLayout;

/**
 current index cell in carouselView
 */
- (__kindof UICollectionViewCell * _Nullable)curIndexCell;

/**
 visible cells in carouselView
 */
- (NSArray<__kindof UICollectionViewCell *> *_Nullable)visibleCells;


/**
 visible carouselView indexs, maybe repeat index
 */
- (NSArray *)visibleIndexs;

/**
 scroll to item at index
 */
- (void)scrollToItemAtIndex:(NSInteger)index animate:(BOOL)animate;
- (void)scrollToItemAtIndexSection:(KLIndexSection)indexSection animate:(BOOL)animate;
/**
 scroll to next or pre item
 */
- (void)scrollToNearlyIndexAtDirection:(KLPagerScrollDirection)direction animate:(BOOL)animate;

/**
 register pager view cell with class
 */
- (void)registerClass:(Class)Class forCellWithReuseIdentifier:(NSString *)identifier;

/**
 register pager view cell with nib
 */
- (void)registerNib:(UINib *)nib forCellWithReuseIdentifier:(NSString *)identifier;

/**
 dequeue reusable cell for carouselView
 */
- (__kindof UICollectionViewCell *)dequeueReusableCellWithReuseIdentifier:(NSString *)identifier forIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END

//
//  KLCollectionViewHorzontalLayout.m
//  KLCollectionView
//
//  Created by Kalan on 2019/7/15.
//  Copyright © 2019 Kalan. All rights reserved.
//

#import "KLCollectionViewHorzontalLayout.h"
#import "KLCollectionReusableView.h"
#import "KLCollectionViewLayoutAttributes.h"

@interface KLCollectionViewHorzontalLayout()

@end

@implementation KLCollectionViewHorzontalLayout

#pragma mark - 初始化属性
- (instancetype)init {
    self = [super init];
    if (self) {
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return self;
}

- (void)prepareLayout {
    [super prepareLayout];
    
    CGFloat totalHeight = self.collectionView.frame.size.height;
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat headerW = 0;
    CGFloat footerW = 0;
    UIEdgeInsets edgeInsets = UIEdgeInsetsZero;
    CGFloat minimumLineSpacing = 0;
    CGFloat minimumInteritemSpacing = 0;
    NSUInteger sectionCount = [self.collectionView numberOfSections];
    self.attributesArray = [NSMutableArray new];
    self.collectionHeightsArray = [NSMutableArray arrayWithCapacity:sectionCount];
    for (int index= 0; index<sectionCount; index++) {
        NSUInteger itemCount = [self.collectionView numberOfItemsInSection:index];
        if (self.delegate && [self.delegate respondsToSelector:@selector(collectionView:layout:referenceSizeForHeaderInSection:)]) {
            headerW = [self.delegate collectionView:self.collectionView layout:self referenceSizeForHeaderInSection:index].width;
        } else {
            headerW = self.headerReferenceSize.width;
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(collectionView:layout:referenceSizeForFooterInSection:)]) {
            footerW = [self.delegate collectionView:self.collectionView layout:self referenceSizeForFooterInSection:index].width;
        } else {
            footerW = self.footerReferenceSize.width;
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)]) {
            edgeInsets = [self.delegate collectionView:self.collectionView layout:self insetForSectionAtIndex:index];
        } else {
            edgeInsets = self.sectionInset;
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(collectionView:layout:minimumLineSpacingForSectionAtIndex:)]) {
            minimumLineSpacing = [self.delegate collectionView:self.collectionView layout:self minimumLineSpacingForSectionAtIndex:index];
        } else {
            minimumLineSpacing = self.minimumLineSpacing;
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(collectionView:layout:minimumInteritemSpacingForSectionAtIndex:)]) {
            minimumInteritemSpacing = [self.delegate collectionView:self.collectionView layout:self minimumInteritemSpacingForSectionAtIndex:index];
        } else {
            minimumInteritemSpacing = self.minimumInteritemSpacing;
        }
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(collectionView:layout:registerBackView:)]) {
            NSString* className = [self.delegate collectionView:self.collectionView layout:self registerBackView:index];
            if (className != nil && className.length > 0) {
                NSAssert([[NSClassFromString(className) alloc]init]!=nil, @"代理collectionView:layout:registerBackView:里面必须返回有效的类名!");
                [self registerClass:NSClassFromString(className) forDecorationViewOfKind:className];
            } else {
                [self registerClass:[KLCollectionReusableView class] forDecorationViewOfKind:@"KLCollectionReusableView"];
            }
        }
        else {
            [self registerClass:[KLCollectionReusableView class] forDecorationViewOfKind:@"KLCollectionReusableView"];
        }
        x = [self maxHeightWithSection:index];
        y = edgeInsets.top;
        
        // 添加页首属性
        if (headerW > 0) {
            NSIndexPath *headerIndexPath = [NSIndexPath indexPathForItem:0 inSection:index];
            KLCollectionViewLayoutAttributes* headerAttr = [KLCollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:headerIndexPath];
            headerAttr.frame = CGRectMake(x, 0, headerW, self.collectionView.frame.size.height);
            [self.attributesArray addObject:headerAttr];
        }
        
        x += headerW ;
        CGFloat itemStartX = x;
        CGFloat lastX = x;
        
        if (itemCount > 0) {
            x += edgeInsets.left;
            if (self.delegate && [self.delegate respondsToSelector:@selector(collectionView:layout:typeOfLayout:)]) {
                self.layoutType = [self.delegate collectionView:self.collectionView layout:self typeOfLayout:index];
            }
            NSAssert((self.layoutType==LabelVerticalLayout||self.layoutType==ColumnLayout||self.layoutType==AbsoluteLayout), @"横向布局暂时只支持LabelVerticalLayout,ColumnLayout,AbsoluteLayout!");
            //NSInteger columnCount = 1;
            if (self.delegate && [self.delegate respondsToSelector:@selector(collectionView:layout:columnCountOfSection:)]) {
                self.columnCount = [self.delegate collectionView:self.collectionView layout:self columnCountOfSection:index];
            }
            // 定义一个列高数组 记录每一列的总高度
            CGFloat *columnWidths = (CGFloat *) malloc(self.columnCount * sizeof(CGFloat));
            CGFloat itemHeight = 0.0;
            if (self.layoutType == ClosedLayout) {
                for (int i=0; i<self.columnCount; i++) {
                    columnWidths[i] = x;
                }
                itemHeight = (totalHeight - edgeInsets.top - edgeInsets.bottom - minimumInteritemSpacing * (self.columnCount - 1)) / self.columnCount;
            }
            
            NSMutableArray* arrayOfAbsolute = [NSMutableArray new]; //储存绝对定位布局的数组
            
            for (int i=0; i<itemCount; i++) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:index];
                CGSize itemSize = CGSizeZero;
                if (self.delegate && [self.delegate respondsToSelector:@selector(collectionView:layout:sizeForItemAtIndexPath:)]) {
                    itemSize = [self.delegate collectionView:self.collectionView layout:self sizeForItemAtIndexPath:indexPath];
                } else {
                    itemSize = self.itemSize;
                }
                KLCollectionViewLayoutAttributes *attributes = [KLCollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
                
                NSInteger preRow = self.attributesArray.count - 1;
                switch (self.layoutType) {
#pragma mark 纵向标签布局处理
                    case LabelVerticalLayout: {
                        //找上一个cell
                        if(preRow >= 0){
                            if(i > 0) {
                                KLCollectionViewLayoutAttributes *preAttr = self.attributesArray[preRow];
                                y = preAttr.frame.origin.y + preAttr.frame.size.height + minimumInteritemSpacing;
                                if (y + itemSize.height > totalHeight - edgeInsets.bottom) {
                                    y = edgeInsets.top;
                                    x += itemSize.width + minimumLineSpacing;
                                }
                            }
                        }
                        attributes.frame = CGRectMake(x, y, itemSize.width, itemSize.height);
                    }
                        break;
                    case LabelHorizontalLayout: {
                        
                    }
                        break;
#pragma mark 列布局处理 | 横向标签布局处理
                    case ClosedLayout: {
                        CGFloat max = CGFLOAT_MAX;
                        NSInteger column = 0;
                        for (int i = 0; i < self.columnCount; i++) {
                            if (columnWidths[i] < max) {
                                max = columnWidths[i];
                                column = i;
                            }
                        }
                        CGFloat itemX = columnWidths[column];
                        CGFloat itemY = edgeInsets.top + (itemHeight+minimumInteritemSpacing)*column;
                        attributes.frame = CGRectMake(itemX, itemY, itemSize.width, itemHeight);
                        columnWidths[column] += (itemSize.width + minimumLineSpacing);
                    }
                        break;
                    case AbsoluteLayout: {
                        CGRect itemFrame = CGRectZero;
                        if (self.delegate && [self.delegate respondsToSelector:@selector(collectionView:layout:rectOfItem:)]) {
                            itemFrame = [self.delegate collectionView:self.collectionView layout:self rectOfItem:indexPath];
                        }
                        CGFloat absolute_x = x+itemFrame.origin.x;
                        CGFloat absolute_y = edgeInsets.top+itemFrame.origin.y;
                        CGFloat absolute_h = itemFrame.size.height;
                        if ((absolute_y+absolute_h>self.collectionView.frame.size.height-edgeInsets.bottom)&&(absolute_y<self.collectionView.frame.size.height-edgeInsets.top)) {
                            absolute_h -= (absolute_y+absolute_h-(self.collectionView.frame.size.height-edgeInsets.bottom));
                        }
                        CGFloat absolute_w = itemFrame.size.width;
                        attributes.frame = CGRectMake(absolute_x, absolute_y, absolute_w, absolute_h);
                        [arrayOfAbsolute addObject:attributes];
                    }
                        break;
                        
                    default:
                        break;
                }
                if (self.delegate && [self.delegate respondsToSelector:@selector(collectionView:layout:transformOfItem:)]) {
                    attributes.transform3D = [self.delegate collectionView:self.collectionView layout:self transformOfItem:indexPath];
                }
                if (self.delegate && [self.delegate respondsToSelector:@selector(collectionView:layout:zIndexOfItem:)]) {
                    attributes.zIndex = [self.delegate collectionView:self.collectionView layout:self zIndexOfItem:indexPath];
                }
                if (self.delegate && [self.delegate respondsToSelector:@selector(collectionView:layout:alphaOfItem:)]) {
                    attributes.alpha = [self.delegate collectionView:self.collectionView layout:self alphaOfItem:indexPath];
                }
                attributes.indexPath = indexPath;
                if (self.layoutType != PercentLayout) {
                    [self.attributesArray addObject:attributes];
                }
                if (self.layoutType == ClosedLayout) {
                    CGFloat max = 0;
                    for (int i = 0; i < self.columnCount; i++) {
                        if (columnWidths[i] > max) {
                            max = columnWidths[i];
                        }
                    }
                    lastX = max;
                } else if (self.layoutType == AbsoluteLayout) {
                    if (i==itemCount-1) {
                        for (KLCollectionViewLayoutAttributes* attr in arrayOfAbsolute) {
                            if (lastX < attr.frame.origin.x+attr.frame.size.width) {
                                lastX = attr.frame.origin.x+attr.frame.size.width;
                            }
                        }
                    }
                } else {
                    lastX = attributes.frame.origin.x + attributes.frame.size.width;
                }
            }
            free(columnWidths);
        }
        if (self.layoutType == ClosedLayout) {
            lastX -= minimumLineSpacing;
        }
        lastX += edgeInsets.right;
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(collectionView:layout:registerBackView:)]) {
            NSString* className = [self.delegate collectionView:self.collectionView layout:self registerBackView:index];
            if (className != nil && className.length > 0) {
                KLCollectionViewLayoutAttributes *attr = [KLCollectionViewLayoutAttributes  layoutAttributesForDecorationViewOfKind:className withIndexPath:[NSIndexPath indexPathForRow:0 inSection:index]];
                attr.frame = CGRectMake([self isAttachToTop:index]?itemStartX-headerW:itemStartX, 0, lastX-itemStartX+([self isAttachToTop:index]?headerW:0), self.collectionView.frame.size.height);
                attr.zIndex = -1000;
                [self.attributesArray addObject:attr];
                if (self.delegate && [self.delegate respondsToSelector:@selector(collectionView:layout:loadView:)]) {
                    [self.delegate collectionView:self.collectionView layout:self loadView:index];
                }
            } else {
                KLCollectionViewLayoutAttributes *attr = [KLCollectionViewLayoutAttributes  layoutAttributesForDecorationViewOfKind:@"KLCollectionReusableView" withIndexPath:[NSIndexPath indexPathForRow:0 inSection:index]];
                attr.frame = CGRectMake([self isAttachToTop:index]?itemStartX-headerW:itemStartX, 0, lastX-itemStartX+([self isAttachToTop:index]?headerW:0), self.collectionView.frame.size.height);
                attr.color = self.collectionView.backgroundColor;
                if (self.delegate && [self.delegate respondsToSelector:@selector(collectionView:layout:backColorForSection:)]) {
                    attr.color = [self.delegate collectionView:self.collectionView layout:self backColorForSection:index];
                }
                attr.zIndex = -1000;
                [self.attributesArray addObject:attr];
            }
        } else {
            KLCollectionViewLayoutAttributes *attr = [KLCollectionViewLayoutAttributes  layoutAttributesForDecorationViewOfKind:@"KLCollectionReusableView" withIndexPath:[NSIndexPath indexPathForRow:0 inSection:index]];
            attr.frame = CGRectMake([self isAttachToTop:index]?itemStartX-headerW:itemStartX, 0, lastX-itemStartX+([self isAttachToTop:index]?headerW:0), self.collectionView.frame.size.height);
            attr.color = self.collectionView.backgroundColor;
            if (self.delegate && [self.delegate respondsToSelector:@selector(collectionView:layout:backColorForSection:)]) {
                attr.color = [self.delegate collectionView:self.collectionView layout:self backColorForSection:index];
            }
            attr.zIndex = -1000;
            [self.attributesArray addObject:attr];
        }
        
        // 添加页脚属性
        if (footerW > 0) {
            NSIndexPath *footerIndexPath = [NSIndexPath indexPathForItem:0 inSection:index];
            KLCollectionViewLayoutAttributes *footerAttr = [KLCollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter withIndexPath:footerIndexPath];
            footerAttr.frame = CGRectMake(lastX, 0, footerW, self.collectionView.frame.size.height);
            [self.attributesArray addObject:footerAttr];
            lastX += footerW;
        }
        self.collectionHeightsArray[index] = [NSNumber numberWithFloat:lastX];
    }
}

#pragma mark - CollectionView的滚动范围
- (CGSize)collectionViewContentSize {
    if (self.collectionHeightsArray.count <= 0) {
        return CGSizeMake(self.collectionView.frame.size.width, self.collectionView.frame.size.height);
    }
    CGFloat footerW = 0.0f;
    if (self.delegate && [self.delegate respondsToSelector:@selector(collectionView:layout:referenceSizeForFooterInSection:)]) {
        footerW = [self.delegate collectionView:self.collectionView layout:self referenceSizeForFooterInSection:self.collectionHeightsArray.count-1].width;
    } else {
        footerW = self.footerReferenceSize.width;
    }
    UIEdgeInsets edgeInsets = UIEdgeInsetsZero;
    if (self.delegate && [self.delegate respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)]) {
        edgeInsets = [self.delegate collectionView:self.collectionView layout:self insetForSectionAtIndex:self.collectionHeightsArray.count-1];
    } else {
        edgeInsets = self.sectionInset;
    }
    return CGSizeMake([self.collectionHeightsArray[self.collectionHeightsArray.count-1] floatValue], self.collectionView.frame.size.height);
}

/**
 每个区的初始X坐标
 @param section 区索引
 @return Y坐标
 */
- (CGFloat)maxHeightWithSection:(NSInteger)section {
    if (section > 0) {
        return [self.collectionHeightsArray[section-1] floatValue];
    } else {
        return 0;
    }
}

- (BOOL)isAttachToTop:(NSInteger)section {
    if (self.delegate && [self.delegate respondsToSelector:@selector(collectionView:layout:attachToTop:)]) {
        return [self.delegate collectionView:self.collectionView layout:self attachToTop:section];
    }
    return NO;
}

@end

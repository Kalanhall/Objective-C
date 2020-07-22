//
//  AppGuideCell.h
//  Objective-C
//
//  Created by Kalan on 2020/7/22.
//  Copyright © 2020 Kalan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AppGuideCell : UICollectionViewCell

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *subTitleLabel;
@property (strong, nonatomic) UIButton *entryBtn;

@property (copy  , nonatomic) void (^entryBlock)(void);

@end

NS_ASSUME_NONNULL_END

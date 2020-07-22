//
//  AppGuideCell.m
//  Objective-C
//
//  Created by Kalan on 2020/7/22.
//  Copyright © 2020 Kalan. All rights reserved.
//

#import "AppGuideCell.h"
@import Masonry;

@implementation AppGuideCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = UIImageView.alloc.init;
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:self.imageView];
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
        
        self.titleLabel = UILabel.new;
        self.titleLabel.textColor = UIColor.blackColor;
        self.titleLabel.font = [UIFont boldSystemFontOfSize:25];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.centerY.mas_equalTo(self.contentView.mas_centerY).multipliedBy(1.3);
        }];
        
        self.subTitleLabel = UILabel.new;
        self.subTitleLabel.textColor = [UIColor.blackColor colorWithAlphaComponent:0.6];
        self.subTitleLabel.font = [UIFont systemFontOfSize:16];
        self.subTitleLabel.numberOfLines = 0;
        self.subTitleLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.subTitleLabel];
        [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(15);
        }];
        
        self.entryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.entryBtn.backgroundColor = UIColor.redColor;
        self.entryBtn.layer.cornerRadius = 5;
        self.entryBtn.clipsToBounds = YES;
        [self.entryBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [self.entryBtn setTitle:@"立即体验" forState:UIControlStateNormal];
        [self.contentView addSubview:self.entryBtn];
        [self.entryBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(self.mas_width).multipliedBy(0.5);
            make.height.mas_equalTo(50);
            make.centerX.mas_equalTo(0);
            make.bottom.mas_equalTo(-50);
        }];
        
        [self.entryBtn addTarget:self action:@selector(entryBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)entryBtnClick:(UIButton *)sender {
    if (self.entryBlock) {
        self.entryBlock();
    }
}

@end

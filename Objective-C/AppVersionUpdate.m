//
//  AppUpdate.m
//  Objective-C
//
//  Created by Logic on 2020/6/2.
//  Copyright © 2020 Kalan. All rights reserved.
//

#import "AppVersionUpdate.h"
@import Masonry;
@import KLCategory;

@interface AppVersionUpdate ()

@property (strong, nonatomic) UIView *coverView;
@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) UIImageView *updateIcon;
@property (strong, nonatomic) UIButton *updateCancle;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UITextView *descripView;
@property (strong, nonatomic) UIButton *updateBtn;

@end

@implementation AppVersionUpdate

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.coverView = UIView.alloc.init;
        self.coverView.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.1];
        [self addSubview:self.coverView];
        [self.coverView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
        
        self.contentView = UIView.alloc.init;
        self.contentView.layer.cornerRadius = 5;
        self.contentView.backgroundColor = UIColor.whiteColor;
        [self addSubview:self.contentView];
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(50);
            make.right.mas_equalTo(-50);
            make.centerY.mas_equalTo(0);
            make.height.mas_lessThanOrEqualTo(self.mas_height).multipliedBy(0.8);
        }];
        
        self.updateIcon = UIImageView.alloc.init;
        self.updateIcon.image = [UIImage imageNamed:@"update-icon"];
        self.updateIcon.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:self.updateIcon];
        [self.updateIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(20);
            make.left.right.mas_equalTo(0);
        }];
        
        self.titleLabel = UILabel.alloc.init;
        self.titleLabel.font = [UIFont boldSystemFontOfSize:17];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(-20);
            make.top.mas_equalTo(self.updateIcon.mas_bottom).offset(30);
        }];
        
        //更新内容
        self.descripView = [UITextView.alloc initWithFrame:CGRectZero];
        self.descripView.font = [UIFont systemFontOfSize:15];
        self.descripView.textContainer.lineFragmentPadding = 0;
        self.descripView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
        self.descripView.editable = NO;
        self.descripView.selectable = NO;
        self.descripView.showsHorizontalScrollIndicator = NO;
        self.descripView.scrollEnabled = NO;
        [self.contentView addSubview:self.descripView];
        [self.descripView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(-20);
            make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(20);
            make.height.mas_greaterThanOrEqualTo(30);
        }];
        
        self.updateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.updateBtn.clipsToBounds = YES;
        self.updateBtn.layer.cornerRadius = 3;
        self.updateBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [self.updateBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.updateBtn setTitle:@"立即更新" forState:UIControlStateNormal];
        [self.updateBtn setBackgroundImage:KLImageHex(0x349CEF) forState:UIControlStateNormal];
        [self.contentView addSubview:self.updateBtn];
        [self.updateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.descripView.mas_bottom).offset(20);
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(-20);
            make.height.mas_equalTo(45);
            make.bottom.mas_equalTo(-20);
        }];
        
        self.updateCancle = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.updateCancle setImage:[UIImage imageNamed:@"update-cancle"] forState:UIControlStateNormal];
        [self addSubview:self.updateCancle];
        [self.updateCancle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.contentView.mas_top);
            make.centerX.mas_equalTo(self.contentView.mas_right);
            make.width.height.mas_equalTo(40);
        }];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.descripView.text.length > 0) {
        NSMutableParagraphStyle *paragraphStyle = NSMutableParagraphStyle.new;
        paragraphStyle.lineSpacing = 5;
        NSDictionary *attributes = @{ NSFontAttributeName:self.descripView.font,
                                      NSParagraphStyleAttributeName:paragraphStyle };
        self.descripView.attributedText = [[NSAttributedString alloc] initWithString:self.descripView.text attributes:attributes];
        
        CGSize size = [self.descripView.text boundingRectWithSize:CGSizeMake(self.descripView.bounds.size.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil].size;
        [self.descripView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_greaterThanOrEqualTo(size.height);
        }];
        self.descripView.scrollEnabled = self.descripView.showsVerticalScrollIndicator = self.contentView.bounds.size.height > self.bounds.size.height * 0.8;
    }
}

+ (void)updateWithVersion:(NSString *)version descriptions:(NSString *)descriptions toURL:(NSString *)url forced:(BOOL)forced {
    
    NSString *cacheVersion = [NSUserDefaults.standardUserDefaults valueForKey:self.description];
    if ([cacheVersion isEqualToString:version]) return;
    
    AppVersionUpdate *view = AppVersionUpdate.alloc.init;
    view.titleLabel.text = [NSString stringWithFormat:@"版本更新：V%@", version];
    view.descripView.text = descriptions;
    view.updateCancle.hidden = forced;
    [UIApplication.sharedApplication.keyWindow.rootViewController.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    [view startAnimation];
    @weakify(view)
    [view.updateCancle kl_controlEvents:UIControlEventTouchUpInside completion:^(UIButton * _Nonnull sender) {
        @strongify(view)
        [view stopAnimation];
        // 忽略本次更新
        [self ignoreThisUpdate:version];
    }];
    
    [view.updateBtn kl_controlEvents:UIControlEventTouchUpInside completion:^(UIButton * _Nonnull sender) {
        if (@available(iOS 10.0, *)) {
            [UIApplication.sharedApplication openURL:[NSURL URLWithString:url] options:@{UIApplicationOpenURLOptionUniversalLinksOnly: @NO} completionHandler:nil];
        } else {
            [UIApplication.sharedApplication openURL:[NSURL URLWithString:url]];
        }
    }];
}

// MARK: 忽略本次更新
+ (void)ignoreThisUpdate:(NSString *)version {
    [NSUserDefaults.standardUserDefaults setValue:version forKey:self.description];
    [NSUserDefaults.standardUserDefaults synchronize];
}

- (void)startAnimation {
    self.alpha = 0;
    self.transform = CGAffineTransformMakeScale(1.2, 1.2);
    [UIView animateWithDuration:0.75 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0.6 options:UIViewAnimationOptionCurveLinear animations:^{
        self.alpha = 1;
        self.transform = CGAffineTransformIdentity;
    } completion:nil];
}

- (void)stopAnimation {
    [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0.6 options:UIViewAnimationOptionCurveLinear animations:^{
        self.alpha = 0;
        self.transform = CGAffineTransformMakeScale(1.2, 1.2);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end

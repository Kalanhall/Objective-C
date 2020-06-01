//
//  TabBarController.m
//  Objective-C
//
//  Created by Logic on 2020/5/19.
//  Copyright © 2020 Kalan. All rights reserved.
//

#import "TabBarController.h"
@import KLApplicationEntry;
@import KLImageView;
@import KLCategory;

@interface TabBarController () <UITabBarControllerDelegate>

@end

@implementation TabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;

    // MARK: 中间Item点击回调
    __weak typeof(self) weakself = self;
    self.shouldSelectViewController = ^(NSInteger index) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"消息" message:@"点击中间按钮" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:nil];
        [alert addAction:sure];
        [weakself presentViewController:alert animated:YES completion:nil];
    };
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    
    NSInteger index = [tabBarController.viewControllers indexOfObject:viewController];
    if (index == 2) {
        if (self.shouldSelectViewController) {
            self.shouldSelectViewController(index);
        }
    }
    
    return index != 2;
}

- (void)setupCustomAreaView {
    // 添加自定义凸起区域
    KLImageView *center = KLImageView.alloc.init;
    center.contentMode = UIViewContentModeScaleAspectFit;
    center.tag = 2;
    [self addTabBarCustomAreaWithView:center atIndex:center.tag height:0];
    [self resetTabBarCustomArea:center extendEdgeInsets:(UIEdgeInsets){-17, 0, -17, 0}];
    // 图片事件回调
    @weakify(self)
    [center kl_setTapCompletion:^(UITapGestureRecognizer *tapGesture) {
        @strongify(self)
        if (self.shouldSelectViewController) {
            self.shouldSelectViewController(center.tag);
        }
    }];
    
    // MARK: 图片处理
    // 监听GIF动图最后一帧，并赋值给控件，否则主线程操作时，会将图片还原到第一帧
    [NSNotificationCenter.defaultCenter kl_observerObject:center forKeyPath:@"currentAnimatedImageIndex" completion:^(id  _Nonnull value) {
        if ([value integerValue] == [(KLImage *)center.image animatedImageFrameCount] - 1) {
            UIImage *image = [(KLImage *)center.image animatedImageFrameAtIndex:[value integerValue]];
            dispatch_async(dispatch_get_main_queue(), ^{
                center.image = image;
            });
        }
    }];
    
    // 加载图片
    [center kl_setImageWithURL:[NSURL URLWithString:@"https://gw.alicdn.com/tfs/TB1BYxNrUY1gK0jSZFMXXaWcVXa-220-220.png"]
                   placeholder:[UIImage imageNamed:@"tab2-n"]];
}

@end

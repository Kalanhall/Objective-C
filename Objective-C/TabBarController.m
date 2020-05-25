//
//  TabBarController.m
//  Objective-C
//
//  Created by Logic on 2020/5/19.
//  Copyright © 2020 Kalan. All rights reserved.
//

#import "TabBarController.h"
@import KLApplicationEntry;

@interface TabBarController () <UITabBarControllerDelegate>

@end

@implementation TabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
    
    __weak typeof(self) weakself = self;
    self.shouldSelectViewController = ^(NSInteger index) {
        // MARK: Center 模式
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"消息" message:@"点击中间按钮" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:nil];
        [alert addAction:sure];
        [weakself presentViewController:alert animated:YES completion:nil];
    };
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    
    // 系统Item凸起样式
    // Step1 设置图片位置
    [self setTabBarItemImageEdgeInsets:(UIEdgeInsets){-17,0,17,0} atIndex:2];
    // Step2 添加响应区域
    UIButton *center = [UIButton buttonWithType:UIButtonTypeCustom];
    center.tag = 2;
    [center addTarget:self action:@selector(centerTouchInsideCallBack:) forControlEvents:UIControlEventTouchUpInside];
    [self addTabBarCustomAreaWithView:center atIndex:2 height:0];
    [self resetTabBarCustomArea:center extendEdgeInsets:(UIEdgeInsets){-20, 0, 0, 0}];
}

- (void)centerTouchInsideCallBack:(UIButton *)sender {
    if (self.shouldSelectViewController) {
        self.shouldSelectViewController(sender.tag);
    }
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

@end

//
//  AppDelegate.m
//  Objective-C
//
//  Created by Logic on 2019/11/28.
//  Copyright © 2019 Kalan. All rights reserved.
//

@import KLApplicationEntry;
@import KLTarBarTransition;
@import YKWoodpecker;

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [UIWindow.alloc initWithFrame:UIScreen.mainScreen.bounds];
    
    // MARK: 选项卡入口配置
    NSArray *controllers =
    @[[KLNavigationController navigationWithRootViewController:ViewController.new title:@"商城" image:@"Tab0" selectedImage:@"Tab0-h"],
      [KLNavigationController navigationWithRootViewController:ViewController.new title:@"发现" image:@"Tab1" selectedImage:@"Tab1-h"],
      [KLNavigationController navigationWithRootViewController:ViewController.new title:@"购物" image:@"Tab2" selectedImage:@"Tab2-h"],
      [KLNavigationController navigationWithRootViewController:ViewController.new title:@"我的" image:@"Tab3" selectedImage:@"Tab3-h"]];
    UITabBarController *tc = [UITabBarController tabBarWithControllers:controllers];
    self.window.rootViewController = [tc setTabBarBackgroundColor:UIColor.whiteColor];
    [self.window makeKeyAndVisible];
    
    // MARK: 导航栏全局配置
    [KLNavigationController navigationGlobalTincolor:UIColor.blackColor];
    [KLNavigationController navigationGlobalBarTincolor:UIColor.blackColor];
    [KLNavigationController navigationGlobalBackIndicatorImage:[UIImage imageNamed:@"back"]];
    
    // MARK: 选项卡转场配置
    [self setupTabBarTransitionAnimation:tc];
    
    // MARK: 开发工具配置
    [self setupDebugTool:tc];
    
    return YES;
}

- (void)setupDebugTool:(UITabBarController *)tc {
    #ifdef DEBUG
    [tc setSwipeTabBarCallBack:^(UISwipeGestureRecognizer * _Nonnull swipe) {
        if (swipe.direction == UISwipeGestureRecognizerDirectionRight) {
            [YKWoodpeckerManager.sharedInstance show];
        } else {
            [YKWoodpeckerManager.sharedInstance hide];
        }
    }];
    [YKWoodpeckerManager.sharedInstance registerCrashHandler];
    #endif
}

- (void)setupTabBarTransitionAnimation:(UITabBarController *)tc {
    KLTabBarTransitionDelegate *delegate = KLTabBarTransitionDelegate.alloc.init;
    delegate.tabBarController = tc;
    tc.delegate = delegate;
}

@end

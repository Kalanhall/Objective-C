//
//  AppDelegate.m
//  Objective-C
//
//  Created by Logic on 2019/11/28.
//  Copyright © 2019 Kalan. All rights reserved.
//

@import YKWoodpecker;
@import KLApplicationEntry;
@import KLTarBarTransition;
@import KLHomeServiceInterface;

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [UIWindow.alloc initWithFrame:UIScreen.mainScreen.bounds];

    // MARK: 选项卡入口配置
    NSArray *controllers =
    @[[KLNavigationController navigationWithRootViewController:[KLServer.sharedServer fetchHomeController:nil]
                                                         title:@"商城" image:@"Tab0" selectedImage:@"Tab0-h"]];
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

- (void)setupTabBarTransitionAnimation:(UITabBarController *)tc {
    KLTabBarTransitionDelegate *delegate = KLTabBarTransitionDelegate.alloc.init;
    delegate.tabBarController = tc;
    tc.delegate = delegate;
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

@end

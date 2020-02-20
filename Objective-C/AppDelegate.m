//
//  AppDelegate.m
//  Objective-C
//
//  Created by Logic on 2019/11/28.
//  Copyright © 2019 Kalan. All rights reserved.
//

#import "AppDelegate.h"
@import KLConsole;
@import KLApplicationEntry;
@import KLHomeServiceInterface;

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [UIWindow.alloc initWithFrame:UIScreen.mainScreen.bounds];

    // MARK: 选项卡入口配置
    NSArray *controllers =
    @[[KLNavigationController navigationWithRootViewController:[KLServer.sharedServer fetchHomeController:nil]
                                                         title:@"商城" image:@"Tab0" selectedImage:@"Tab0-h"],
      [KLNavigationController navigationWithRootViewController:[KLServer.sharedServer fetchHomeController:nil]
                                                         title:@"分类" image:@"Tab1" selectedImage:@"Tab1-h"],
      [KLNavigationController navigationWithRootViewController:[KLServer.sharedServer fetchHomeController:nil]
                                                         title:@"购物车" image:@"Tab2" selectedImage:@"Tab2-h"],
      [KLNavigationController navigationWithRootViewController:[KLServer.sharedServer fetchHomeController:nil]
                                                         title:@"我的" image:@"Tab3" selectedImage:@"Tab3-h"]];
    UITabBarController *tc = [UITabBarController tabBarWithControllers:controllers];
    [tc setTabBarBackgroundColor:UIColor.whiteColor];
    [tc setTabBarShadowColor:UIColor.lightGrayColor opacity:0.3];
    self.window.rootViewController = tc;
    [self.window makeKeyAndVisible];
    
    // MARK: 导航栏全局配置
    [KLNavigationController navigationGlobalTincolor:UIColor.blackColor];
    [KLNavigationController navigationGlobalBarTincolor:UIColor.blackColor];
    [KLNavigationController navigationGlobalBackIndicatorImage:[UIImage imageNamed:@"back"]];
    
    // MARK: 开发工具配置
    [self setupDebugTool:tc];
    
    return YES;
}

- (void)setupDebugTool:(UITabBarController *)tc {
    // MARK: 环境初始化
    [KLConsole consoleAddressSetup:^(NSMutableArray<KLConsoleSecondConfig *> *configs) {
        KLConsoleSecondConfig *A = KLConsoleSecondConfig.alloc.init;
        A.version = @"1.0";
        A.title = @"商城服务域名";
        A.subtitle = @"https://www.example.com/prod";
        A.selectedIndex = 0;
        
        KLConsoleThreeConfig *Aa = KLConsoleThreeConfig.alloc.init;
        Aa.title = @"生产环境";
        Aa.text = @"https://www.example.com/prod";
        KLConsoleThreeConfig *Ab = KLConsoleThreeConfig.alloc.init;
        Ab.title = @"开发环境";
        Ab.text = @"https://www.example.com/dev";
        KLConsoleThreeConfig *Ac = KLConsoleThreeConfig.alloc.init;
        Ac.title = @"测试环境";
        Ac.text = @"https://www.example.com/test";
        KLConsoleThreeConfig *Ad = KLConsoleThreeConfig.alloc.init;
        Ad.title = @"预发布环境";
        Ad.text = @"https://www.example.com/stadge";
        A.details = @[Aa, Ab, Ac, Ad];
        [configs addObject:A];
        
        KLConsoleSecondConfig *B = KLConsoleSecondConfig.alloc.init;
        B.version = @"1.0";
        B.title = @"商城H5服务域名";
        B.subtitle = @"https://www.example.com/prod1";
        B.selectedIndex = 0;
        
        KLConsoleThreeConfig *Ba = KLConsoleThreeConfig.alloc.init;
        Ba.title = @"生产环境";
        Ba.text = @"https://www.example.com/prod1";
        KLConsoleThreeConfig *Bb = KLConsoleThreeConfig.alloc.init;
        Bb.title = @"开发环境";
        Bb.text = @"https://www.example.com/dev1";
        KLConsoleThreeConfig *Bc = KLConsoleThreeConfig.alloc.init;
        Bc.title = @"测试环境";
        Bc.text = @"https://www.example.com/test1";
        KLConsoleThreeConfig *Bd = KLConsoleThreeConfig.alloc.init;
        Bd.title = @"预发布环境";
        Bd.text = @"https://www.example.com/stadge1";
        B.details = @[Ba, Bb, Bc, Bd];
        [configs addObject:B];
    }];
    
    // MAKR: 扩展功能
    [KLConsole consoleSetup:^(NSMutableArray<KLConsoleConfig *> * _Nonnull configs) {
        KLConsoleConfig *A = KLConsoleConfig.alloc.init;
        A.title = @"功能测试";
        
        KLConsoleSecondConfig *Aa = KLConsoleSecondConfig.alloc.init;
        Aa.title = @"H5访问测试";
        Aa.subtitle = @"点击输入链接访问";
        
        KLConsoleSecondConfig *Ab = KLConsoleSecondConfig.alloc.init;
        Ab.title = @"引导页测试";
        Ab.subtitle = @"点击查看";
        A.infos = @[Aa, Ab];
        [configs addObject:A];
    }];
    
    // 控制台调用
    tc.swipeTabBarCallBack = ^(UISwipeGestureRecognizer * _Nonnull swipe) {
        #ifdef DEBUG
            [KLConsole consoleSetupAndSelectedCallBack:^(NSIndexPath * _Nonnull indexPath, BOOL switchOn) {
                // 扩展功能回调
                switch (indexPath.row) {
                    case 0:
                        NSLog(@"H5访问测试~");
                        break;
                    case 1:
                        NSLog(@"引导页测试~");
                        break;
                    default:
                        break;
                }
            }];
        #endif
    };
}

@end

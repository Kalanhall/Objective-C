//
//  AppDelegate.m
//  Objective-C
//
//  Created by Logic on 2019/11/28.
//  Copyright © 2019 Kalan. All rights reserved.
//

#import "AppDelegate.h"
#import "KLTabBarController.h"
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
                                                         title:@"闲鱼" image:@"tab0-n" selectedImage:@"tab0-s"],
      [KLNavigationController navigationWithRootViewController:[KLServer.sharedServer fetchHomeController:nil]
                                                         title:@"鱼塘" image:@"tab1-n" selectedImage:@"tab1-s"],
      [KLNavigationController navigationWithRootViewController:[KLServer.sharedServer fetchHomeController:nil]
                                                         title:@"发布" image:@"tab2-n" selectedImage:@"tab2-n"],
      [KLNavigationController navigationWithRootViewController:[KLServer.sharedServer fetchHomeController:nil]
                                                         title:@"消息" image:@"tab3-n" selectedImage:@"tab3-s"],
      [KLNavigationController navigationWithRootViewController:[KLServer.sharedServer fetchHomeController:nil]
                                                         title:@"我的" image:@"tab4-n" selectedImage:@"tab4-s"]];
    UITabBarController *tc = [KLTabBarController tabBarWithControllers:controllers];
    
    // MARK: - 导航栏全局设置
    [KLNavigationController setAppearanceTincolor:UIColor.blackColor];
    [KLNavigationController setAppearanceBarTincolor:UIColor.whiteColor];
    [KLNavigationController setAppearanceBackIndicatorImage:[UIImage imageNamed:@"back"]];
    
    // MARK: - 选项卡全局设置
    // 设置阴影线颜色，当只有设置了背景图后才生效
    [tc setTabBarShadowLineColor:UIColor.clearColor];
    // 设置背景图片
    [tc setTabBarBackgroundImageWithColor:UIColor.whiteColor];
    // 设置文字样式
    [tc setTabBarItemTitleTextAttributes:@{NSForegroundColorAttributeName : UIColor.blackColor,
                                           NSFontAttributeName : [UIFont systemFontOfSize:10]}
                                forState:UIControlStateNormal];
    [tc setTabBarItemTitleTextAttributes:@{NSForegroundColorAttributeName : UIColor.blackColor,
                                           NSFontAttributeName : [UIFont systemFontOfSize:10]}
                                forState:UIControlStateHighlighted];
    // 设置文字位置偏移量
    [tc setTabBarItemTitlePositionAdjustment:(UIOffset){0, -2} forState:UIControlStateNormal];
    [tc setTabBarItemTitlePositionAdjustment:(UIOffset){0, -2} forState:UIControlStateSelected];
    // 设置凸起图片高度
    [tc setTabBarItemImageEdgeInsets:(UIEdgeInsets){-17,0,17,0} atIndex:2];
    // 增加一个凸起点击区域
    [tc setTabBarRespondAreaAtIndex:2 height:0];
    
    // MARK: 开发工具配置
    [self setupDebugTool:tc];
    
    self.window.rootViewController = tc;
    [self.window makeKeyAndVisible];
    
    sleep(1);
    
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

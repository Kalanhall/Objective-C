//
//  AppDelegate.m
//  Objective-C
//
//  Created by Logic on 2019/11/28.
//  Copyright © 2019 Kalan. All rights reserved.
//

#import "AppDelegate.h"
#import "AppLaunchSetup.h"
#import "AppPushSetup.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // MARK: 控制器控制台记录开关
    KLViewControllerTraceLogEnable(NO);
    
    // MARK: 根控制器配置
    self.window = [UIWindow.alloc initWithFrame:UIScreen.mainScreen.bounds];
    [AppLaunchSetup setupRootViewControllerWithWindow:self.window];
    
    // MARK: 开发工具配置
    [AppLaunchSetup setupDebugTool];
    
    // MARK: 引导页配置
    if (KLIsFirstLaunch()) [AppLaunchSetup setupGuidePage];
    
    // MARK: 启动图配置
    [AppLaunchSetup setupLaunchImage];
    
    // MARK: 版本更新
    [AppLaunchSetup setupVersionUpdate];
    
    // MARK: 注册推送
    [AppPushSetup.shareInstance application:application didFinishLaunchingWithOptions:launchOptions];
    
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // 获取本地服务器地址
    [KLConsole.addressConfigs enumerateObjectsUsingBlock:^(KLConsoleSecondConfig * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLogSuccess(@"获取本地服务器域名：%@", obj.subtitle);
    }];
}

// MARK: - Push Setup
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [AppPushSetup.shareInstance application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    [AppPushSetup.shareInstance application:application didFailToRegisterForRemoteNotificationsWithError:error];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [AppPushSetup.shareInstance application:application didReceiveRemoteNotification:userInfo];
}

@end

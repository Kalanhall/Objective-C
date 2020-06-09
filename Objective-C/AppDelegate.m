//
//  AppDelegate.m
//  Objective-C
//
//  Created by Logic on 2019/11/28.
//  Copyright © 2019 Kalan. All rights reserved.
//

#import "AppDelegate.h"
#import "AppLaunchSetup.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // MARK: 控制台记录开关
    /*
    KLViewControllerTraceLogEnable(YES);
    KLNetworkConfigure.shareInstance.enableDebug = YES;
    */
    
    // MARK: 根控制器配置
    self.window = [UIWindow.alloc initWithFrame:UIScreen.mainScreen.bounds];
    [AppLaunchSetup setupRootViewControllerWithWindow:self.window];
    
    // MARK: 引导页配置
    if (KLFirstLaunch()) [AppLaunchSetup setupGuidePage];
    
    // MARK: 启动图配置
    [AppLaunchSetup setupLaunchImage];
    
    // MARK: 版本更新
    [AppLaunchSetup setupVersionUpdateToView:nil];
    
    // MARK: 开发工具配置
    [AppLaunchSetup setupDebugTool];
    
    // Edit Scheme -> DYLD_PRINT_STATISTICS, to see launch time.
    // Other C Flags -> '-fsanitize-coverage=func,trace-pc-guard'
    AppOrderFiles(nil);

    return YES;
}

@end

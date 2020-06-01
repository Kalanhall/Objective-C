//
//  AppDelegate.m
//  Objective-C
//
//  Created by Logic on 2019/11/28.
//  Copyright © 2019 Kalan. All rights reserved.
//

#import "AppDelegate.h"
#import "AppLaunch.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // MARK: 根控制器配置
    self.window = [UIWindow.alloc initWithFrame:UIScreen.mainScreen.bounds];
    [AppLaunch setupRootViewControllerWithWindow:self.window];
    
    // MARK: 开发工具配置
    [AppLaunch setupDebugTool];
    
    // MARK: 引导页配置
    if (KLIsFirstLaunch()) [AppLaunch setupGuidePage];
    
    // MARK: 启动图配置
    [AppLaunch setupLaunchImage];
    
    // MARK: 版本更新
    [AppLaunch setupVersionUpdate];
    
    return YES;
}

@end

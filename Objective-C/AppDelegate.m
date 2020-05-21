//
//  AppDelegate.m
//  Objective-C
//
//  Created by Logic on 2019/11/28.
//  Copyright © 2019 Kalan. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+Launch.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // MARK: 根控制器配置
    UIViewController *vc = [AppDelegate setupRootViewController];
    self.window = [UIWindow.alloc initWithFrame:UIScreen.mainScreen.bounds];
    self.window.rootViewController = vc;
    [self.window makeKeyAndVisible];
    
    // MARK: 开发工具配置
    [AppDelegate setupDebugTool];
    
    // MARK: 启动图配置
    [AppDelegate setupLaunchImage];
    
    return YES;
}

@end

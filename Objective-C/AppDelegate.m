//
//  AppDelegate.m
//  Objective-C
//
//  Created by Logic on 2019/11/28.
//  Copyright © 2019 Kalan. All rights reserved.
//

#import "AppDelegate.h"
#import "CommandManager.h"
#import "LaunchCommand.h"
@import AppOrderFiles;
@import KLCategory;
@import KLNetworkModule;

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
 
    // MARK: 根控制器配置
    [CommandManager executeCommand:LaunchCommand.new completion:nil];

    // MARK: 控制台记录开关
    UIViewController.trackLogEnable = YES;
    KLNetworkConfigure.shareInstance.enableDebug = YES;

    #ifdef DEBUG
    // Edit Scheme -> DYLD_PRINT_STATISTICS, to see launch time.
    // Other C Flags -> '-fsanitize-coverage=func,trace-pc-guard'
    AppOrderFiles(nil);
    #endif
    
    return YES;
}


@end

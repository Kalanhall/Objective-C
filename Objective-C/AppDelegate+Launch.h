//
//  AppDelegate+Launch.h
//  Objective-C
//
//  Created by Logic on 2020/5/21.
//  Copyright © 2020 Kalan. All rights reserved.
//

#import "AppDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface AppDelegate (Launch)

/**
 *  初始化控制器
 *  1、导航栏设置
 *  2、选项卡设置
 */
+ (void)setupRootViewControllerWithWindow:(UIWindow *)window;

/**
 *  初始化开发工具
 *  1、环境设置
 *  2、工具扩展类设置
 */
+ (void)setupDebugTool;

/// 启动开发工具
+ (void)launchDebugTool;

/// 启动图设置
+ (void)setupLaunchImage;

/// 更新设置
+ (void)setupVersionUpdate;

@end

NS_ASSUME_NONNULL_END

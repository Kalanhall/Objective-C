//
//  AppLaunch.h
//  Objective-C
//
//  Created by Logic on 2020/6/1.
//  Copyright © 2020 Kalan. All rights reserved.
//

#import <UIKit/UIKit.h>
@import KLApplicationEntry;
@import KLGuidePage;
@import KLConsole;
@import KLCategory;
@import KLImageView;
@import KLNetworkModule;
@import KLHomeServiceInterface;

NS_ASSUME_NONNULL_BEGIN

@interface AppLaunchSetup : NSObject

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

/// 启动图设置
+ (void)setupLaunchImage;

/// 引导页设置
+ (void)setupGuidePage;

/// 更新设置
+ (void)setupVersionUpdate;

@end

NS_ASSUME_NONNULL_END

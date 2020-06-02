//
//  AppPushSetup.m
//  Objective-C
//
//  Created by Kalan on 2020/6/2.
//  Copyright © 2020 Kalan. All rights reserved.
//

#import "AppPushSetup.h"

@implementation AppPushSetup

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    static AppPushSetup *instance;
    dispatch_once(&onceToken, ^{
        instance = AppPushSetup.alloc.init;
    });
    return instance;
}

// MARK: - 应用启动回调
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    return YES;
}

// MARK: - 推送注册回调
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    
}

// MARK: - iOS 10 以下接收远程推送
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
}

// MARK: - iOS 10 以上接收远程推送
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler __IOS_AVAILABLE(10.0) {
    
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)(void))completionHandler __IOS_AVAILABLE(10.0) {
    
}

@end

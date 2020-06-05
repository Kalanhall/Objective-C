//
//  UIResponder+AppDelegate.m
//  Objective-C
//
//  Created by Logic on 2020/6/5.
//  Copyright © 2020 Kalan. All rights reserved.
//

#import "UIResponder+AppDelegate.h"
#import <objc/runtime.h>
#import <UserNotifications/UserNotifications.h>

@implementation UIResponder (AppDelegate)

// MARK: - 监听应用代理所有方法
+ (void)load {
    // 获取应用代理，前提需要应用代理继承与本类
    Class target = self.soc_subClass.firstObject;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method oldm = class_getInstanceMethod(target, @selector(application:didFinishLaunchingWithOptions:));
        Method newm = class_getInstanceMethod(self, @selector(soc_application:didFinishLaunchingWithOptions:));
        method_exchangeImplementations(oldm, newm);
        
        oldm = class_getInstanceMethod(target, @selector(application:didRegisterForRemoteNotificationsWithDeviceToken:));
        newm = class_getInstanceMethod(self, @selector(soc_application:didRegisterForRemoteNotificationsWithDeviceToken:));
        method_exchangeImplementations(oldm, newm);
        
        oldm = class_getInstanceMethod(target, @selector(application:didReceiveRemoteNotification:fetchCompletionHandler:));
        newm = class_getInstanceMethod(self, @selector(soc_application:didReceiveRemoteNotification:fetchCompletionHandler:));
        method_exchangeImplementations(oldm, newm);
    });
}

- (BOOL)soc_application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self soc_application:application didFinishLaunchingWithOptions:launchOptions];
    NSLog(@"2 %@", NSStringFromSelector(_cmd));

    
    return YES;
}

- (void)soc_application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [self soc_application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];

    if (![deviceToken isKindOfClass:[NSData class]]) return;
    const unsigned *tokenBytes = (const unsigned *)[deviceToken bytes];
    NSString *hexToken = [NSString stringWithFormat:@"%08x%08x%08x%08x%08x%08x%08x%08x",
                          ntohl(tokenBytes[0]), ntohl(tokenBytes[1]), ntohl(tokenBytes[2]),
                          ntohl(tokenBytes[3]), ntohl(tokenBytes[4]), ntohl(tokenBytes[5]),
                          ntohl(tokenBytes[6]), ntohl(tokenBytes[7])];
    NSLog(@"deviceToken: ## %@ ##",hexToken);
}

- (void)soc_application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(nonnull void (^)(UIBackgroundFetchResult))completionHandler {
    [self soc_application:application didReceiveRemoteNotification:userInfo fetchCompletionHandler:completionHandler];

}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler __API_AVAILABLE(macos(10.14), ios(10.0), watchos(3.0), tvos(10.0)) {
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {

        // 应用处于前台时的远程推送接受
    }
    completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler __API_AVAILABLE(macos(10.14), ios(10.0), watchos(3.0), tvos(10.0)) {
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        // 应用处于后台时的远程推送接受
    }
    completionHandler();
}

// MARK: - 获取本类所有子类
+ (NSArray *)soc_subClass {
    int count = objc_getClassList(NULL, 0);
    NSMutableArray * array = NSMutableArray.array;
    Class *classes = (Class *)malloc(sizeof(Class) * count);
    objc_getClassList(classes, count);
    for (int i = 0; i < count; i++) {
        Class cls = classes[i];
        if (UIResponder.class == class_getSuperclass(cls) && [cls conformsToProtocol:@protocol(UIApplicationDelegate)]) {
            [array addObject:cls];
        }
    }
    free(classes);
    return array;
}


@end

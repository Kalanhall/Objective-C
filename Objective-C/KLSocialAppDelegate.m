//
//  KLSocialAppDelegate.m
//  KLSocialKit_Example
//
//  Created by Logic on 2020/6/3.
//  Copyright © 2020 Kalanhall@163.com. All rights reserved.
//

#import "KLSocialAppDelegate.h"
#import <objc/runtime.h>
#import <UMCommon/UMCommon.h>
#import <UMPush/UMessage.h>

@interface KLSocialAppDelegate () <UNUserNotificationCenterDelegate>

@end

@implementation KLSocialAppDelegate

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

    // 友盟Key初始化
    [UMConfigure initWithAppkey:@"5ed7562fdbc2ec0818c75998" channel:@"App Store"];
    [UMConfigure setLogEnabled:YES];
    
    // Push组件基本功能配置
    UMessageRegisterEntity *entity = UMessageRegisterEntity.alloc.init;
    entity.types = UMessageAuthorizationOptionBadge|UMessageAuthorizationOptionSound|UMessageAuthorizationOptionAlert;

    // 如果要在iOS10显示交互式的通知，必须注意实现以下代码
    if (@available(iOS 10.0, *)) {
        UNUserNotificationCenter.currentNotificationCenter.delegate = self;
        UNNotificationAction *action1 = [UNNotificationAction actionWithIdentifier:@"action1" title:@"打开" options:UNNotificationActionOptionForeground];
        UNNotificationAction *action2 = [UNNotificationAction actionWithIdentifier:@"action2" title:@"忽略" options:UNNotificationActionOptionForeground];
        UNNotificationCategory *category = [UNNotificationCategory categoryWithIdentifier:@"myNotificationCategory" actions:@[action1,action2] intentIdentifiers:@[] options:UNNotificationCategoryOptionCustomDismissAction];
        NSSet *categories = [NSSet setWithObjects:category, nil];
        entity.categories = categories;
    } else {
        UIMutableUserNotificationAction *action1 = UIMutableUserNotificationAction.new;
        action1.identifier = @"action1";
        action1.title = @"打开";
        action1.activationMode = UIUserNotificationActivationModeForeground; // 当点击的时候启动程序
        UIMutableUserNotificationAction *action2 = UIMutableUserNotificationAction.new;
        action2.identifier = @"action2";
        action2.title = @"忽略";
        action2.activationMode = UIUserNotificationActivationModeBackground; // 当点击的时候不启动程序，在后台处理
        action2.authenticationRequired = YES; // 需要解锁才能处理，如果action.activationMode = UIUserNotificationActivationModeForeground;则这个属性被忽略；
        action2.destructive = YES;
        UIMutableUserNotificationCategory *category = UIMutableUserNotificationCategory.new;
        category.identifier = @"myNotificationCategory"; // 这组动作的唯一标示
        [category setActions:@[action1,action2] forContext:UIUserNotificationActionContextDefault];
        NSSet *categories = [NSSet setWithObjects:category, nil];
        entity.categories = categories;
    }
    
    [UMessage registerForRemoteNotificationsWithLaunchOptions:launchOptions Entity:entity completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            NSLog(@"注册成功");
        } else {
            NSLog(@"注册失败");
        }
    }];
    
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
    NSLog(@"执行顺序 2 %@", NSStringFromSelector(_cmd));
    
    // 接收远程推送
    if(UIDevice.currentDevice.systemVersion.floatValue < 10.0) {
        [UMessage setAutoAlert:NO];
        // 应用处于前台时的远程推送接受
        [UMessage didReceiveRemoteNotification:userInfo];
    }
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler __API_AVAILABLE(macos(10.14), ios(10.0), watchos(3.0), tvos(10.0)) {
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [UMessage setAutoAlert:NO];
        // 应用处于前台时的远程推送接受
        [UMessage didReceiveRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler __API_AVAILABLE(macos(10.14), ios(10.0), watchos(3.0), tvos(10.0)) {
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        // 应用处于后台时的远程推送接受
        [UMessage didReceiveRemoteNotification:userInfo];
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
        if (self == class_getSuperclass(classes[i])) {
            [array addObject:classes[i]];
        }
    }
    free(classes);
    return array;
}

@end

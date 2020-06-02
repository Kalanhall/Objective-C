//
//  AppPushSetup.h
//  Objective-C
//
//  Created by Kalan on 2020/6/2.
//  Copyright © 2020 Kalan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>

NS_ASSUME_NONNULL_BEGIN

@interface AppPushSetup : NSObject <UIApplicationDelegate, UNUserNotificationCenterDelegate>

+ (instancetype)shareInstance;

@end

NS_ASSUME_NONNULL_END

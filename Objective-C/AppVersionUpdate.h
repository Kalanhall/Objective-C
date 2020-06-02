//
//  AppUpdate.h
//  Objective-C
//
//  Created by Logic on 2020/6/2.
//  Copyright © 2020 Kalan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AppVersionUpdate : UIView

+ (void)updateWithVersion:(NSString *)version descriptions:(NSString *)descriptions toURL:(NSString *)url forced:(BOOL)forced;

@end

NS_ASSUME_NONNULL_END

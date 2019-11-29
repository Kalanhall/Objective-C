//
//  KLUserInfo.m
//  KLUserInfoManager_Example
//
//  Created by Logic on 2019/11/29.
//  Copyright © 2019 Kalanhall@163.com. All rights reserved.
//

#import "KLUserInfo.h"
@import KLModel;

@implementation KLUserInfo

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [self kl_modelEncodeWithCoder:aCoder];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    return [self kl_modelInitWithCoder:aDecoder];
}

@end

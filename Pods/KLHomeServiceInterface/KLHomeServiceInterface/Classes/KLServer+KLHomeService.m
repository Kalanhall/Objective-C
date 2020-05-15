//
//  KLServer+KLHomeService.m
//  KLServer
//
//  Created by Logic on 2019/11/29.
//

#import "KLServer+KLHomeService.h"

NSString * const Service = @"KLHomeService";

@implementation KLServer (KLHomeService)

- (UIViewController *)fetchHomeController:(NSDictionary *)parameters {
    UIViewController *vc = [self performService:Service
                                           task:@"nativeToFetchHomeController"
                                         params:parameters
                             shouldCacheService:NO];
    return vc;
}

@end

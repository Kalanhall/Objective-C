//
//  KLHomeService.m
//  KLHomeService
//
//  Created by Logic on 2019/11/29.
//

#import "KLHomeService.h"
#import "KLHomeController.h"

@implementation KLHomeService

- (UIViewController *)nativeToFetchHomeController:(NSDictionary *)parameters
{
    KLHomeController *vc = KLHomeController.alloc.init;
    return vc;
}

@end

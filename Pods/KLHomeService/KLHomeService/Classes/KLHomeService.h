//
//  KLHomeService.h
//  KLHomeService
//
//  Created by Logic on 2019/11/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KLHomeService : NSObject

- (UIViewController *)nativeToFetchHomeController:(nullable NSDictionary *)parameters;

@end

NS_ASSUME_NONNULL_END

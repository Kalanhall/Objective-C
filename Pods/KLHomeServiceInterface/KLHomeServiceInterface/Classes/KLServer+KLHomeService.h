//
//  KLServer+KLHomeService.h
//  KLServer
//
//  Created by Logic on 2019/11/29.
//

#import <KLServer/KLServer.h>

NS_ASSUME_NONNULL_BEGIN

@interface KLServer (KLHomeService)

- (UIViewController *)fetchHomeController:(nullable NSDictionary *)parameters;

@end

NS_ASSUME_NONNULL_END

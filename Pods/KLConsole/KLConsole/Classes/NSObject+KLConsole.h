//
//  NSObject+KLConsole.h
//  KLConsole
//
//  Created by Logic on 2020/1/10.
//

#import <Foundation/Foundation.h>

#define KLImplementationCoding \
- (void)encodeWithCoder:(NSCoder *)aCoder\
{\
    [self kl_encode:aCoder];\
}\
\
- (instancetype)initWithCoder:(NSCoder *)aDecoder\
{\
    if (self = [super init]) {\
        [self kl_decode:aDecoder];\
    }\
    return self; \
}

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (KLConsole)

-(void)kl_encode:(NSCoder *)aCoder;
-(void)kl_decode:(NSCoder *)aDecoder;

@end

NS_ASSUME_NONNULL_END

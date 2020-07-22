//
//  Command.h
//  Objective-C
//
//  Created by Kalan on 2020/7/22.
//  Copyright © 2020 Kalan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class Command;
typedef void(^CommandCompletionCallBack)(Command* cmd);

@interface Command : NSObject

@property (nonatomic, copy) _Nullable CommandCompletionCallBack completion;

/// 执行
- (void)execute;
/// 取消
- (void)cancel;
/// 完成
- (void)done;

@end

NS_ASSUME_NONNULL_END

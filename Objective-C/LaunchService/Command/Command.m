//
//  Command.m
//  Objective-C
//
//  Created by Kalan on 2020/7/22.
//  Copyright © 2020 Kalan. All rights reserved.
//

#import "Command.h"
#import "CommandManager.h"

@implementation Command

- (void)execute {
    [self done];
}

- (void)cancel {
    self.completion = nil;
}

- (void)done {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.completion) {
            self.completion(self);
        }
        // 释放
        self.completion = nil;
        [CommandManager.sharedInstance.arrayCommands removeObject:self];
    });
}

@end

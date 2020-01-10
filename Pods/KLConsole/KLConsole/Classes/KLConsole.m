//
//  KLConsole.m
//  KLConsole
//
//  Created by Logic on 2020/1/6.
//

#import "KLConsole.h"
#import "KLConsoleController.h"
#import <objc/runtime.h>
@import YKWoodpecker;

@implementation KLConsole

+ (void)consoleSetup:(void (^)(NSMutableArray<KLConsoleConfig *> *configs))setup
{
    NSArray<KLConsoleConfig *> *cachecgs = [KLConsoleConfig unarchiveObjectWithFilePath:KLConsolePath];
    __block NSMutableArray<KLConsoleConfig *> *cgs = NSMutableArray.array;
    setup(cgs);
    if (cachecgs) {
        if (cachecgs.count != cgs.count) {
            [KLConsoleConfig archiveRootObject:cgs toFilePath:KLConsolePath];
        } else {
            [cachecgs enumerateObjectsUsingBlock:^(KLConsoleConfig * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                // 一级列表检查
                if (![obj.title isEqualToString:cgs[idx].title]) {
                    [KLConsoleConfig archiveRootObject:cgs toFilePath:KLConsolePath];
                    *stop = YES;
                }
                // 二级列表检查
                else {
                    if (obj.infos.count != cgs[idx].infos.count) {
                        [KLConsoleConfig archiveRootObject:cgs toFilePath:KLConsolePath];
                        *stop = YES;
                    } else {
                        [obj.infos enumerateObjectsUsingBlock:^(KLConsoleSecondConfig * _Nonnull obj2, NSUInteger idx2, BOOL * _Nonnull stop) {
                            if (![obj2.title isEqualToString:cgs[idx].infos[idx2].title]
                                || ![obj2.subtitle isEqualToString:cgs[idx].infos[idx2].subtitle]
                                || obj2.switchEnable !=  cgs[idx].infos[idx2].switchEnable) {
                                [KLConsoleConfig archiveRootObject:cgs toFilePath:KLConsolePath];
                                *stop = YES;
                            }
                        }];
                    }
                }
            }];
        }
    } else {
        [KLConsoleConfig archiveRootObject:cgs toFilePath:KLConsolePath];
    }
    
    // 数据挂载在系统单例，留待使用
    objc_setAssociatedObject(NSNotificationCenter.defaultCenter, @selector(consoleSetup:), cgs, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

+ (NSArray<KLConsoleConfig *> *)configs
{
    NSArray<KLConsoleConfig *> *cachecgs = [KLConsoleConfig unarchiveObjectWithFilePath:KLConsolePath];
    return cachecgs;
}

+ (void)consoleAddressSetup:(void (^)(NSMutableArray<KLConsoleSecondConfig *> *configs))setup
{
    NSArray<KLConsoleSecondConfig *> *cachecgs = [KLConsoleConfig unarchiveObjectWithFilePath:KLConsoleAddressPath];
    __block NSMutableArray<KLConsoleSecondConfig *> *cgs = NSMutableArray.array;
    setup(cgs);
    if (cachecgs) {
        if (cachecgs.count != cgs.count) {
            [KLConsoleConfig archiveRootObject:cgs toFilePath:KLConsoleAddressPath];
        } else {
            [cachecgs enumerateObjectsUsingBlock:^(KLConsoleSecondConfig * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (![obj.version isEqualToString:cgs[idx].version]) {
                    [KLConsoleConfig archiveRootObject:cgs toFilePath:KLConsoleAddressPath];
                    *stop = YES;
                }
            }];
        }
    } else {
        [KLConsoleConfig archiveRootObject:cgs toFilePath:KLConsoleAddressPath];
    }
    
    // 数据挂载在系统单例，留待使用
    objc_setAssociatedObject(NSNotificationCenter.defaultCenter, @selector(consoleAddressSetup:), cgs, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

+ (NSArray<KLConsoleSecondConfig *> *)addressConfigs
{
    NSArray<KLConsoleSecondConfig *> *cachecgs = [KLConsoleConfig unarchiveObjectWithFilePath:KLConsoleAddressPath];
    return cachecgs;
}

+ (void)consoleSetupAndSelectedCallBack:(void (^)(NSIndexPath *indexPath, BOOL switchOn))callBack
{
    KLConsoleController *vc = KLConsoleController.alloc.init;
    // 关联属性
    objc_setAssociatedObject(vc, @selector(consoleSetupAndSelectedCallBack:), callBack, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    UINavigationController *nav = [UINavigationController.alloc initWithRootViewController:vc];
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    [UIApplication.sharedApplication.keyWindow.rootViewController presentViewController:nav animated:YES completion:nil];
}

@end

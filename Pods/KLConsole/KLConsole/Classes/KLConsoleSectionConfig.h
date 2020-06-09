//
//  KLConsoleRowConfig.h
//  KLCategory
//
//  Created by Kalan on 2020/1/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// 三级级扩展数据模型
@interface KLConsoleInfoConfig : NSObject <NSCoding>

/// 域名中文注释
@property (copy, nonatomic) NSString *title;
/// 域名地址
@property (copy, nonatomic) NSString *text;

@end

// 二级扩展数据模型
@interface KLConsoleRowConfig : NSObject <NSCoding>

/// 环境版本
@property (copy, nonatomic) NSString *version;
/// 域名中文注释
@property (copy, nonatomic) NSString *title;
/// 环境当前选中
@property (copy, nonatomic) NSString *subtitle;
/// 环境集合
@property (copy, nonatomic) NSArray<KLConsoleInfoConfig *> *details;
/// 环境当前选中下标
@property (assign, nonatomic) NSInteger selectedIndex;
/// 显示开关
@property (assign, nonatomic) BOOL switchEnable;
/// 开关状态
@property (assign, nonatomic) BOOL switchOn;

@end

// 一级扩展数据模型
@interface KLConsoleSectionConfig : NSObject <NSCoding>

/// section标题
@property (copy, nonatomic) NSString *title;
/// row数组
@property (copy, nonatomic) NSArray<KLConsoleRowConfig *> *infos;

/// 归档
+ (BOOL)archiveRootObject:(id<NSCoding>)object toFilePath:(NSString *)filePath;

/// 解档
+ (id)unarchiveObjectWithFilePath:(NSString *)filePath;

@end

NS_ASSUME_NONNULL_END

//
//  NSString+KLExtension.h
//  KLCategory
//
//  Created by Logic on 2019/12/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (KLExtension)

/// 对字符串进行正则验证
- (BOOL)kl_evaluateWithRegular:(NSString *)regular;
/// 字符串反转
- (instancetype)kl_reverseString;
/// 汉字转拼音
- (instancetype)kl_chinessToPinyin;
/// 是否包含中文
- (BOOL)kl_isContainChinese;

/// 沙盒 - Document
+ (instancetype)kl_documentPathWithFileName:(NSString *)fileName;
/// 沙盒 - Cache
+ (instancetype)kl_cachePathWithFileName:(NSString *)fileName;
/// 沙盒 - Temp
+ (instancetype)kl_temptPathWithFileName:(NSString *)fileName;

/// 特殊字符过虑
- (NSString *)kl_stringWithURLEncoding;
/// 特殊字符过虑
- (NSString *)kl_stringWithURLEncodingPath;

// MARK: - 字符串格式化
/// 返回2位有效小数
- (CGFloat)kl_decimalValue;
/// 返回2位有效小数字符串
- (NSString *)kl_decimalString;
/// 返回2位有效小数字符串
+ (NSString *)kl_decimalStringWithValue:(CGFloat)value;
/// 返回2位带格式的有效小数字符串，例：123,456,789.00
- (NSString *)kl_decimalStyleString;
/// 返回2位带格式的有效小数字符串，例：123,456,789.00
+ (NSString *)kl_decimalStyleStringWithValue:(CGFloat)value;
/// 字符串转NSNumber
- (NSNumber *)kl_numberValue;

@end

NS_ASSUME_NONNULL_END

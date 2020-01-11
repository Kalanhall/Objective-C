//
//  KLConsoleSecondConfig.m
//  KLCategory
//
//  Created by Kalan on 2020/1/9.
//

#import "KLConsoleConfig.h"
#import "NSObject+KLConsole.h"

@implementation KLConsoleThreeConfig

KLImplementationCoding

@end

@implementation KLConsoleSecondConfig

KLImplementationCoding

@end

@implementation KLConsoleConfig

KLImplementationCoding

+ (BOOL)archiveRootObject:(id<NSCoding>)object toFilePath:(NSString *)filePath
{
    return [NSKeyedArchiver archiveRootObject:object toFile:filePath];
}

+ (id)unarchiveObjectWithFilePath:(NSString *)filePath
{
    return [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
}

@end

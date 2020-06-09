//
//  KLConsoleRowConfig.m
//  KLCategory
//
//  Created by Kalan on 2020/1/9.
//

#import "KLConsoleSectionConfig.h"
#import "NSObject+KLConsole.h"

@implementation KLConsoleInfoConfig

KLImplementationCoding

@end

@implementation KLConsoleRowConfig

KLImplementationCoding

@end

@implementation KLConsoleSectionConfig

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

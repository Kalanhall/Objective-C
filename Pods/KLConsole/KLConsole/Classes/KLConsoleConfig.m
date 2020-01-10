//
//  KLConsoleSecondConfig.m
//  KLCategory
//
//  Created by Kalan on 2020/1/9.
//

#import "KLConsoleConfig.h"

@implementation KLConsoleThreeConfig

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_title forKey:@"title"];
    [aCoder encodeObject:_text forKey:@"text"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        _title = [aDecoder decodeObjectForKey:@"title"];
        _text = [aDecoder decodeObjectForKey:@"text"];
    }
    return self;
}

@end

@implementation KLConsoleSecondConfig

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_version forKey:@"version"];
    [aCoder encodeObject:_title forKey:@"title"];
    [aCoder encodeObject:_subtitle forKey:@"subtitle"];
    [aCoder encodeObject:_details forKey:@"details"];
    [aCoder encodeObject:@(_selectedIndex) forKey:@"selectedIndex"];
    [aCoder encodeObject:@(_switchEnable) forKey:@"switchEnable"];
    [aCoder encodeObject:@(_switchOn) forKey:@"switchOn"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        _version = [aDecoder decodeObjectForKey:@"version"];
        _title = [aDecoder decodeObjectForKey:@"title"];
        _subtitle = [aDecoder decodeObjectForKey:@"subtitle"];
        _details = [aDecoder decodeObjectForKey:@"details"];
        _selectedIndex = [[aDecoder decodeObjectForKey:@"selectedIndex"] integerValue];
        _switchEnable = [[aDecoder decodeObjectForKey:@"switchEnable"] boolValue];
        _switchOn = [[aDecoder decodeObjectForKey:@"switchOn"] boolValue];
    }
    return self;
}

@end

@implementation KLConsoleConfig

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_title forKey:@"title"];
    [aCoder encodeObject:_infos forKey:@"infos"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        _title = [aDecoder decodeObjectForKey:@"title"];
        _infos = [aDecoder decodeObjectForKey:@"infos"];
    }
    return self;
}

+ (BOOL)archiveRootObject:(id<NSCoding>)object toFilePath:(NSString *)filePath
{
    return [NSKeyedArchiver archiveRootObject:object toFile:filePath];
}

+ (id)unarchiveObjectWithFilePath:(NSString *)filePath
{
    return [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
}

@end

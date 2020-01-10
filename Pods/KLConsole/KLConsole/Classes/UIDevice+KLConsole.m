//
//  UIDevice+KLConsole.m
//  KLCategory
//
//  Created by Logic on 2020/1/9.
//

#import "UIDevice+KLConsole.h"
#import <Security/Security.h>
#include <sys/sysctl.h>
#import <net/if.h>
#import <net/if_dl.h>
#include <spawn.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import <sys/utsname.h>
#import <ifaddrs.h>
#import <arpa/inet.h>
#import <sys/sysctl.h>

#define IOS_AWDL        @"awdl0"
#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0"
#define IOS_LOC         @"lo0"
#define IOS_VPN         @"utun0"
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"

static NSString* const service = @"KLVirtualDeviceIdentifierKeychainService";
static NSString* const account = @"KLVirtualDeviceIdentifier";

@implementation UIDevice (KLSystemInfo)

+ (NSString *)kl_deviceIdentifierForKeyChain
{
    //该类方法没有线程保护，所以可能因异步而导致创建出不同的设备唯一ID，故而增加此线程锁！
    @synchronized (self)
    {
        // 获取iOS系统推荐的设备唯一ID
        NSString* recommendDeviceIdentifier = UIDevice.currentDevice.identifierForVendor.UUIDString;
        recommendDeviceIdentifier = [recommendDeviceIdentifier stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSMutableDictionary* queryDic = [NSMutableDictionary dictionary];
        [queryDic setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
        [queryDic setObject:service forKey:(__bridge id)kSecAttrService];
        [queryDic setObject:(__bridge id)kCFBooleanFalse forKey:(__bridge id)kSecAttrSynchronizable];
        [queryDic setObject:account forKey:(__bridge id)kSecAttrAccount];
        // 默认值为kSecMatchLimitOne，表示返回结果集的第一个
        [queryDic setObject:(__bridge id)kSecMatchLimitOne forKey:(__bridge id)kSecMatchLimit];
        [queryDic setObject:(__bridge id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];
        CFTypeRef keychainPassword = NULL;
        // 首先查询钥匙串是否存在对应的值，如果存在则直接返回钥匙串中的值
        OSStatus queryResult = SecItemCopyMatching((__bridge CFDictionaryRef)queryDic, &keychainPassword);
        if (queryResult == errSecSuccess) {
            NSString *pwd = [[NSString alloc] initWithData:(__bridge NSData * _Nonnull)(keychainPassword) encoding:NSUTF8StringEncoding];
            if ([pwd isKindOfClass:[NSString class]] && pwd.length > 0) {
                return pwd;
            } else {
                // 如果钥匙串中的相关数据不合法，则删除对应的数据重新创建
                NSMutableDictionary* deleteDic = [NSMutableDictionary dictionary];
                [deleteDic setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
                [deleteDic setObject:service forKey:(__bridge id)kSecAttrService];
                [deleteDic setObject:(__bridge id)kCFBooleanFalse forKey:(__bridge id)kSecAttrSynchronizable];
                [deleteDic setObject:account forKey:(__bridge id)kSecAttrAccount];
                OSStatus status = SecItemDelete((__bridge CFDictionaryRef)deleteDic);
                if (status != errSecSuccess) {
                    return recommendDeviceIdentifier;
                }
            }
        }
        if (recommendDeviceIdentifier.length > 0) {
            // 创建数据到钥匙串，达到APP即使被删除也不会变更的设备唯一ID，除非系统抹除数据，否则该数据将存储在钥匙串中
            NSMutableDictionary* createDic = [NSMutableDictionary dictionary];
            [createDic setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
            [createDic setObject:service forKey:(__bridge id)kSecAttrService];
            [createDic setObject:account forKey:(__bridge id)kSecAttrAccount];
            // 不可以使用iCloud同步钥匙串数据，否则导致同一个iCloud账户的多个设备获取的唯一ID相同
            [createDic setObject:(__bridge id)kCFBooleanFalse forKey:(__bridge id)kSecAttrSynchronizable];
            // 增加一道保险，防止钥匙串数据被同步到其他设备，保证设备ID绝对唯一。
            [createDic setObject:(__bridge id)kSecAttrAccessibleAlwaysThisDeviceOnly forKey:(__bridge id)kSecAttrAccessible];
            [createDic setObject:[recommendDeviceIdentifier dataUsingEncoding:NSUTF8StringEncoding] forKey:(__bridge id)kSecValueData];
            OSStatus createResult = SecItemAdd((__bridge CFDictionaryRef)createDic, nil);
            if (createResult != errSecSuccess) {
                NSLog(@"通过钥匙串创建设备唯一ID不成功！");
            }
        }
        return recommendDeviceIdentifier;
    }
}

+ (BOOL)kl_deleteDeviceIdentifierForKeyChain
{
    NSMutableDictionary* queryDic = [NSMutableDictionary dictionary];
    [queryDic setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
    [queryDic setObject:service forKey:(__bridge id)kSecAttrService];
    [queryDic setObject:(__bridge id)kCFBooleanFalse forKey:(__bridge id)kSecAttrSynchronizable];
    [queryDic setObject:account forKey:(__bridge id)kSecAttrAccount];
    CFTypeRef keychainPassword = NULL;
    OSStatus queryResult = SecItemCopyMatching((__bridge CFDictionaryRef)queryDic, &keychainPassword);
    if (queryResult == errSecSuccess) {
        OSStatus status = SecItemDelete((__bridge CFDictionaryRef)queryDic);
        return status == errSecSuccess;
    }
    return NO;
}


+ (NSString *)kl_systemVersion
{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
    return [UIDevice currentDevice].systemVersion;

#else
    return nil;
#endif
}

+ (NSString *)kl_OSVersion
{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
    return [NSString stringWithFormat:@"%@ %@", [UIDevice currentDevice].systemName, [UIDevice currentDevice].systemVersion];

#else
    return nil;
#endif
}

+ (NSString *)kl_OSLanguage
{
    NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
    NSArray *languages = [defs objectForKey:@"AppleLanguages"];
    NSString *preferredLang = [languages objectAtIndex:0];

    return preferredLang;
}

+ (NSString *)kl_appDisplayName
{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR || TARGET_OS_MAC)
    static NSString *__appName = nil;

    if (nil == __appName) {
        __appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"];
    }

    return __appName;

#else
    return nil;
#endif
}

+ (NSString *)kl_appBuildVersion
{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR || TARGET_OS_MAC)
    NSString *value = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];

    if ((nil == value) || (0 == value.length)) {
        value = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    }

    return value;

#else
    return nil;
#endif
}

+ (NSString *)kl_appShortVersion
{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR || TARGET_OS_MAC)
    NSString *value = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];

    if ((nil == value) || (0 == value.length)) {
        value = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    }

    return value;

#else
    return nil;
#endif
}

+ (NSString *)kl_appIdentifier
{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
    static NSString *__identifier = nil;

    if (nil == __identifier) {
        __identifier = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
    }

    return __identifier;

#else
    return @"";
#endif
}

+ (NSString *)kl_deviceModel
{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
    return [UIDevice currentDevice].model;

#else
    return nil;
#endif
}

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
static const char *__jb_app = NULL;
#endif

+ (BOOL)kl_isJailBroken NS_AVAILABLE_IOS(4_0)
{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
    static const char *__jb_apps[] = {
        "/Application/Cydia.app",
        "/Application/limera1n.app",
        "/Application/greenpois0n.app",
        "/Application/blackra1n.app",
        "/Application/blacksn0w.app",
        "/Application/redsn0w.app",
        NULL
    };

    __jb_app = NULL;

    // method 1
    for (int i = 0; __jb_apps[i]; ++i) {
        if ([[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithUTF8String:__jb_apps[i]]]) {
            __jb_app = __jb_apps[i];
            return YES;
        }
    }

    // method 2
    if ([[NSFileManager defaultManager] fileExistsAtPath:@"/private/var/lib/apt/"]) {
        return YES;
    }

    // method 3
    char *const args[] = {"ls", "-la", NULL};
    int err;

    err = posix_spawn(NULL, "/bin/ls", NULL, NULL, args, NULL);

    if (err != 0) {
        return YES;
    }
#endif

    return NO;
}

+ (NSString *)kl_jailBreaker NS_AVAILABLE_IOS(4_0)
{
#if (TARGET_OS_IPHONE)
    if (__jb_app) {
        return [NSString stringWithUTF8String:__jb_app];
    }
#endif
    return @"";
}

+ (NSString *)kl_carrierName
{
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc]init];
    CTCarrier *carrier = [info subscriberCellularProvider];

    return carrier.carrierName;
}

+ (NSString *)kl_mobileNetworkCode
{
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc]init];
    CTCarrier *carrier = [info subscriberCellularProvider];

    return carrier.mobileNetworkCode;
}

+ (NSString *)kl_IPV4
{
    return [self kl_ipAddress:YES];
}

+ (NSString *)kl_IPV6
{
    return [self kl_ipAddress:NO];
}

+ (NSString *)kl_ipAddress:(BOOL)preferIPv4
{
    NSArray *searchArray = preferIPv4 ?
        @[IOS_WIFI @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6, IOS_AWDL @"/" IP_ADDR_IPv4, IOS_AWDL @"/" IP_ADDR_IPv6, IOS_LOC @"/" IP_ADDR_IPv4, IOS_LOC @"/" IP_ADDR_IPv6] :
    @[IOS_WIFI @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4, IOS_AWDL @"/" IP_ADDR_IPv6, IOS_AWDL @"/" IP_ADDR_IPv4, IOS_LOC @"/" IP_ADDR_IPv6, IOS_LOC @"/" IP_ADDR_IPv4];

    NSDictionary *addresses = [self kl_getIPAddresses];
    __block NSString *address;
    [searchArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
        address = addresses[key];
        if (address) {
            *stop = YES;
        }
    }];
    return address ? address : @"0.0.0.0";
}

+ (NSDictionary *)kl_getIPAddresses
{
    NSMutableDictionary *addresses = [NSMutableDictionary dictionaryWithCapacity:8];

    // retrieve the current interfaces - returns 0 on success
    struct ifaddrs *interfaces;

    if (!getifaddrs(&interfaces)) {
        // Loop through linked list of interfaces
        struct ifaddrs *interface;

        for (interface = interfaces; interface; interface = interface->ifa_next) {
            if (!(interface->ifa_flags & IFF_UP) /* || (interface->ifa_flags & IFF_LOOPBACK) */) {
                continue; // deeply nested code harder to read
            }
            const struct sockaddr_in *addr = (const struct sockaddr_in *)interface->ifa_addr;
            char addrBuf[MAX(INET_ADDRSTRLEN, INET6_ADDRSTRLEN)];

            if (addr && (addr->sin_family == AF_INET || addr->sin_family == AF_INET6)) {
                NSString *name = [NSString stringWithUTF8String:interface->ifa_name];
                NSString *type;

                if (addr->sin_family == AF_INET) {
                    if (inet_ntop(AF_INET, &addr->sin_addr, addrBuf, INET_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv4;
                    }
                }
                else {
                    const struct sockaddr_in6 *addr6 = (const struct sockaddr_in6 *)interface->ifa_addr;

                    if (inet_ntop(AF_INET6, &addr6->sin6_addr, addrBuf, INET6_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv6;
                    }
                }

                if (type) {
                    NSString *key = [NSString stringWithFormat:@"%@/%@", name, type];
                    addresses[key] = [NSString stringWithUTF8String:addrBuf];
                }
            }
        }

        // Free memory
        freeifaddrs(interfaces);
    }
    return [addresses count] ? addresses : nil;
}

// Credit to https://www.jianshu.com/p/f2d83ddb09fe
+ (NSString *)kl_currentModel {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *model = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    if ([model isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([model isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([model isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([model isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([model isEqualToString:@"iPhone3,2"])    return @"iPhone 4 Verizon";
    if ([model isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([model isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([model isEqualToString:@"iPhone5,3"])    return @"iPhone 5c";
    if ([model isEqualToString:@"iPhone5,4"])    return @"iPhone 5c";
    if ([model isEqualToString:@"iPhone6,1"])    return @"iPhone 5s";
    if ([model isEqualToString:@"iPhone6,2"])    return @"iPhone 5s";
    if ([model isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([model isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([model isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([model isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    if ([model isEqualToString:@"iPhone8,4"])    return @"iPhone SE";
    if ([model isEqualToString:@"iPhone9,1"])    return @"iPhone 7";
    if ([model isEqualToString:@"iPhone9,2"])    return @"iPhone 7 Plus";
    if ([model isEqualToString:@"iPhone9,3"])    return @"iPhone 7";
    if ([model isEqualToString:@"iPhone9,4"])    return @"iPhone 7 Plus";
    if ([model isEqualToString:@"iPhone10,1"])   return @"iPhone 8 Global";
    if ([model isEqualToString:@"iPhone10,2"])   return @"iPhone 8 Plus Global";
    if ([model isEqualToString:@"iPhone10,3"])   return @"iPhone X Global";
    if ([model isEqualToString:@"iPhone10,4"])   return @"iPhone 8 GSM";
    if ([model isEqualToString:@"iPhone10,5"])   return @"iPhone 8 Plus GSM";
    if ([model isEqualToString:@"iPhone10,6"])   return @"iPhone X GSM";
    
    if ([model isEqualToString:@"iPhone11,2"])   return @"iPhone XS";
    if ([model isEqualToString:@"iPhone11,4"])   return @"iPhone XS Max (China)";
    if ([model isEqualToString:@"iPhone11,6"])   return @"iPhone XS Max";
    if ([model isEqualToString:@"iPhone11,8"])   return @"iPhone XR";
    
    if ([model isEqualToString:@"i386"])         return @"Simulator 32";
    if ([model isEqualToString:@"x86_64"])       return @"Simulator 64";
    
    if ([model isEqualToString:@"iPad1,1"]) return @"iPad";
    if ([model isEqualToString:@"iPad2,1"] ||
        [model isEqualToString:@"iPad2,2"] ||
        [model isEqualToString:@"iPad2,3"] ||
        [model isEqualToString:@"iPad2,4"]) return @"iPad 2";
    if ([model isEqualToString:@"iPad3,1"] ||
        [model isEqualToString:@"iPad3,2"] ||
        [model isEqualToString:@"iPad3,3"]) return @"iPad 3";
    if ([model isEqualToString:@"iPad3,4"] ||
        [model isEqualToString:@"iPad3,5"] ||
        [model isEqualToString:@"iPad3,6"]) return @"iPad 4";
    if ([model isEqualToString:@"iPad4,1"] ||
        [model isEqualToString:@"iPad4,2"] ||
        [model isEqualToString:@"iPad4,3"]) return @"iPad Air";
    if ([model isEqualToString:@"iPad5,3"] ||
        [model isEqualToString:@"iPad5,4"]) return @"iPad Air 2";
    if ([model isEqualToString:@"iPad6,3"] ||
        [model isEqualToString:@"iPad6,4"]) return @"iPad Pro 9.7-inch";
    if ([model isEqualToString:@"iPad6,7"] ||
        [model isEqualToString:@"iPad6,8"]) return @"iPad Pro 12.9-inch";
    if ([model isEqualToString:@"iPad6,11"] ||
        [model isEqualToString:@"iPad6,12"]) return @"iPad 5";
    if ([model isEqualToString:@"iPad7,1"] ||
        [model isEqualToString:@"iPad7,2"]) return @"iPad Pro 12.9-inch 2";
    if ([model isEqualToString:@"iPad7,3"] ||
        [model isEqualToString:@"iPad7,4"]) return @"iPad Pro 10.5-inch";
    
    if ([model isEqualToString:@"iPad2,5"] ||
        [model isEqualToString:@"iPad2,6"] ||
        [model isEqualToString:@"iPad2,7"]) return @"iPad mini";
    if ([model isEqualToString:@"iPad4,4"] ||
        [model isEqualToString:@"iPad4,5"] ||
        [model isEqualToString:@"iPad4,6"]) return @"iPad mini 2";
    if ([model isEqualToString:@"iPad4,7"] ||
        [model isEqualToString:@"iPad4,8"] ||
        [model isEqualToString:@"iPad4,9"]) return @"iPad mini 3";
    if ([model isEqualToString:@"iPad5,1"] ||
        [model isEqualToString:@"iPad5,2"]) return @"iPad mini 4";
    
    if ([model isEqualToString:@"iPod1,1"]) return @"iTouch";
    if ([model isEqualToString:@"iPod2,1"]) return @"iTouch2";
    if ([model isEqualToString:@"iPod3,1"]) return @"iTouch3";
    if ([model isEqualToString:@"iPod4,1"]) return @"iTouch4";
    if ([model isEqualToString:@"iPod5,1"]) return @"iTouch5";
    if ([model isEqualToString:@"iPod7,1"]) return @"iTouch6";
    
    return @"高端设备，不错哟！";
}


@end

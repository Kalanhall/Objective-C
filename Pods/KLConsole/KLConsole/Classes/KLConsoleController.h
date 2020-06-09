//
//  KLConsoleController.h
//  KLConsole
//
//  Created by Logic on 2020/1/6.
//

#define KLConsolePath [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:@"KLConsole.plist"]
#define KLConsoleAddressPath [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:@"KLConsoleAddress.plist"]

#import <UIKit/UIKit.h>
@import Masonry;

NS_ASSUME_NONNULL_BEGIN

@interface KLConsoleController : UIViewController

@end

NS_ASSUME_NONNULL_END

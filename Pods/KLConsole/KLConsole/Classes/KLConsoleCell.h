//
//  KLConsoleCell.h
//  KLConsole
//
//  Created by Logic on 2020/1/6.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KLConsoleCell : UITableViewCell

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *infoLabel;
@property (strong, nonatomic) UISwitch *consoleSwitch;

@property (copy, nonatomic) void (^switchChangeCallBack)(BOOL on);

@end

@interface KLConsoleInfoCell : KLConsoleCell

@end

NS_ASSUME_NONNULL_END

//
//  KLConsoleCell.m
//  KLConsole
//
//  Created by Logic on 2020/1/6.
//

#import "KLConsoleCell.h"
@import Masonry;

@implementation KLConsoleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.titleLabel = UILabel.alloc.init;
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        self.titleLabel.textColor = UIColor.blackColor;
        self.titleLabel.numberOfLines = 0;
        [self.contentView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.top.mas_equalTo(10);
            make.right.mas_equalTo(-15);
        }];
        
        self.infoLabel = UILabel.alloc.init;
        self.infoLabel.font = [UIFont systemFontOfSize:12];
        self.infoLabel.textColor = UIColor.lightGrayColor;
        self.infoLabel.numberOfLines = 0;
        [self.contentView addSubview:self.infoLabel];
        [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(5);
            make.right.mas_equalTo(-15);
            make.bottom.mas_equalTo(-10);
        }];
        
        self.consoleSwitch = UISwitch.alloc.init;
        [self.contentView addSubview:self.consoleSwitch];
        [self.consoleSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
            make.centerY.mas_equalTo(0);
        }];
        [self.consoleSwitch addTarget:self action:@selector(switchChange:) forControlEvents:UIControlEventValueChanged];
        self.consoleSwitch.hidden = YES;
    }
    return self;
}

- (void)switchChange:(UISwitch *)consoleSwitch
{
    if (self.switchChangeCallBack) {
        self.switchChangeCallBack(consoleSwitch.on);
    }
}

@end

@implementation KLConsoleInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

    }
    return self;
}

@end

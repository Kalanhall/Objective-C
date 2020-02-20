//
//  KLConsoleInfoController.m
//  KLConsole
//
//  Created by Logic on 2020/1/6.
//

#import "KLConsoleInfoController.h"
#import "KLConsoleCell.h"
#import "KLConsoleController.h"
#import "UIDevice+KLConsole.h"
@import Masonry;

@interface KLConsoleInfoController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIView *toastView;
@property (strong, nonatomic) UILabel *toastLabel;

@end

@implementation KLConsoleInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView = [UITableView.alloc initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 50;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.tableView setBackgroundColor:[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1]];
    [self.tableView registerClass:KLConsoleCell.class forCellReuseIdentifier:KLConsoleCell.description];
    [self.tableView registerClass:KLConsoleInfoCell.class forCellReuseIdentifier:KLConsoleInfoCell.description];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    [self.tableView registerClass:KLConsoleInfoCell.class forCellReuseIdentifier:KLConsoleInfoCell.description];
    
    self.toastView = UIView.alloc.init;
    self.toastView.backgroundColor = UIColor.blackColor;
    [self.view addSubview:self.toastView];
    [self.toastView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.mas_equalTo(0);
    }];
    self.toastView.alpha = 0;
    
    self.toastLabel = UILabel.alloc.init;
    self.toastLabel.backgroundColor = UIColor.blackColor;
    self.toastLabel.textColor = UIColor.whiteColor;
    self.toastLabel.font = [UIFont systemFontOfSize:13];
    self.toastLabel.textAlignment = NSTextAlignmentCenter;
    self.toastLabel.numberOfLines = 0;
    [self.toastView addSubview:self.toastLabel];
    [self.toastLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(10, 10, 10, 10));
    }];
    
}

- (void)showToast:(NSString *)text
{
    self.toastLabel.text = text;
    self.toastView.alpha = 1;
    [UIView animateWithDuration:0.25 delay:1.5 options:UIViewAnimationOptionCurveLinear animations:^{
        self.toastView.alpha = 0;
    } completion:nil];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (self.infoType) {
        case KLConsoleInfoTypeAddress:
            return self.config.details.count;
        case KLConsoleInfoTypeSystemInfo:
            return self.fetchSystemInfos.count;
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KLConsoleInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:KLConsoleInfoCell.description];
    
    if (self.infoType == KLConsoleInfoTypeAddress) {
        // 域名地址
        KLConsoleThreeConfig *info = self.config.details[indexPath.row];
        cell.titleLabel.text = info.title;
        cell.infoLabel.text = info.text;
        
        if (self.config.selectedIndex == indexPath.row) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    } else {
        // 设备应用信息
        NSDictionary *info;
        switch (self.infoType) {
            case KLConsoleInfoTypeSystemInfo:
                info = self.fetchSystemInfos[indexPath.row];
                break;
            default:
                break;
        }
        
        cell.titleLabel.text = [info valueForKey:@"title"];
        cell.infoLabel.text = [info valueForKey:@"subtitle"];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.infoType == KLConsoleInfoTypeAddress) {
        __block NSArray<KLConsoleSecondConfig *> *cachecgs = [KLConsoleConfig unarchiveObjectWithFilePath:KLConsoleAddressPath];
        [cachecgs enumerateObjectsUsingBlock:^(KLConsoleSecondConfig * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.title isEqualToString:self.config.title]) {
                obj.selectedIndex = indexPath.row;
                obj.subtitle = obj.details[indexPath.row].text;
                self.config.selectedIndex = obj.selectedIndex;
                [NSKeyedArchiver archiveRootObject:cachecgs toFile:KLConsoleAddressPath];
                [tableView reloadData];
                
                if (self.selectedCallBack) {
                    self.selectedCallBack();
                }
            }
        }];
    } else if (self.infoType == KLConsoleInfoTypeSystemInfo) {
        KLConsoleInfoCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        UIPasteboard *pasteboard = UIPasteboard.generalPasteboard;
        pasteboard.string = cell.infoLabel.text;
        [self showToast:[NSString stringWithFormat:@"%@\n已复制", cell.titleLabel.text]];
    }
}

- (NSArray *)fetchSystemInfos
{
    NSArray *systemInfos = @[
            @{
                @"title" : @"应用名称",
                @"subtitle" : [UIDevice kl_appDisplayName] ? : @""
            },
            @{
                @"title" : @"版本号",
                @"subtitle" : [UIDevice kl_appShortVersion] ? : @""
            },
            @{
                @"title" : @"Build号",
                @"subtitle" : [UIDevice kl_appBuildVersion] ? : @""
            },
            @{
                @"title" : @"Bundle Id",
                @"subtitle" : [UIDevice kl_appIdentifier] ? : @""
            },
            @{
                @"title" : @"KeyChain Id",
                @"subtitle" : [UIDevice kl_deviceIdentifierForKeyChain] ? : @""
            }
            , @{
                @"title" : @"手机系统",
                @"subtitle" : [UIDevice kl_OSVersion] ? : @""
            },
            @{
                @"title" : @"是否发布版本",
            #ifdef __OPTIMIZE__
                @"subtitle" : @"是"
            #else
                @"subtitle" : @"否"
            #endif
            },
            @{
                @"title" : @"设备类型",
                @"subtitle" : [UIDevice kl_currentModel] ? : @""
            },
            @{
                @"title" : @"分辨率(宽高)",
                @"subtitle" : [NSString stringWithFormat:@"%.1f x %.1f (%.1f x %.1f) @scale %.1f", UIScreen. mainScreen.currentMode.size.width, UIScreen. mainScreen.currentMode.size.height, UIScreen. mainScreen.bounds.size.width, UIScreen. mainScreen.bounds.size.height, UIScreen. mainScreen.scale]
            }, @{
                @"title" : @"运营商",
                @"subtitle" : [UIDevice kl_carrierName] ? : @"请插入SIM卡"
            }, @{
                @"title" : @"系统语言",
                @"subtitle" : [UIDevice kl_OSLanguage] ? : @""
            }, @{
                @"title" : @"是否越狱",
                @"subtitle" : [NSString stringWithFormat:@"%@", [UIDevice kl_isJailBroken] ? @"是" : @"否"]
            }, @{
                @"title" : @"ip地址(ipv4)",
                @"subtitle" : [UIDevice kl_IPV4] ? : @""
            }, @{
                @"title" : @"ip地址(ipv6)",
                @"subtitle" : [UIDevice kl_IPV6] ? : @""
            }, @{
                @"title" : @"系统位数",
            #ifdef __LP64__
                @"subtitle" : @"64位"
            #else
                @"subtitle" : @"32位"
            #endif
            }
        ];

    return systemInfos;
}

@end

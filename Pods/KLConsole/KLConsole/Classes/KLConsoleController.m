//
//  KLConsoleController.m
//  KLConsole
//
//  Created by Logic on 2020/1/6.
//

#import "KLConsoleController.h"
#import "KLConsoleCell.h"
#import "KLConsoleInfoController.h"
#import <sys/utsname.h>
#import <ifaddrs.h>
#import <arpa/inet.h>
#import <sys/sysctl.h>
#import "KLConsoleConfig.h"
#import "KLConsole.h"
#import <objc/runtime.h>
@import YKWoodpecker;

@interface KLConsoleController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataSource;

@end

@implementation KLConsoleController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"控制台";
    self.view.backgroundColor = UIColor.whiteColor;
    
    if (@available(iOS 11.0, *)) {
        self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeAutomatic;
        self.navigationController.navigationBar.prefersLargeTitles = YES;
    }
    
    self.view.backgroundColor = UIColor.whiteColor;
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem.alloc initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancleCallBack)];

    self.tableView = [UITableView.alloc initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 50;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.sectionHeaderHeight = 30;
    self.tableView.sectionFooterHeight = 15;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.tableView setBackgroundColor:[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1]];
    [self.tableView registerClass:KLConsoleCell.class forCellReuseIdentifier:KLConsoleCell.description];
    [self.tableView registerClass:KLConsoleInfoCell.class forCellReuseIdentifier:KLConsoleInfoCell.description];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    [self reloadData];
}

- (void)reloadData
{
    // 数据源
    NSArray<KLConsoleSecondConfig *> *addresscgs = [KLConsoleConfig unarchiveObjectWithFilePath:KLConsoleAddressPath];
    if (addresscgs == nil) {
        // 从系统单例中取出挂载数据
        addresscgs = objc_getAssociatedObject(NSNotificationCenter.defaultCenter, @selector(consoleAddressSetup:));
        // 归档
        [NSKeyedArchiver archiveRootObject:addresscgs toFile:KLConsoleAddressPath];
    }
    
    NSArray<KLConsoleConfig *> *othercgs = [KLConsoleConfig unarchiveObjectWithFilePath:KLConsolePath];
    if (othercgs == nil) {
        // 从系统单例中取出挂载数据
        othercgs = objc_getAssociatedObject(NSNotificationCenter.defaultCenter, @selector(consoleSetup:));
        // 归档
        [KLConsoleConfig archiveRootObject:othercgs toFilePath:KLConsolePath];
    }
    
    NSArray<KLConsoleSecondConfig *> *debugcgs = [KLConsoleConfig unarchiveObjectWithFilePath:KLConsoleDebugPath];
    
    KLConsoleConfig *A = KLConsoleConfig.alloc.init;
    A.title = @"环境配置";
    A.infos = addresscgs;

    KLConsoleConfig *B = KLConsoleConfig.alloc.init;
    B.title = @"设备信息";
    KLConsoleSecondConfig *Ba = KLConsoleSecondConfig.alloc.init;
    Ba.title = @"基本信息";
    Ba.subtitle = @"系统及应用相关信息";
    B.infos = @[Ba];
    
    KLConsoleConfig *C = KLConsoleConfig.alloc.init;
    C.title = @"调试工具";
    KLConsoleSecondConfig *Ca = KLConsoleSecondConfig.alloc.init;
    Ca.title = @"YKWoodpecker";
    Ca.subtitle = @"啄幕鸟";
    C.infos = debugcgs ? : @[Ca];
    
    if (debugcgs.firstObject.switchOn) {
        [YKWoodpeckerManager.sharedInstance show];
    } else {
        [YKWoodpeckerManager.sharedInstance hide];
    }
    
    self.dataSource = @[A, B, C].mutableCopy;
    
    // 添加通用扩展配置
    [self.dataSource addObjectsFromArray:othercgs];
    
    [self.tableView reloadData];
}

- (void)cancleCallBack
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    KLConsoleConfig *config = self.dataSource[section];
    return config.infos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KLConsoleCell *cell = [tableView dequeueReusableCellWithIdentifier:KLConsoleCell.description];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.consoleSwitch.hidden = YES;
    KLConsoleConfig *config = self.dataSource[indexPath.section];
    KLConsoleSecondConfig *scg = config.infos[indexPath.row];
    cell.titleLabel.text = scg.title;
    cell.infoLabel.text = scg.subtitle;
    cell.consoleSwitch.on = scg.switchOn;
    
    if (0 == indexPath.section) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.titleLabel.text = [NSString stringWithFormat:@"%@（%@）", scg.title, scg.details[scg.selectedIndex].title];
    } else if (1 == indexPath.section) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else if (2 == indexPath.section) {
        cell.consoleSwitch.hidden = NO;
        cell.switchChangeCallBack = ^(BOOL on) {
            if (on) {
                [YKWoodpeckerManager.sharedInstance show];
            } else {
                [YKWoodpeckerManager.sharedInstance hide];
            }
            scg.switchOn = on;
            // 归档
            [KLConsoleConfig archiveRootObject:config.infos toFilePath:KLConsoleDebugPath];
        };
    } else {
        cell.consoleSwitch.hidden = !scg.switchEnable;
        cell.accessoryType = scg.switchEnable ? UITableViewCellAccessoryNone : UITableViewCellAccessoryDisclosureIndicator;
        __weak typeof(cell) weakcell = cell;
        __weak typeof(self) weakself = self;
        cell.switchChangeCallBack = ^(BOOL on) {
            // 1、获取关联属性
            void (^callBack)(NSIndexPath *, BOOL) = objc_getAssociatedObject(weakself, @selector(consoleSetupAndSelectedCallBack:));
            if (callBack) {
                callBack([NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section - 3], weakcell.consoleSwitch.on); // 减去固定section个数
            }
        };
    }

    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIButton *header = UIButton.alloc.init;
    header.titleLabel.font = [UIFont boldSystemFontOfSize:11];
    KLConsoleConfig *config = self.dataSource[section];
    [header setTitle:config.title forState:UIControlStateNormal];
    [header setTitleEdgeInsets:(UIEdgeInsets){0, 15, 0, 0}];
    [header setTitleColor:[UIColor colorWithRed:40/255.0 green:122/255.0 blue:255/255.0 alpha:1] forState:UIControlStateNormal];
    [header setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    return header;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return UIView.new;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    KLConsoleConfig *config = self.dataSource[indexPath.section];
    KLConsoleSecondConfig *scg = config.infos[indexPath.row];
    
    KLConsoleInfoController *vc = KLConsoleInfoController.alloc.init;
    vc.title = scg.title;
    
    if (indexPath.section == 0) {
        // 环境配置
        __weak typeof(self) weakself = self;
        vc.config = config.infos[indexPath.row];
        vc.infoType = KLConsoleInfoTypeAddress;
        vc.selectedCallBack = ^() { [weakself reloadData]; };
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.section == 1) {
        // 系统信息
        vc.infoType = KLConsoleInfoTypeSystemInfo;
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.section == 2) {
        // 不处理点击
    } else {
        // 扩展行点击
        // 1、获取开关
        KLConsoleCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (cell.consoleSwitch.hidden) {
            void (^callBack)(NSIndexPath *, BOOL) = objc_getAssociatedObject(self, @selector(consoleSetupAndSelectedCallBack:));
            if (callBack) {
                callBack([NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section - 3], cell.consoleSwitch.on); // 减去固定section个数
            }
        }
    }
}

- (NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = NSMutableArray.array;
    }
    return _dataSource;
}

@end

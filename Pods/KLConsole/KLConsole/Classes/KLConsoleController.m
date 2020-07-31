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
#import "KLConsoleSectionConfig.h"
#import "KLConsole.h"
#import <objc/runtime.h>

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

- (void)reloadData {
    // 数据源
    NSArray<KLConsoleRowConfig *> *addresscgs = [KLConsoleSectionConfig unarchiveObjectWithFilePath:KLConsoleAddressPath];
    if (addresscgs == nil) {
        // 从系统单例中取出挂载数据
        addresscgs = objc_getAssociatedObject(NSNotificationCenter.defaultCenter, @selector(consoleAddressSetup:));
        // 归档
        [NSKeyedArchiver archiveRootObject:addresscgs toFile:KLConsoleAddressPath];
    }
    
    NSArray<KLConsoleSectionConfig *> *othercgs = [KLConsoleSectionConfig unarchiveObjectWithFilePath:KLConsolePath];
    if (othercgs == nil) {
        // 从系统单例中取出挂载数据
        othercgs = objc_getAssociatedObject(NSNotificationCenter.defaultCenter, @selector(consoleSetup:));
        // 归档
        [KLConsoleSectionConfig archiveRootObject:othercgs toFilePath:KLConsolePath];
    }
    
    KLConsoleSectionConfig *A = KLConsoleSectionConfig.alloc.init;
    A.title = @"环境配置";
    A.infos = addresscgs;

    KLConsoleSectionConfig *B = KLConsoleSectionConfig.alloc.init;
    B.title = @"设备信息";
    KLConsoleRowConfig *Ba = KLConsoleRowConfig.alloc.init;
    Ba.title = @"基本信息";
    Ba.subtitle = @"系统及应用相关信息";
    B.infos = @[Ba];
    
    // 非频繁操作，直接移除
    [self.dataSource removeAllObjects];
    
    // 固定设置
    [self.dataSource addObject:A];
    [self.dataSource addObject:B];
    // 添加通用扩展配置
    [self.dataSource addObjectsFromArray:othercgs];
    [self.tableView reloadData];
    
    // 初始化开关设置
    [othercgs enumerateObjectsUsingBlock:^(KLConsoleSectionConfig * _Nonnull sectionobj, NSUInteger sectionidx, BOOL * _Nonnull stop) {
        [sectionobj.infos enumerateObjectsUsingBlock:^(KLConsoleRowConfig * _Nonnull rowobj, NSUInteger rowidx, BOOL * _Nonnull stop) {
            if (rowobj.switchEnable) {
                // 1、获取关联属性
                void (^callBack)(NSIndexPath *, BOOL) = objc_getAssociatedObject(self, @selector(consoleSetupAndSelectedCallBack:));
                if (callBack) {
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:rowidx inSection:sectionidx];
                    callBack(indexPath, rowobj.switchOn);
                }
            }
        }];
    }];
}

- (void)cancleCallBack {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    KLConsoleSectionConfig *config = self.dataSource[section];
    return config.infos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KLConsoleCell *cell = [tableView dequeueReusableCellWithIdentifier:KLConsoleCell.description];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.consoleSwitch.hidden = YES;
    KLConsoleSectionConfig *config = self.dataSource[indexPath.section];
    KLConsoleRowConfig *scg = config.infos[indexPath.row];
    cell.titleLabel.text = scg.title;
    cell.infoLabel.text = scg.subtitle;
    cell.consoleSwitch.on = scg.switchOn;
    
    if (0 == indexPath.section) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.titleLabel.text = [NSString stringWithFormat:@"%@（%@ v%@）", scg.title, scg.details[scg.selectedIndex].title, scg.version];
    } else if (1 == indexPath.section) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else {
        cell.consoleSwitch.hidden = !scg.switchEnable;
        cell.accessoryType = scg.switchEnable ? UITableViewCellAccessoryNone : UITableViewCellAccessoryDisclosureIndicator;
        __weak typeof(cell) weakcell = cell;
        __weak typeof(self) weakself = self;
        
        cell.switchChangeCallBack = ^(BOOL on) {
            // 1、获取关联属性
            void (^callBack)(NSIndexPath *, BOOL) = objc_getAssociatedObject(weakself, @selector(consoleSetupAndSelectedCallBack:));
            if (callBack) {
                NSInteger index = indexPath.section - 2; // 减去固定section个数
                callBack([NSIndexPath indexPathForRow:indexPath.row inSection:index], weakcell.consoleSwitch.on);
                
                // 存储开关信息
                if (weakcell.consoleSwitch.hidden == NO) {
                    BOOL on = weakcell.consoleSwitch.on;
                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                        NSArray<KLConsoleSectionConfig *> *othercgs = [KLConsoleSectionConfig unarchiveObjectWithFilePath:KLConsolePath];
                        KLConsoleSectionConfig *config = othercgs[index];
                        KLConsoleRowConfig *twoconfig = config.infos[indexPath.row];
                        twoconfig.switchOn = on;
                        [KLConsoleSectionConfig archiveRootObject:othercgs toFilePath:KLConsolePath];
                    });
                }
            }
        };
    }

    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIButton *header = UIButton.alloc.init;
    header.titleLabel.font = [UIFont boldSystemFontOfSize:11];
    KLConsoleSectionConfig *config = self.dataSource[section];
    [header setTitle:config.title forState:UIControlStateNormal];
    [header setTitleEdgeInsets:(UIEdgeInsets){0, 15, 0, 0}];
    [header setTitleColor:[UIColor colorWithRed:40/255.0 green:122/255.0 blue:255/255.0 alpha:1] forState:UIControlStateNormal];
    [header setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    return header;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return UIView.new;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        KLConsoleSectionConfig *config = self.dataSource[indexPath.section];
        KLConsoleRowConfig *scg = config.infos[indexPath.row];
        KLConsoleInfoController *vc = KLConsoleInfoController.alloc.init;
        vc.title = scg.title;
        // 环境配置
        __weak typeof(self) weakself = self;
        vc.config = config.infos[indexPath.row];
        vc.infoType = KLConsoleInfoTypeAddress;
        vc.selectedCallBack = ^() { [weakself reloadData]; };
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.section == 1) {
        KLConsoleSectionConfig *config = self.dataSource[indexPath.section];
        KLConsoleRowConfig *scg = config.infos[indexPath.row];
        KLConsoleInfoController *vc = KLConsoleInfoController.alloc.init;
        vc.title = scg.title;
        // 系统信息
        vc.infoType = KLConsoleInfoTypeSystemInfo;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        // 扩展行点击
        // 1、获取开关
        KLConsoleCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (cell.consoleSwitch.hidden) {
            void (^callBack)(NSIndexPath *, BOOL) = objc_getAssociatedObject(self, @selector(consoleSetupAndSelectedCallBack:));
            if (callBack) {
                callBack([NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section - 2], cell.consoleSwitch.on); // 减去固定section个数
            }
        }
    }
}

- (NSMutableArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = NSMutableArray.array;
    }
    return _dataSource;
}

@end

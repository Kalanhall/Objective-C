//
//  LaunchCommand.m
//  Objective-C
//
//  Created by Kalan on 2020/7/22.
//  Copyright © 2020 Kalan. All rights reserved.
//

#import "LaunchCommand.h"
@import KLApplicationEntry;
@import KLHomeServiceInterface;
@import KLConsole;
@import KLCategory;
@import KLGuidePage;
@import KLImageView;
@import KLNetworkModule;
@import YKWoodpecker;
#import "AppTabBarController.h"
#import "AppNavigationController.h"
#import "AppGuideCell.h"
#import "AppVersionUpdate.h"

@interface LaunchCommand () <KLGuidePageDataSource>

@end

@implementation LaunchCommand

// 代理辅助类，因为command在execute后释放
static LaunchCommand *_instance = nil;
+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (void)execute {
    // 网络环境初始化
    [LaunchCommand setupDebugTool];
    
    // 根控制器初始化
    [LaunchCommand setupRootViewController];
    
    // 引导图初始化
    if (KLGetFirstLaunch()) [LaunchCommand setupGuidePage];
        
    // 启动图 & 闪屏页 初始化
    [LaunchCommand setupLaunchImage];
    
    // 版本更新
    [LaunchCommand setupVersionUpdateToView:nil];
    
    [super execute];
}

// MARK: - 🌈🌈🌈 RootViewController
+ (void)setupRootViewController {
    UIWindow *window = [UIWindow.alloc initWithFrame:UIScreen.mainScreen.bounds];
    UIApplication.sharedApplication.delegate.window = window;
    
    AppNavigationController *one = [AppNavigationController navigationWithRootViewController:[KLServer.sharedServer fetchHomeController:nil]
                                                                                       title:@"闲鱼" image:@"tab0-n" selectedImage:@"tab0-s"];
    AppNavigationController *two = [AppNavigationController navigationWithRootViewController:[KLServer.sharedServer fetchHomeController:nil]
                                                                                       title:@"鱼塘" image:@"tab1-n" selectedImage:@"tab1-s"];
    AppNavigationController *thr = [AppNavigationController navigationWithRootViewController:[KLServer.sharedServer fetchHomeController:nil]
                                                                                       title:@"发布" image:@"x占位xx" selectedImage:@"x占位xx"];
    AppNavigationController *fou = [AppNavigationController navigationWithRootViewController:[KLServer.sharedServer fetchHomeController:nil]
                                                                                       title:@"消息" image:@"tab3-n" selectedImage:@"tab3-s"];
    AppNavigationController *fiv = [AppNavigationController navigationWithRootViewController:[KLServer.sharedServer fetchHomeController:nil]
                                                                                       title:@"我的" image:@"tab4-n" selectedImage:@"tab4-s"];
    // 选项卡入口配置
    NSArray *controllers = @[one, two, thr, fou, fiv];
    AppTabBarController *vc = [AppTabBarController tabBarWithControllers:controllers];
    
    // 控制台调用
    #ifdef DEBUG
    vc.swipeTabBarCallBack = ^(UISwipeGestureRecognizer * _Nonnull swipe) {
        [LaunchCommand showDebugTool];
    };
    #endif
    
    // 导航栏全局设置
    [AppNavigationController setAppearanceTincolor:UIColor.blackColor];
    [AppNavigationController setAppearanceBarTincolor:UIColor.whiteColor];
    [AppNavigationController setAppearanceBackIndicatorImage:[UIImage imageNamed:@"back"]];
    
    // 选项卡全局设置
    // 设置背景
    [vc setTabBarBackgroundImageWithColor:[UIColor.whiteColor colorWithAlphaComponent:0.9]];
//    // 设置阴影
    [vc setTabBarShadowColor:UIColor.blackColor opacity:0.1];
    // 设置文字样式
    [vc setTabBarItemTitleTextAttributes:@{NSForegroundColorAttributeName : UIColor.blackColor,
                                           NSFontAttributeName : [UIFont systemFontOfSize:10]}
                                forState:UIControlStateNormal];
    [vc setTabBarItemTitleTextAttributes:@{NSForegroundColorAttributeName : UIColor.blackColor,
                                           NSFontAttributeName : [UIFont systemFontOfSize:10]}
                                forState:UIControlStateSelected];
    // 设置文字位置偏移量
    [vc setTabBarItemTitlePositionAdjustment:(UIOffset){0, -2} forState:UIControlStateNormal];
    [vc setTabBarItemTitlePositionAdjustment:(UIOffset){0, -2} forState:UIControlStateSelected];

    // 设置中间凸起按钮
    [vc setupCustomAreaView];
    
    // 设置主窗口
    window.rootViewController = vc;
    [window makeKeyAndVisible];
}

// MARK: - 🌈🌈🌈 DebugTool
+ (void)setupDebugTool {
    // 环境初始化
    [KLConsole consoleAddressSetup:^(NSMutableArray<KLConsoleRowConfig *> *configs) {
        KLConsoleRowConfig *serviceA = KLConsoleRowConfig.alloc.init;
        
        KLConsoleInfoConfig *serviceAa = KLConsoleInfoConfig.alloc.init;
        serviceAa.title = @"生产环境";
        serviceAa.text = @"https://api.galanz.com/prod";
        KLConsoleInfoConfig *serviceAb = KLConsoleInfoConfig.alloc.init;
        serviceAb.title = @"开发环境";
        serviceAb.text = @"https://api.galanz.com/dev";
        KLConsoleInfoConfig *serviceAc = KLConsoleInfoConfig.alloc.init;
        serviceAc.title = @"测试环境";
        serviceAc.text = @"https://api.galanz.com/test";
        KLConsoleInfoConfig *serviceAd = KLConsoleInfoConfig.alloc.init;
        serviceAd.title = @"预发布环境";
        serviceAd.text = @"https://api.galanz.com/stage";
        serviceA.details = @[serviceAa, serviceAb, serviceAc, serviceAd];
        
        serviceA.version = @"1.0";
        serviceA.title = @"服务器域名";
        serviceA.selectedIndex = 0;
        serviceA.subtitle = serviceA.details[serviceA.selectedIndex].text;
        
        [configs addObject:serviceA];
    }];
    
    // MAKR: 扩展功能
    [KLConsole consoleSetup:^(NSMutableArray<KLConsoleSectionConfig *> * _Nonnull configs) {
        KLConsoleSectionConfig *serverA = KLConsoleSectionConfig.alloc.init;
        serverA.title = @"调试工具";
        
        KLConsoleRowConfig *serverAa = KLConsoleRowConfig.alloc.init;
        serverAa.title = @"YKWoodpecker";
        serverAa.subtitle = @"啄幕鸟：网络监听、视图校对、文件管理等";
        
        KLConsoleSectionConfig *serverB = KLConsoleSectionConfig.alloc.init;
        serverB.title = @"功能测试";
        
        KLConsoleRowConfig *serverBa = KLConsoleRowConfig.alloc.init;
        serverBa.title = @"版本升级";
        serverBa.subtitle = @"点击测试获取最新版本";
        
        KLConsoleRowConfig *serverBb = KLConsoleRowConfig.alloc.init;
        serverBb.title = @"启动页";
        serverBb.subtitle = @"点击测试";
        
        KLConsoleRowConfig *serverBc = KLConsoleRowConfig.alloc.init;
        serverBc.title = @"引导页";
        serverBc.subtitle = @"点击测试";
        
        serverA.infos = @[serverAa];
        serverB.infos = @[serverBa, serverBb, serverBc];
        [configs addObject:serverA];
        [configs addObject:serverB];
    }];
}

+ (void)showDebugTool {
    YKWoodpeckerManager.sharedInstance.autoOpenUICheckOnShow = NO;

    [KLConsole consoleSetupAndSelectedCallBack:^(NSIndexPath * _Nonnull indexPath, BOOL switchOn) {
        // 扩展功能回调
        if (indexPath.section == 0) {
            if (!YKWoodpeckerManager.sharedInstance.autoOpenUICheckOnShow) {
                [YKWoodpeckerManager.sharedInstance show];
                YKWoodpeckerManager.sharedInstance.autoOpenUICheckOnShow = YES;
            } else {
                [YKWoodpeckerManager.sharedInstance hide];
                YKWoodpeckerManager.sharedInstance.autoOpenUICheckOnShow = NO;
            }
        } else if (indexPath.section == 1) {
            switch (indexPath.row) {
                case 0: {
                    [NSUserDefaults.standardUserDefaults setValue:nil forKey:AppVersionUpdate.description]; // 测试清空忽略版本
                    [NSUserDefaults.standardUserDefaults synchronize];
                    [LaunchCommand setupVersionUpdateToView:UIApplication.sharedApplication.keyWindow];
                }
                    break;
                case 1:
                    [LaunchCommand setupLaunchImage];
                    break;
                case 2:
                    [LaunchCommand setupGuidePage];
                    break;
                default:
                    break;
            }
        }
    }];
}

// MARK: - 🌈🌈🌈 LaunchScreen
+ (void)setupLaunchImage {
    // 自定义布局
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"LaunchScreen" bundle:nil];
    UIViewController *launchVc = [story instantiateViewControllerWithIdentifier:@"LaunchScreen"];
    [UIApplication.sharedApplication.keyWindow addSubview:launchVc.view];
    
    // LaunchScreen 无法使用自定义控件、属性，提供容器，由外部进行个性化处理
    UIView *content = [launchVc.view viewWithTag:999]; // 自定义容器
    content.userInteractionEnabled = YES;
    // 闪屏页面（广告）
    KLImageView *imageHandler = KLImageView.alloc.init;
    [content addSubview:imageHandler];
    [imageHandler mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    // 添加倒计时控件
    UIButton *timeHandler = [UIButton buttonWithType:UIButtonTypeCustom];
    timeHandler.titleLabel.font = [UIFont systemFontOfSize:11];
    timeHandler.layer.masksToBounds = YES;
    timeHandler.hidden = YES;
    timeHandler.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.3];
    [timeHandler setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft]; // 避免数字变动造成视觉抖动
    [timeHandler setTitleEdgeInsets:(UIEdgeInsets){0,13,0,-13}];
    [timeHandler setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [launchVc.view addSubview:timeHandler];
    [timeHandler mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.mas_equalTo(UIApplication.sharedApplication.keyWindow.safeAreaInsets.top ? : 20);
        } else {
            make.top.mas_equalTo(20);
        }
        make.right.mas_equalTo(-15);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(25);
    }];
    timeHandler.layer.cornerRadius = 25 * 0.5;
    
    // 广告点击跳转
    [imageHandler kl_setTapCompletion:^(UITapGestureRecognizer *tapGesture) {
        [LaunchCommand skipLaunchScreen:timeHandler];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            UIViewController *vc = UIViewController.new;
            vc.view.backgroundColor = UIColor.kl_randomColor;
            [KLCurrentController().navigationController pushViewController:vc animated:YES];
        });
    }];
    
    // 按钮点击跳过
    [timeHandler kl_controlEvents:UIControlEventTouchUpInside completion:^(UIButton * _Nonnull sender) {
        [LaunchCommand skipLaunchScreen:timeHandler];
    }];
    
    // 网络获取广告信息
    NSString *remoteurl = @"https://pic.ibaotu.com/00/06/52/97i888piCRu2.jpg-0.jpg!ww7002";
    if (remoteurl.length > 0) {
        [imageHandler kl_setImageWithURL:[NSURL URLWithString:remoteurl] placeholder:nil options:KLWebImageOptionProgressiveBlur completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, KLWebImageFromType from, KLWebImageStage stage, NSError * _Nullable error) {
            // 跳过按钮开关
            timeHandler.hidden = image == nil;
            // 广告交互开关
            imageHandler.userInteractionEnabled = image != nil;
            // 倒计时
            [LaunchCommand setupCycleTimeOut:image ? 3 : 0 callBack:^(NSTimeInterval time) {
                if (time == 0) {
                    [LaunchCommand skipLaunchScreen:timeHandler];
                } else {
                    if (image) [timeHandler setTitle:[NSString stringWithFormat:@"跳过广告 %@", @(time)] forState:UIControlStateNormal];
                }
            }];
        }];
    } else {
        [LaunchCommand skipLaunchScreen:timeHandler];
    }
}

+ (void)skipLaunchScreen:(UIButton *)sender {
    [UIView animateWithDuration:0.75 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        sender.superview.alpha = 0;
        sender.superview.transform = CGAffineTransformMakeScale(2, 2);
    } completion:^(BOOL finished) {
        [sender.superview removeFromSuperview];
    }];
}

+ (void)setupCycleTimeOut:(NSTimeInterval)timeout callBack:(void (^)(NSTimeInterval time))callBack {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (timeout > 0) {
            [self setupCycleTimeOut:timeout - 1 callBack:callBack];
        }
    });
    if (callBack) {
        callBack(timeout);
    }
}

// MARK: - 🌈🌈🌈 GuidePage
+ (void)setupGuidePage {
    KLGuidePage *page = [KLGuidePage pageWithStyle:KLGuideStyleTranslationFade dataSource:LaunchCommand.shareInstance];
    page.hideForLastPage = YES;
    page.alphaMultiple = 1.5;
    page.duration = 0.5;
    page.bottomlHeight = 50;
    page.bottomSpace = 50;
    page.bottomControl.pageIndicatorTintColor = [UIColor.redColor colorWithAlphaComponent:0.3];
    page.bottomControl.currentPageIndicatorTintColor = UIColor.redColor;
    [page registerClass:AppGuideCell.class forCellWithReuseIdentifier:AppGuideCell.description];
}

- (NSArray *)dataOfItems {
    return @[[UIImage imageNamed:@"Guide-0"], [UIImage imageNamed:@"Guide-1"], [UIImage imageNamed:@"Guide-2"]];
}

- (UICollectionViewCell *)guidePage:(KLGuidePage *)page data:(id)data cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    AppGuideCell *cell = (AppGuideCell *)[page dequeueReusableCellWithReuseIdentifier:AppGuideCell.description forIndexPath:indexPath];
    cell.imageView.image = data;
    cell.titleLabel.text = @[@"欢迎使用京东", @"请授权位置信息权限", @"获取最新的促销信息"][indexPath.row];
    cell.subTitleLabel.text = @[@"正品低价、急速配送\n点缀您的品质生活", @"获取周边库存信息和周边服务、推送专属\n商品与优惠", @"随时了解促销信息，掌握实时物流动态\n请\"允许\"京东获取消息通知权限"][indexPath.row];
    cell.entryBtn.hidden = indexPath.row != self.dataOfItems.count - 1;
    
    __weak typeof(page) weakpage = page;
    cell.entryBlock = ^{
        [weakpage hideWithStyle:KLGuideHideStyleNomal animated:YES]; // 移除引导页
        KLSetFirstLaunch(); // 记录启动版本
        _instance = nil;    // 释放辅助单例
    };

    return cell;
}

// KLGuideStyleFade 需要单独实现这个装载图片的视图
- (UIView *)guidePage:(KLGuidePage *)page data:(id)data viewForItemAtIndexPath:(NSIndexPath *)indexPath {
    UIImageView *imageView = UIImageView.alloc.init;
    imageView.image = data;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    return imageView;
}

// MARK: - 🌈🌈🌈 Version Update
+ (void)setupVersionUpdateToView:(UIView *)view {
    [KLNetworkModule.shareManager sendRequestWithConfigBlock:^(KLNetworkRequest * _Nullable request) {
        request.baseURL = KLConsole.addressConfigs.firstObject.details[KLConsole.addressConfigs.firstObject.selectedIndex].text;
        request.path = @"/app/appversion/getAppVersionByType";
        request.method = KLNetworkRequestMethodPOST;
        request.normalParams = @{@"type" : @"ios"};
    } complete:^(KLNetworkResponse * _Nullable response) {
        if (response.status == KLNetworkResponseStatusSuccess) {
            // 最新版本
            NSString *version = [response.data valueForKey:@"version_no"];
            // 更新描述
            NSString *descriptions = [response.data valueForKey:@"introduce"];
            // 是否强更
            NSString *forced = [response.data valueForKey:@"forced_flag"];
            // 跳转地址
            NSString *url = [response.data valueForKey:@"url"];
            
            NSString *appVersion = [NSBundle.mainBundle.infoDictionary objectForKey:@"CFBundleShortVersionString"];
            if ([appVersion compare:version options:NSNumericSearch] == NSOrderedAscending) {
                if ([[NSUserDefaults.standardUserDefaults valueForKey:AppVersionUpdate.description] isEqualToString:version]) return;
                [AppVersionUpdate updateToView:view withVersion:version descriptions:descriptions toURL:url forced:forced.boolValue cancleHandler:^{
                    [NSUserDefaults.standardUserDefaults setValue:version forKey:AppVersionUpdate.description]; // 记录忽略版本
                    [NSUserDefaults.standardUserDefaults synchronize];
                }];
            }
        }
    }];
}

@end

//
//  AppLaunch.m
//  Objective-C
//
//  Created by Logic on 2020/6/1.
//  Copyright © 2020 Kalan. All rights reserved.
//

#import "AppLaunch.h"


// MARK: - KLGuideCustomCell
@interface KLGuideCustomCell : UICollectionViewCell

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *subTitleLabel;
@property (strong, nonatomic) UIButton *entryBtn;

@property (copy  , nonatomic) void (^entryBlock)(void);

@end

@implementation KLGuideCustomCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = UIImageView.alloc.init;
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:self.imageView];
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
        
        self.titleLabel = UILabel.new;
        self.titleLabel.textColor = UIColor.blackColor;
        self.titleLabel.font = [UIFont boldSystemFontOfSize:25];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.centerY.mas_equalTo(self.contentView.mas_centerY).multipliedBy(1.3);
        }];
        
        self.subTitleLabel = UILabel.new;
        self.subTitleLabel.textColor = [UIColor.blackColor colorWithAlphaComponent:0.6];
        self.subTitleLabel.font = [UIFont systemFontOfSize:16];
        self.subTitleLabel.numberOfLines = 0;
        self.subTitleLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.subTitleLabel];
        [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(15);
        }];
        
        self.entryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.entryBtn.backgroundColor = UIColor.redColor;
        self.entryBtn.layer.cornerRadius = 9;
        self.entryBtn.clipsToBounds = YES;
        [self.entryBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [self.entryBtn setTitle:@"立即体验" forState:UIControlStateNormal];
        [self.contentView addSubview:self.entryBtn];
        [self.entryBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(200);
            make.height.mas_equalTo(50);
            make.centerX.mas_equalTo(0);
            make.bottom.mas_equalTo(-50);
        }];
        
        [self.entryBtn addTarget:self action:@selector(entryBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)entryBtnClick:(UIButton *)sender {
    if (self.entryBlock) {
        self.entryBlock();
    }
}

@end

// MARK: - AppLaunch
@interface AppLaunch () <KLGuidePageDataSource>

@end

@implementation AppLaunch

static dispatch_once_t _onceToken;
static AppLaunch *_instance;

// 创建单例
+ (instancetype)shareLaunch {
    dispatch_once(&_onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

// 释放单例
+ (void)launchClear {
    _onceToken = 0;
    _instance = nil;
}

// MARK: - RootViewController
+ (void)setupRootViewControllerWithWindow:(UIWindow *)window {
    // MARK: 选项卡入口配置
    NSArray *controllers =
    @[[NavigationController navigationWithRootViewController:[KLServer.sharedServer fetchHomeController:nil]
                                                         title:@"闲鱼" image:@"tab0-n" selectedImage:@"tab0-s"],
      [NavigationController navigationWithRootViewController:[KLServer.sharedServer fetchHomeController:nil]
                                                         title:@"鱼塘" image:@"tab1-n" selectedImage:@"tab1-s"],
      [NavigationController navigationWithRootViewController:[KLServer.sharedServer fetchHomeController:nil]
                                                         title:@"发布" image:@"tab2-n" selectedImage:@"tab2-n"],
      [NavigationController navigationWithRootViewController:[KLServer.sharedServer fetchHomeController:nil]
                                                         title:@"消息" image:@"tab3-n" selectedImage:@"tab3-s"],
      [NavigationController navigationWithRootViewController:[KLServer.sharedServer fetchHomeController:nil]
                                                         title:@"我的" image:@"tab4-n" selectedImage:@"tab4-s"]];
    TabBarController *vc = [TabBarController tabBarWithControllers:controllers];
    
    // 控制台调用
    vc.swipeTabBarCallBack = ^(UISwipeGestureRecognizer * _Nonnull swipe) {
        #ifdef DEBUG
        [AppLaunch launchDebugTool];
        #endif
    };
    
    // MARK: 导航栏全局设置
    [NavigationController setAppearanceTincolor:UIColor.blackColor];
    [NavigationController setAppearanceBarTincolor:UIColor.whiteColor];
    [NavigationController setAppearanceBackIndicatorImage:[UIImage imageNamed:@"back"]];
    
    // MARK: 选项卡全局设置
    // 设置阴影线颜色，当只有设置了背景图后才生效
    [vc setTabBarShadowLineColor:UIColor.clearColor];
    // 设置背景图片
    [vc setTabBarBackgroundImageWithColor:UIColor.whiteColor];
    // 设置文字样式
    [vc setTabBarItemTitleTextAttributes:@{NSForegroundColorAttributeName : UIColor.blackColor,
                                           NSFontAttributeName : [UIFont systemFontOfSize:10]}
                                forState:UIControlStateNormal];
    [vc setTabBarItemTitleTextAttributes:@{NSForegroundColorAttributeName : UIColor.blackColor,
                                           NSFontAttributeName : [UIFont systemFontOfSize:10]}
                                forState:UIControlStateHighlighted];
    // 设置文字位置偏移量
    [vc setTabBarItemTitlePositionAdjustment:(UIOffset){0, -2} forState:UIControlStateNormal];
    [vc setTabBarItemTitlePositionAdjustment:(UIOffset){0, -2} forState:UIControlStateSelected];
    
    // 设置中间凸起按钮
    [vc setupCustomAreaView];
    
    // 设置主窗口
    window.rootViewController = vc;
    [window makeKeyAndVisible];
}

// MARK: - DebugTool
+ (void)setupDebugTool {
    // MARK: 环境初始化
    [KLConsole consoleAddressSetup:^(NSMutableArray<KLConsoleSecondConfig *> *configs) {
        KLConsoleSecondConfig *serviceA = KLConsoleSecondConfig.alloc.init;
        serviceA.version = @"1.0";
        serviceA.title = @"商城服务域名";
        serviceA.subtitle = @"https://www.example.com/prod";
        serviceA.selectedIndex = 0;
        
        KLConsoleThreeConfig *serviceAa = KLConsoleThreeConfig.alloc.init;
        serviceAa.title = @"生产环境";
        serviceAa.text = @"https://www.example.com/prod";
        KLConsoleThreeConfig *serviceAb = KLConsoleThreeConfig.alloc.init;
        serviceAb.title = @"开发环境";
        serviceAb.text = @"https://www.example.com/dev";
        KLConsoleThreeConfig *serviceAc = KLConsoleThreeConfig.alloc.init;
        serviceAc.title = @"测试环境";
        serviceAc.text = @"https://www.example.com/test";
        KLConsoleThreeConfig *serviceAd = KLConsoleThreeConfig.alloc.init;
        serviceAd.title = @"预发布环境";
        serviceAd.text = @"https://www.example.com/stadge";
        serviceA.details = @[serviceAa, serviceAb, serviceAc, serviceAd];
        [configs addObject:serviceA];
        
        KLConsoleSecondConfig *serviceB = KLConsoleSecondConfig.alloc.init;
        serviceB.version = @"1.0";
        serviceB.title = @"商城H5服务域名";
        serviceB.subtitle = @"https://www.example.com/prod1";
        serviceB.selectedIndex = 0;
        
        KLConsoleThreeConfig *serviceBa = KLConsoleThreeConfig.alloc.init;
        serviceBa.title = @"生产环境";
        serviceBa.text = @"https://www.example.com/prod1";
        KLConsoleThreeConfig *serviceBb = KLConsoleThreeConfig.alloc.init;
        serviceBb.title = @"开发环境";
        serviceBb.text = @"https://www.example.com/dev1";
        KLConsoleThreeConfig *serviceBc = KLConsoleThreeConfig.alloc.init;
        serviceBc.title = @"测试环境";
        serviceBc.text = @"https://www.example.com/test1";
        KLConsoleThreeConfig *serviceBd = KLConsoleThreeConfig.alloc.init;
        serviceBd.title = @"预发布环境";
        serviceBd.text = @"https://www.example.com/stadge1";
        serviceB.details = @[serviceBa, serviceBb, serviceBc, serviceBd];
        [configs addObject:serviceB];
    }];
    
    // MAKR: 扩展功能
    [KLConsole consoleSetup:^(NSMutableArray<KLConsoleConfig *> * _Nonnull configs) {
        KLConsoleConfig *serverA = KLConsoleConfig.alloc.init;
        serverA.title = @"功能测试";
        
        KLConsoleSecondConfig *serviceA = KLConsoleSecondConfig.alloc.init;
        serviceA.title = @"版本升级测试";
        serviceA.subtitle = @"点击获取最新版本";
        
        KLConsoleSecondConfig *serviceB = KLConsoleSecondConfig.alloc.init;
        serviceB.title = @"启动页测试";
        serviceB.subtitle = @"点击查看";
        
        KLConsoleSecondConfig *serviceC = KLConsoleSecondConfig.alloc.init;
        serviceC.title = @"引导页测试";
        serviceC.subtitle = @"点击查看";
        
        serverA.infos = @[serviceA, serviceB, serviceC];
        [configs addObject:serverA];
    }];
}

+ (void)launchDebugTool {
    [KLConsole consoleSetupAndSelectedCallBack:^(NSIndexPath * _Nonnull indexPath, BOOL switchOn) {
        // 扩展功能回调
        switch (indexPath.row) {
            case 0:
                [self setupVersionUpdate];
                break;
            case 1:
                [self setupLaunchImage];
                break;
            case 2:
                [self setupGuidePage];
                break;
            default:
                break;
        }
    }];
}

// MARK: - LaunchScreen
+ (void)setupLaunchImage {
    // MARK: 自定义布局
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"LaunchScreen" bundle:nil];
    UIViewController *launchVc = [story instantiateViewControllerWithIdentifier:@"LaunchScreen"];
    [UIApplication.sharedApplication.keyWindow addSubview:launchVc.view];
    
    // LaunchScreen 无法使用自定义控件、属性，提供容器，由外部进行个性化处理
    UIView *content = [launchVc.view viewWithTag:999]; // 自定义容器
    content.userInteractionEnabled = YES;
    KLImageView *imageHandler = KLImageView.alloc.init;
    [content addSubview:imageHandler];
    [imageHandler mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    // 添加倒计时控件
    UIButton *timeHandler = [UIButton buttonWithType:UIButtonTypeCustom];
    timeHandler.titleLabel.font = [UIFont systemFontOfSize:11];
    timeHandler.layer.cornerRadius = 10;
    timeHandler.layer.masksToBounds = YES;
    timeHandler.hidden = YES;
    [timeHandler setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
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
        make.height.mas_equalTo(20);
    }];
    
    // 广告点击跳转
    [imageHandler kl_setTapCompletion:^(UITapGestureRecognizer *tapGesture) {
        NSLogDebug(@"广告图片点击");
        UIViewController *vc = UIViewController.new;
        vc.view.backgroundColor = UIColor.kl_randomColor;
        [(UINavigationController *)UIApplication.sharedApplication.keyWindow.rootViewController.childViewControllers.firstObject pushViewController:vc animated:YES];
        [self skipLaunchScreen:timeHandler];
    }];
    
    // 按钮点击跳过
    [timeHandler kl_controlEvents:UIControlEventTouchUpInside completion:^(UIButton * _Nonnull sender) {
        [self skipLaunchScreen:timeHandler];
    }];
    
    // MARK: 网络获取广告信息
    NSString *url = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1589991864305&di=c6d607d12b111cb51a70132b7abc4b9a&imgtype=0&src=http%3A%2F%2F5b0988e595225.cdn.sohucs.com%2Fimages%2F20180628%2F7c9e6065e61d4c4ab905bf45f7e87f06.gif";

    // MARK: 根据获取广告的结果，设计交互逻辑
    [imageHandler kl_setImageWithURL:[NSURL URLWithString:url ? : @""] placeholder:nil options:KLWebImageOptionProgressiveBlur completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, KLWebImageFromType from, KLWebImageStage stage, NSError * _Nullable error) {
        // 跳过按钮开关
        timeHandler.hidden = image == nil;
        // 广告交互开关
        imageHandler.userInteractionEnabled = image != nil;
        // 倒计时
        [self setupCycleTimeOut:image == nil ? 1 : 3 callBack:^(NSTimeInterval time) {
            if (time == 0) {
                [self skipLaunchScreen:timeHandler];
            } else {
                if (image) [timeHandler setTitle:[NSString stringWithFormat:@"跳过广告 %@", @(time)] forState:UIControlStateNormal];
            }
        }];
    }];
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

// MARK: - GuidePage
+ (void)setupGuidePage {
    KLGuidePage *page = [KLGuidePage pageWithStyle:KLGuideStyleFade dataSource:AppLaunch.shareLaunch];
    page.hideForLastPage = YES;
    page.alphaMultiple = 1.5;
    page.duration = 0.5;
    page.bottomlHeight = 50;
    page.bottomSpace = 50;
    page.bottomControl.pageIndicatorTintColor = [UIColor.redColor colorWithAlphaComponent:0.3];
    page.bottomControl.currentPageIndicatorTintColor = UIColor.redColor;
    [page registerClass:KLGuideCustomCell.class forCellWithReuseIdentifier:KLGuideCustomCell.description];
}

- (NSArray *)dataOfItems {
    return @[[UIImage imageNamed:@"Guide-0"], [UIImage imageNamed:@"Guide-1"], [UIImage imageNamed:@"Guide-2"]];
}

- (UICollectionViewCell *)guidePage:(KLGuidePage *)page data:(id)data cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    KLGuideCustomCell *cell = (KLGuideCustomCell *)[page dequeueReusableCellWithReuseIdentifier:KLGuideCustomCell.description forIndexPath:indexPath];
//    cell.imageView.image = data;
    cell.titleLabel.text = @[@"欢迎使用京东", @"请授权位置信息权限", @"获取最新的促销信息"][indexPath.row];
    cell.subTitleLabel.text = @[@"正品低价、急速配送\n点缀您的品质生活", @"获取周边库存信息和周边服务、推送专属\n商品与优惠", @"随时了解促销信息，掌握实时物流动态\n请\"允许\"京东获取消息通知权限"][indexPath.row];
    cell.entryBtn.hidden = indexPath.row != self.dataOfItems.count - 1;
    
    __weak typeof(page) weakpage = page;
    cell.entryBlock = ^{
        [weakpage hideWithStyle:KLGuideHideStyleNomal animated:YES]; // 移除引导页
        [AppLaunch launchClear]; // 释放单例
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

// MARK: - Version Update
+ (void)setupVersionUpdate {
    [KLNetworkModule.shareManager sendRequestWithConfigBlock:^(KLNetworkRequest * _Nullable request) {
        request.baseURL = @"https://api.galanz.com/prod/app/appversion/getAppVersionByType";
        request.method = KLNetworkRequestMethodPOST;
        request.normalParams = @{@"type" : @"ios"};
    } complete:^(KLNetworkResponse * _Nullable response) {
        if (response.status == KLNetworkResponseStatusSuccess) {
            // 最新版本
            NSString *version = [response.data valueForKey:@"version_no"];
            // 更新描述
            NSString *descrip = [response.data valueForKey:@"introduce"];
            // 是否强更
            NSString *forced = [response.data valueForKey:@"forced_flag"];
            // 跳转地址
            NSString *url = [response.data valueForKey:@"url"];
            
            NSString *appVersion = [NSBundle.mainBundle.infoDictionary objectForKey:@"CFBundleShortVersionString"];
            if ([appVersion compare:version options:NSNumericSearch] == NSOrderedAscending) {
                // 有新的版本需要更新
                NSLogSuccess(@"\n最新版本：%@\n更新描述：%@\n是否强更：%@\n跳转地址：%@", version, descrip, forced, url);
            }
        }
    }];
    
    KLNetworkConfigure.shareInstance.enableDebug = YES;
}

@end

//
//  AppDelegate+Launch.m
//  Objective-C
//
//  Created by Logic on 2020/5/21.
//  Copyright © 2020 Kalan. All rights reserved.
//

#import "AppDelegate+Launch.h"
#import "TabBarController.h"
#import "NavigationController.h"
@import KLApplicationEntry;
@import KLConsole;
@import KLHomeServiceInterface;
@import KLImageView;

@implementation AppDelegate (Launch)

+ (UIViewController *)setupRootViewController {
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
    
    // MARK: - 导航栏全局设置
    [NavigationController setAppearanceTincolor:UIColor.blackColor];
    [NavigationController setAppearanceBarTincolor:UIColor.whiteColor];
    [NavigationController setAppearanceBackIndicatorImage:[UIImage imageNamed:@"back"]];
    
    // MARK: - 选项卡全局设置
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
    // 设置凸起图片高度
    [vc setTabBarItemImageEdgeInsets:(UIEdgeInsets){-17,0,17,0} atIndex:2];
    // 增加一个凸起点击区域
    [vc setTabBarRespondAreaAtIndex:2 height:0];
    
    // 控制台调用
    vc.swipeTabBarCallBack = ^(UISwipeGestureRecognizer * _Nonnull swipe) {
        #ifdef DEBUG
        [AppDelegate launchDebugTool];
        #endif
    };
    
    return vc;
}

+ (void)setupDebugTool {
    // MAKR: 扩展功能
    [KLConsole consoleSetup:^(NSMutableArray<KLConsoleConfig *> * _Nonnull configs) {
        KLConsoleConfig *serverA = KLConsoleConfig.alloc.init;
        serverA.title = @"功能测试";
        
        KLConsoleSecondConfig *serviceA = KLConsoleSecondConfig.alloc.init;
        serviceA.title = @"H5访问测试";
        serviceA.subtitle = @"点击输入链接访问";
        
        KLConsoleSecondConfig *serviceB = KLConsoleSecondConfig.alloc.init;
        serviceB.title = @"引导页测试";
        serviceB.subtitle = @"点击查看";
        
        serverA.infos = @[serviceA, serviceB];
        [configs addObject:serverA];
    }];
    
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
}

+ (void)launchDebugTool {
    [KLConsole consoleSetupAndSelectedCallBack:^(NSIndexPath * _Nonnull indexPath, BOOL switchOn) {
        // 扩展功能回调
        switch (indexPath.row) {
            case 0:
                NSLog(@"H5访问测试~");
                break;
            case 1:
                NSLog(@"引导页测试~");
                break;
            default:
                break;
        }
    }];
}

+ (void)setupLaunchImage {
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"LaunchScreen" bundle:nil];
    UIViewController *launchVc = [story instantiateViewControllerWithIdentifier:@"LaunchScreen"];
    [UIApplication.sharedApplication.keyWindow addSubview:launchVc.view];
    
    // 添加支持动效的图片控件
    UIView *content = [launchVc.view viewWithTag:999];
    KLImageView *imageView = KLImageView.alloc.init;
    [content addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    // 添加倒计时控件
    UIButton *timeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    timeBtn.titleLabel.font = [UIFont systemFontOfSize:11];
    timeBtn.layer.cornerRadius = timeBtn.bounds.size.height * 0.5;
    timeBtn.layer.masksToBounds = YES;
    timeBtn.hidden = YES;
    [timeBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [timeBtn setTitleEdgeInsets:(UIEdgeInsets){0,13,0,-13}];
    [timeBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [content addSubview:timeBtn];
    [timeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.mas_equalTo(UIApplication.sharedApplication.keyWindow.safeAreaInsets.top);
        } else {
            make.top.mas_equalTo(25);
        }
        make.right.mas_equalTo(-15);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(22);
    }];
    
    // 至少显示1s
    sleep(1);
    
    NSString *url = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1589991864305&di=c6d607d12b111cb51a70132b7abc4b9a&imgtype=0&src=http%3A%2F%2F5b0988e595225.cdn.sohucs.com%2Fimages%2F20180628%2F7c9e6065e61d4c4ab905bf45f7e87f06.gif";
    [imageView kl_setImageWithURL:[NSURL URLWithString:url] placeholder:nil options:KLWebImageOptionProgressiveBlur completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, KLWebImageFromType from, KLWebImageStage stage, NSError * _Nullable error) {

        timeBtn.hidden = NO;
        [timeBtn setTitle:[NSString stringWithFormat:@"跳过广告 %@", @(3)] forState:UIControlStateNormal];
        [self setupCycleTimeOut:3 callBack:^(NSTimeInterval time) {
            [timeBtn setTitle:[NSString stringWithFormat:@"跳过广告 %@", @(time)] forState:UIControlStateNormal];
            
            if (time == 0) {
                [UIView animateWithDuration:0.75 delay:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    launchVc.view.alpha = 0;
                    launchVc.view.transform = CGAffineTransformMakeScale(2, 2);
                } completion:^(BOOL finished) {
                    [launchVc.view removeFromSuperview];
                }];
            }
        }];
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

+ (void)setupVersionUpdate {
    
}

@end

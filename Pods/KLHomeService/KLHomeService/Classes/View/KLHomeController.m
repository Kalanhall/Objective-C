//
//  KLHomeController.m
//  KLHomeService
//
//  Created by Logic on 2019/11/29.
//

#import "KLHomeController.h"
@import Masonry;
@import KLCategory;
@import KLNavigationController;

@interface KLHomeController ()

@end

@implementation KLHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"首页";
    self.view.backgroundColor = UIColor.whiteColor;
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem.alloc initWithTitle:@"Push" style:(UIBarButtonItemStylePlain) target:self action:@selector(push)];
}

- (void)push {
    KLHomeController *vc = KLHomeController.new;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

@end

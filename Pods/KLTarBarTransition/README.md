# KLTarBarTransition

[![CI Status](https://img.shields.io/travis/Kalanhall@163.com/KLTarBarTransition.svg?style=flat)](https://travis-ci.org/Kalanhall@163.com/KLTarBarTransition)
[![Version](https://img.shields.io/cocoapods/v/KLTarBarTransition.svg?style=flat)](https://cocoapods.org/pods/KLTarBarTransition)
[![License](https://img.shields.io/cocoapods/l/KLTarBarTransition.svg?style=flat)](https://cocoapods.org/pods/KLTarBarTransition)
[![Platform](https://img.shields.io/cocoapods/p/KLTarBarTransition.svg?style=flat)](https://cocoapods.org/pods/KLTarBarTransition)

## Example

```ruby

#import <KLTabBarTransitionDelegate.h>

@implementation TabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    KLTabBarTransitionDelegate *delegate = KLTabBarTransitionDelegate.alloc.init;
    delegate.tabBarItemScaleEnable = YES;       // item缩放动画开关
    delegate.panGestureRecongizerEnable = YES;  // 页面侧滑动画开关，默认当TabBar显示时，页面才可以侧滑
    delegate.tabBarController = self;           // 转场TabBarController
    self.delegate = delegate;
}

@end

```

## Requirements

## Installation

KLTarBarTransition is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'KLTarBarTransition'
```

## Author

Kalanhall, Kalanhall@163.com

## License

KLTarBarTransition is available under the MIT license. See the LICENSE file for more info.

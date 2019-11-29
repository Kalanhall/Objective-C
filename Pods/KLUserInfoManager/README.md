# KLUserInfoManager

[![CI Status](https://img.shields.io/travis/Kalanhall@163.com/KLUserInfoManager.svg?style=flat)](https://travis-ci.org/Kalanhall@163.com/KLUserInfoManager)
[![Version](https://img.shields.io/cocoapods/v/KLUserInfoManager.svg?style=flat)](https://cocoapods.org/pods/KLUserInfoManager)
[![License](https://img.shields.io/cocoapods/l/KLUserInfoManager.svg?style=flat)](https://cocoapods.org/pods/KLUserInfoManager)
[![Platform](https://img.shields.io/cocoapods/p/KLUserInfoManager.svg?style=flat)](https://cocoapods.org/pods/KLUserInfoManager)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

```ruby

这是一个用户信息管理类，你可以新建你用户信息模型，例如 KLUserInfoSub

使用1
NSDictionary *param = @{ @"username" : @"My Name." };
KLUserInfoSub *userInfo = [KLUserInfoSub kl_modelWithDictionary:param];
userInfo.username = @"I am another name.";
[KLUserInfoManager.shareManager updateObject:userInfo];
进行本地数据插入或者更新

使用2
[KLUserInfoManager.shareManager removeObject];
进行本地数据移除

使用3
KLUserInfoSub *object = (KLUserInfoSub *)KLUserInfoManager.shareManager.object;
获取本地数据


当然，在组件化过程中，你不应该继承 KLUserInfo 模型类，而是维护该组件，在KLUserInfo类中新增你需要的属性。

```

## Requirements

## Installation

KLUserInfoManager is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'KLUserInfoManager'
```

## Author

Kalanhall@163.com, wujm002@galanz.com

## License

KLUserInfoManager is available under the MIT license. See the LICENSE file for more info.

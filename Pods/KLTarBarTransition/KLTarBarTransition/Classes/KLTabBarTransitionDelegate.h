/*
 Copyright (C) 2016 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 The delegate of the tab bar controller for the Slide demo.  Manages the
  gesture recognizer used for the interactive transition.  Vends
  instances of KLTabBarTransitionAnimator and 
  KLTabBarTransitionInteractionController.
 */

@import UIKit;

@interface KLTabBarTransitionDelegate : NSObject <UITabBarControllerDelegate>

// 应用TabBarController实例
@property (nonatomic, weak) UITabBarController *tabBarController;
// 侧滑手势
@property (nonatomic, strong, readonly) UIPanGestureRecognizer *panGestureRecongizer;
// 侧滑手势开关，默认NO
@property (nonatomic, assign) BOOL panGestureRecongizerEnable;
// TabBarItem图标缩放动画开关，默认NO
@property (nonatomic, assign) BOOL tabBarItemScaleEnable;

/** UITabBarControllerDelegate Block */
@property (nonatomic, copy) void (^tabBarDidSelectViewController)(UITabBarController *tabBarController, UIViewController *viewController);
@property (nonatomic, copy) BOOL (^tabBarShouldSelectViewController)(UITabBarController *tabBarController, UIViewController *viewController);

@end

/*
 Copyright (C) 2016 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 The delegate of the tab bar controller for the Slide demo.  Manages the
  gesture recognizer used for the interactive transition.  Vends
  instances of KLTabBarTransitionAnimator and 
  KLTabBarTransitionInteractionController.
 */

#import "KLTabBarTransitionDelegate.h"
#import "KLTabBarTransitionAnimator.h"
#import "KLTabBarTransitionInteractionController.h"
#import <objc/runtime.h>
#import "UITabBarController+KLAnimating.h"

const char * KLTabBarTransitionControllerDelegateAssociationKey = "KLTabBarTransitionControllerDelegateAssociation";

@interface KLTabBarTransitionDelegate ()

@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic, strong) KLTabBarTransitionAnimator *currentAnimator;

@end


@implementation KLTabBarTransitionDelegate

- (void)setTabBarController:(UITabBarController *)tabBarController
{
    if (tabBarController != _tabBarController) {
        objc_setAssociatedObject(_tabBarController, KLTabBarTransitionControllerDelegateAssociationKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [_tabBarController.view removeGestureRecognizer:self.panGestureRecognizer];
        if (_tabBarController.delegate == self) _tabBarController.delegate = nil;
        
        _tabBarController = tabBarController;
        
        _tabBarController.delegate = self;
        objc_setAssociatedObject(_tabBarController, KLTabBarTransitionControllerDelegateAssociationKey, self, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        [_tabBarController.view addGestureRecognizer:self.panGestureRecognizer];
    }
}

#pragma mark Gesture Recognizer
- (UIPanGestureRecognizer*)panGestureRecognizer
{
    if (_panGestureRecognizer == nil) {
        _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizerDidPan:)];
        _panGestureRecognizer.enabled = NO;
    }
    return _panGestureRecognizer;
}

- (void)panGestureRecognizerDidPan:(UIPanGestureRecognizer*)sender
{
    if (self.tabBarController.transitionCoordinator || self.tabBarController.tabBar.hidden )
        return;
    
    if (sender.state == UIGestureRecognizerStateBegan || sender.state == UIGestureRecognizerStateChanged)
        [self beginInteractiveTransitionIfPossible:sender];
}

- (void)beginInteractiveTransitionIfPossible:(UIPanGestureRecognizer *)sender
{
    CGPoint translation = [sender translationInView:self.tabBarController.view];
    
    if (translation.x > 0.f && self.tabBarController.selectedIndex > 0) {
        // Panning right, transition to the left view controller.
        self.tabBarController.selectedIndex--;
    } else if (translation.x < 0.f && self.tabBarController.selectedIndex + 1 < self.tabBarController.viewControllers.count) {
        // Panning left, transition to the right view controller.
        self.tabBarController.selectedIndex++;
    }
    
    [self.tabBarController.transitionCoordinator animateAlongsideTransition:NULL completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        if ([context isCancelled] && sender.state == UIGestureRecognizerStateChanged)
            [self beginInteractiveTransitionIfPossible:sender];
    }];
}

#pragma mark UITabBarControllerDelegate
- (id<UIViewControllerAnimatedTransitioning>)tabBarController:(UITabBarController *)tabBarController animationControllerForTransitionFromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    NSAssert(tabBarController == self.tabBarController, @"%@ is not the tab bar controller currently associated with %@", tabBarController, self);
    NSArray *viewControllers = tabBarController.viewControllers;
    
    if ([viewControllers indexOfObject:toVC] > [viewControllers indexOfObject:fromVC]) {
        self.currentAnimator = [[KLTabBarTransitionAnimator alloc] initWithTargetEdge:UIRectEdgeLeft];
    } else {
        self.currentAnimator = [[KLTabBarTransitionAnimator alloc] initWithTargetEdge:UIRectEdgeRight];
    }
    return self.currentAnimator;
}

- (id<UIViewControllerInteractiveTransitioning>)tabBarController:(UITabBarController *)tabBarController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController
{
    NSAssert(tabBarController == self.tabBarController, @"%@ is not the tab bar controller currently associated with %@", tabBarController, self);
    
    if (self.panGestureRecognizer.state == UIGestureRecognizerStateBegan || self.panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        return [[KLTabBarTransitionInteractionController alloc] initWithGestureRecognizer:self.panGestureRecognizer];
    } else {
        return nil;
    }
}

- (UIControl *)currentButton
{
    NSMutableArray *tabBarButtons = [[NSMutableArray alloc]initWithCapacity:0];
    for (UIView *tabBarButton in self.tabBarController.tabBar.subviews) {
        if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            [tabBarButtons addObject:tabBarButton];
        }
    }
    return [tabBarButtons objectAtIndex:self.tabBarController.selectedIndex];
}

- (void)setPanGestureRecongizerEnable:(BOOL)panGestureRecongizerEnable {
    _panGestureRecongizerEnable = panGestureRecongizerEnable;
    self.panGestureRecognizer.enabled = self.panGestureRecongizerEnable;
}

// MARK: - UITabBarControllerDelegate
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    
    if (self.tabBarShouldSelectViewController) {
        return !self.tabBarController.isAnimating && self.tabBarShouldSelectViewController(tabBarController, viewController);
    }
    return !self.tabBarController.isAnimating;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    self.tabBarController.isAnimating = YES;
    
    if (self.tabBarItemScaleEnable) {
        for (UIView *imageView in [self currentButton].subviews) {
            if ([imageView isKindOfClass:NSClassFromString(@"UITabBarSwappableImageView")]) {
                CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
                animation.keyPath = @"transform.scale";
                animation.values = @[@1.0,@1.1,@0.9,@1.0];
                animation.duration = self.currentAnimator.transitionTime;
                animation.calculationMode = kCAAnimationCubic;
                [imageView.layer addAnimation:animation forKey:nil];
            }
        }
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.currentAnimator.transitionTime * 1.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.tabBarController.isAnimating = NO;
    });
    
    if (self.tabBarDidSelectViewController) {
        self.tabBarDidSelectViewController(tabBarController, viewController);
    }
}

@end

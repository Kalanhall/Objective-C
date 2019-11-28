/*
 Copyright (C) 2016 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 The interaction controller for the Slide demo.
 */

#import "KLTabBarTransitionInteractionController.h"

@interface KLTabBarTransitionInteractionController ()

@property (nonatomic, weak) id<UIViewControllerContextTransitioning> transitionContext;
@property (nonatomic, strong, readonly) UIPanGestureRecognizer *gestureRecognizer;
@property (nonatomic, readwrite) CGPoint initialLocationInContainerView;
@property (nonatomic, readwrite) CGPoint initialTranslationInContainerView;

@end


@implementation KLTabBarTransitionInteractionController

- (instancetype)initWithGestureRecognizer:(UIPanGestureRecognizer *)gestureRecognizer
{
    self = [super init];
    if (self)
    {
        _gestureRecognizer = gestureRecognizer;
        [_gestureRecognizer addTarget:self action:@selector(gestureRecognizeDidUpdate:)];
    }
    return self;
}

- (instancetype)init
{
    @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"Use -initWithGestureRecognizer:" userInfo:nil];
}

- (void)dealloc
{
    [self.gestureRecognizer removeTarget:self action:@selector(gestureRecognizeDidUpdate:)];
}

- (void)startInteractiveTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    // Save the transitionContext, initial location, and the translation within
    // the containing view.
    self.transitionContext = transitionContext;
    self.initialLocationInContainerView = [self.gestureRecognizer locationInView:transitionContext.containerView];
    self.initialTranslationInContainerView = [self.gestureRecognizer translationInView:transitionContext.containerView];
    
    [super startInteractiveTransition:transitionContext];
}

//! Returns the offset of the pan gesture recognizer from its initial location
- (CGFloat)percentForGesture:(UIPanGestureRecognizer *)gesture
{
    UIView *transitionContainerView = self.transitionContext.containerView;
    CGPoint translationInContainerView = [gesture translationInView:transitionContainerView];
    
    if ((translationInContainerView.x > 0.f && self.initialTranslationInContainerView.x < 0.f) ||
        (translationInContainerView.x < 0.f && self.initialTranslationInContainerView.x > 0.f))
        return -1.f;
    
    // Figure out what percentage we've traveled.
    return fabs(translationInContainerView.x) / CGRectGetWidth(transitionContainerView.bounds);
}


// Action method for the gestureRecognizer.
- (void)gestureRecognizeDidUpdate:(UIScreenEdgePanGestureRecognizer *)gestureRecognizer
{
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
            break;
        case UIGestureRecognizerStateChanged:
            if ([self percentForGesture:gestureRecognizer] < 0.f) {
                [self cancelInteractiveTransition];
                [self.gestureRecognizer removeTarget:self action:@selector(gestureRecognizeDidUpdate:)];
            } else {
                [self updateInteractiveTransition:[self percentForGesture:gestureRecognizer]];
            }
            break;
        case UIGestureRecognizerStateEnded:
            if ([self percentForGesture:gestureRecognizer] >= 0.4f)
                [self finishInteractiveTransition];
            else
                [self cancelInteractiveTransition];
            break;
        default:
            [self cancelInteractiveTransition];
            break;
    }
}

@end

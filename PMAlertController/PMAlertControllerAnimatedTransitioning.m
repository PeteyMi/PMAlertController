//
//  PMAlertControllerAnimatedTransitioning.m
//  PMAlertControllerDemo
//
//  Created by Petey Mi on 2021/7/29.
//

#import "PMAlertControllerAnimatedTransitioning.h"

#define PM_TRANSITION_DURATION      0.3

@implementation PMAlertControllerAnimatedTransitioning {
    PMAlertControllerStyle  _controllerStyle;
    UIView      *_backgroundView;
}

- (instancetype)initWithControllerStyle:(PMAlertControllerStyle)controllerStyle {
    if (self = [super init]) {
        _controllerStyle = controllerStyle;
    }
    return self;
}

- (UIView*)backgroundView {
    if (_backgroundView == nil) {
        _backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
        _backgroundView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.3];
    }
    return _backgroundView;
}

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
    return PM_TRANSITION_DURATION;
}
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    if (_controllerStyle == PMAlertControllerStyleAlert) {
        [self alertAnimateTransition:transitionContext];
    } else if (_controllerStyle == PMAlertControllerStyleActionSheet) {
        [self sheetAnimateTransition:transitionContext];
    }
}

- (CGFloat)bottomSafeArea {
    if (@available(iOS 11.0, *)) {
        return [UIApplication sharedApplication].keyWindow.safeAreaInsets.bottom;
    } else {
        return UIEdgeInsetsZero.bottom;
    }
}

- (CGFloat)topSafeArea {
    if (@available(iOS 11.0, *)) {
        return [UIApplication sharedApplication].keyWindow.safeAreaInsets.top;
    } else {
        return UIEdgeInsetsZero.top;
    }
}

- (void)sheetAnimateTransitionPresent:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController    *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView  *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    
    PMAlertController *alertController = nil;
    if ([toVC isKindOfClass:PMAlertController.class]) {
        alertController = (PMAlertController*)toVC;
    }

    if (alertController == nil) {
        return;
    }
    
    UIView *containerView = transitionContext.containerView;
    
    self.backgroundView.frame = containerView.bounds;
    self.backgroundView.alpha = 0.0;
    [containerView addSubview:self.backgroundView];

    [containerView addSubview:toView];
    toView.translatesAutoresizingMaskIntoConstraints = false;
    [toView.centerXAnchor constraintEqualToAnchor:containerView.centerXAnchor].active = true;
    [toView.widthAnchor constraintEqualToConstant:CGRectGetWidth(containerView.frame) - alertController.edgeInsets.left - alertController.edgeInsets.right].active = true;
    [toView.bottomAnchor constraintEqualToAnchor:containerView.bottomAnchor constant:-self.bottomSafeArea].active = true;
    toView.transform = CGAffineTransformMakeTranslation(0, CGRectGetHeight(toView.frame));
    [UIView animateWithDuration:PM_TRANSITION_DURATION animations:^{
        self.backgroundView.alpha = 1.0;
        toView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];
}

- (void)sheetAnimateTransitionDismissed:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController    *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    CGRect rect = fromVC.view.frame;
    rect.origin.y = CGRectGetMaxY(transitionContext.containerView.frame);
    
    [UIView animateWithDuration:PM_TRANSITION_DURATION animations:^{
        self.backgroundView.alpha = 0.0;
        fromVC.view.frame = rect;
    } completion:^(BOOL finished) {
        [self.backgroundView removeFromSuperview];
        [fromVC.view removeFromSuperview];
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];
}

- (void)sheetAnimateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    if (_transitioningType == PMAlertControllerAnimatedTransitioningPresent) {
        [self sheetAnimateTransitionPresent:transitionContext];
    } else if (_transitioningType == PMAlertControllerAnimatedTransitioningDismissed) {
        [self sheetAnimateTransitionDismissed:transitionContext];
    }
}

- (void)alertAnimateTransitionPresent:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController    *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView  *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    
    PMAlertController *alertController = nil;
    if ([toVC isKindOfClass:PMAlertController.class]) {
        alertController = (PMAlertController*)toVC;
    }
    
    if (alertController == nil) {
        return;
    }
    
    UIView *containerView = transitionContext.containerView;
    
    self.backgroundView.frame = containerView.bounds;
    self.backgroundView.alpha = 0.0;
    [containerView addSubview:self.backgroundView];
    
    toView.alpha = 0.0;
    [transitionContext.containerView addSubview:toView];
    toView.translatesAutoresizingMaskIntoConstraints = false;
    [toView.centerYAnchor constraintEqualToAnchor:containerView.centerYAnchor].active = true;
    [toView.centerXAnchor constraintEqualToAnchor:containerView.centerXAnchor].active = true;
    [toView.widthAnchor constraintEqualToConstant:CGRectGetWidth(containerView.frame) - alertController.edgeInsets.left - alertController.edgeInsets.right].active = true;
    CGFloat maxHeight = CGRectGetHeight(containerView.frame) - alertController.edgeInsets.top - alertController.edgeInsets.bottom - self.topSafeArea - self.bottomSafeArea;
    [toView.heightAnchor constraintLessThanOrEqualToConstant:maxHeight].active = true;

    alertController.view.transform = CGAffineTransformScale(alertController.view.transform, 1.2, 1.2);
    
    [UIView animateWithDuration:PM_TRANSITION_DURATION delay:0.0 usingSpringWithDamping:0.7 initialSpringVelocity:0.0 options:0 animations:^{
        self.backgroundView.alpha = 1.0;
        alertController.view.alpha = 1.0;
        alertController.view.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];
}

- (void)alertAnimateTransitionDismissed: (id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController    *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    [UIView animateWithDuration:PM_TRANSITION_DURATION animations:^{
        self.backgroundView.alpha = 0.0;
        fromVC.view.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self.backgroundView removeFromSuperview];
        [fromVC.view removeFromSuperview];
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];
}

- (void)alertAnimateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    if (_transitioningType == PMAlertControllerAnimatedTransitioningPresent) {
        [self alertAnimateTransitionPresent:transitionContext];
    } else if (_transitioningType == PMAlertControllerAnimatedTransitioningDismissed) {
        [self alertAnimateTransitionDismissed:transitionContext];
    }
}
@end

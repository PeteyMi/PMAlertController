//
//  PMAlertControllerAnimatedTransitioning.h
//  PMAlertControllerDemo
//
//  Created by Petey Mi on 2021/7/29.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PMAlertController.h"


NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, PMAlertControllerAnimatedTransitioningType) {
    PMAlertControllerAnimatedTransitioningPresent = 0,
    PMAlertControllerAnimatedTransitioningDismissed
} ;

@interface PMAlertControllerAnimatedTransitioning : NSObject<UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) PMAlertControllerAnimatedTransitioningType    transitioningType;

- (instancetype)initWithControllerStyle:(PMAlertControllerStyle)controllerStyle;
@end

NS_ASSUME_NONNULL_END

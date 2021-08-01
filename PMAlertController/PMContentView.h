//
//  PMContentView.h
//  PMAlertControllerDemo
//
//  Created by Petey Mi on 2021/7/27.
//

#import <UIKit/UIKit.h>
#import "PMAlertController.h"

NS_ASSUME_NONNULL_BEGIN


@interface PMContentView : UIView

@property (nonatomic, readonly) NSArray<PMAlertAction*>*  alertActions;
@property (nonatomic, readonly) UIScrollView    *scrollView;
@property (nonatomic, strong) UIStackView   *stackView;
@property (nonatomic, assign) UIEdgeInsets  contentInsets;
@property (nonatomic, assign) CGFloat   cornerRadius;

- (id)initWithTitleView:(nullable UIView*)titleView message:(nullable UIView*)messageView stackView:(nullable NSArray<PMAlertAction*>*)actionArray;

- (UIView*)createSeparatorView;
@end

@interface PMAlertContentView : PMContentView

@end

@interface PMSheetContentView : PMContentView

@end


@interface PMContainerView : UIView

@property (nonatomic, readonly) PMAlertControllerStyle  contrllerStyle;
@property (nonatomic, readonly) UIView    *contentView;
@property (nonatomic, assign) UIEdgeInsets  contentInsets;
@property (nonatomic, assign) CGFloat   cornerRadius;

- (id)initWithTitleView:(nullable UIView*)titleView message:(nullable UIView*)messageView stackView:(nullable NSArray<PMAlertAction*>*)actionArray style:(PMAlertControllerStyle)style;
@end


NS_ASSUME_NONNULL_END

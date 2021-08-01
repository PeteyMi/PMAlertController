//
//  PMAlertController.h
//  PMAlertControllerDemo
//
//  Created by Petey Mi on 2021/7/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, PMAlertControllerStyle) {
    PMAlertControllerStyleActionSheet = 0,
    PMAlertControllerStyleAlert,
};

typedef NS_ENUM(NSInteger, PMAlertActionStyle) {
    PMAlertActionStyleDefault = 0,
    PMAlertActionStyleCancel,
    PmAlertActionStyleDestructive
} ;

@interface PMAlertAction : NSObject

+(instancetype)actionWithTitle:(nullable NSString *)title style:(PMAlertActionStyle)style handler:(void (^ __nullable)(PMAlertAction *action))handler;

@property (nullable, nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) PMAlertActionStyle style;
@property (nonatomic, getter=isEnabled) BOOL enabled;

@end

@interface PMAlertController : UIViewController

@property (nonatomic, readonly) UILabel *titleLabel;
@property (nonatomic, readonly) UILabel *messageLabel;
@property (nonatomic, readonly) PMAlertControllerStyle preferredStyle;
@property (nonatomic, readonly) NSArray *actions;

@property (nonatomic, assign) CGFloat cornerRadius;
@property (nonatomic, assign) UIEdgeInsets  edgeInsets;
@property (nonatomic, assign) UIEdgeInsets  contentInsets;
@property (nonatomic, strong) UIColor   *backgroundColor;

+ (instancetype)alertControllerWithTitle:(nullable NSString *)title message:(nullable NSString *)message preferredStyle:(PMAlertControllerStyle)preferredStyle;

+ (instancetype)alertControllerWithTitleView:(nullable UIView *)titleView messageView:(nullable UIView *)messageView preferredStyle:(PMAlertControllerStyle)preferredStyle;

- (void)addAction:(PMAlertAction *)action;
@end

NS_ASSUME_NONNULL_END

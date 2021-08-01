//
//  PMAlertController.m
//  PMAlertControllerDemo
//
//  Created by Petey Mi on 2021/7/27.
//

#import "PMAlertControllerAnimatedTransitioning.h"
#import "PMContentView.h"
#import "PMAlertController.h"

#define PM_ALERT_TEXT_INTVALUE_LEFT             16.f
#define PM_ALERT_TEXT_INTVALUE_RIGHT            16.f
#define PM_ALERT_TEXT_INTVALUE_TOP              20.f
#define PM_ALERT_TEXT_INTVALUE_BOTTOM           20.f

#define PM_ALERT_OUTSIDE_LEFT              80.f
#define PM_ALERT_OUTSIDE_RIGHT             80.f

#define PM_SHEET_OUTSIDE_LEFT               8.f
#define PM_SHEET_OUTSIDE_RIGHT              8.f

#define PM_ALERT_TEXT_INTVALUE                  4.f
#define PM_ALERT_ACTION_HEIGHT                  44.f

@interface PMAlertAction ()

@property (nonatomic, copy) void (^handler)(PMAlertAction *action);
@property (nonatomic, weak) UIViewController    *alertController;

@end


@interface PMAlertController ()<UIViewControllerTransitioningDelegate> {
    NSMutableArray  *_actions;
}

@property (nonatomic, strong) UIView    *titleView;
@property (nonatomic, strong) UIView    *messageView;
@property (nonatomic, strong) PMContainerView     *contentView;
@property (nonatomic, strong) PMAlertControllerAnimatedTransitioning    *animatedTransitioning;

@end

@implementation PMAlertController

+ (instancetype)alertControllerWithTitle:(nullable NSString *)title message:(nullable NSString *)message preferredStyle:(PMAlertControllerStyle)preferredStyle {
    return [[self alloc] initWithTitle:title message:message preferredStyle:preferredStyle];
}

+ (instancetype)alertControllerWithTitleView:(nullable UIView *)titleView messageView:(nullable UIView *)messageView preferredStyle:(PMAlertControllerStyle)preferredStyle {
    return [[self alloc] initWithTitleView:titleView messageView:messageView preferredStyle:preferredStyle];
}


- (id)initWithTitleView:(UIView*)titleView messageView:(nullable UIView *)messageView preferredStyle:(PMAlertControllerStyle)preferredStyle {
    if (self = [super initWithNibName:nil bundle:nil]) {
        _preferredStyle = preferredStyle;
        _titleView = titleView;
        _messageView = messageView;
        [self setupDataValue];
    }
    return self;
}

- (id)initWithTitle:(NSString*)title message:(nullable NSString *)message preferredStyle:(PMAlertControllerStyle)preferredStyle {
    if (self = [super initWithNibName:nil bundle:nil]) {
        _preferredStyle = preferredStyle;
        self.title = title;
        [self setupViewWithTitle:title message:message];
        [self setupDataValue];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupView];
}

- (UIModalPresentationStyle)modalPresentationStyle {
    return UIModalPresentationCustom;
}
#pragma mark ================================ Method ========================================
- (void)setupView {
        
    _contentView = [[PMContainerView alloc] initWithTitleView:_titleView message:_messageView stackView:_actions style:_preferredStyle];

    [self.view addSubview:_contentView];
    [_contentView.leftAnchor constraintEqualToAnchor:self.view.leftAnchor].active = true;
    [_contentView.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = true;
    [_contentView.rightAnchor constraintEqualToAnchor:self.view.rightAnchor].active = true;

    _contentView.contentInsets = self.contentInsets;
    [self.view.bottomAnchor constraintEqualToAnchor:_contentView.bottomAnchor].active = true;
    
    _contentView.backgroundColor = UIColor.whiteColor;
    self.cornerRadius = 16;
}
- (void)setupDataValue {
    _contentInsets = UIEdgeInsetsMake(PM_ALERT_TEXT_INTVALUE_TOP, PM_ALERT_TEXT_INTVALUE_LEFT, PM_ALERT_TEXT_INTVALUE_BOTTOM, PM_ALERT_TEXT_INTVALUE_RIGHT);
    _cornerRadius = 12.0f;
    if (_preferredStyle == PMAlertControllerStyleAlert) {
        _edgeInsets = UIEdgeInsetsMake(0, PM_ALERT_OUTSIDE_LEFT, 0, PM_ALERT_OUTSIDE_LEFT);
    } else {
        _edgeInsets = UIEdgeInsetsMake(0, PM_SHEET_OUTSIDE_LEFT, 0, PM_SHEET_OUTSIDE_LEFT);
    }

    _actions = [[NSMutableArray alloc] init];
    
    self.transitioningDelegate = self;
}

- (void)setupViewWithTitle:(NSString*)title message:(NSString*)message {
    if (title) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = UIColor.blackColor;
        _titleLabel.font = [UIFont boldSystemFontOfSize:17.f];
        _titleLabel.numberOfLines = 0;
        _titleLabel.text = title;
        _titleView = _titleLabel;
    }

    if (message) {
        _messageLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        _messageLabel.textColor = UIColor.blackColor;
        _messageLabel.font = [UIFont systemFontOfSize:13.f];
        _messageLabel.numberOfLines = 0;
        _messageLabel.text = message;
        _messageView = _messageLabel;
    }
}
- (PMAlertControllerAnimatedTransitioning*)animatedTransitioning {
    if (_animatedTransitioning == nil) {
        _animatedTransitioning = [[PMAlertControllerAnimatedTransitioning alloc] initWithControllerStyle:_preferredStyle];
    }
    return _animatedTransitioning;
}
#pragma mark ================================ Public ========================================
- (void)setBackgroundColor:(UIColor *)backgroundColor {
    self.contentView.backgroundColor = backgroundColor;
}
- (UIColor*)backgroundColor {
    return self.contentView.backgroundColor;
}

- (void)addAction:(PMAlertAction *)action {
    if (action) {
        [_actions addObject:action];
        action.alertController = self;
    }
}

- (NSArray<PMAlertAction*>*)actions {
    return _actions;
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    _cornerRadius = cornerRadius;
    if (_contentView) {
        _contentView.cornerRadius = cornerRadius;
    }
}
#pragma makr ---------UIViewControllerTransitioningDelegate
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    self.animatedTransitioning.transitioningType = PMAlertControllerAnimatedTransitioningPresent;
    return self.animatedTransitioning;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    self.animatedTransitioning.transitioningType = PMAlertControllerAnimatedTransitioningDismissed;
    return self.animatedTransitioning;
}
@end


#pragma mark ================================================================================
@implementation PMAlertAction


+(instancetype)actionWithTitle:(nullable NSString *)title style:(PMAlertActionStyle)style handler:(void (^ __nullable)(PMAlertAction *action))handler {
    return [[self alloc] initWithTitle:title style:style handler:handler];
}

-(id)initWithTitle:(nullable NSString *)title style:(PMAlertActionStyle)style handler:(void (^ __nullable)(PMAlertAction *action))handler {
    if (self = [super init]) {
        _title = title;
        _style = style;
        _handler = handler;
    }
    return self;
}

- (UIButton*)createActionView {
    
    UIButton *bt = [UIButton buttonWithType:UIButtonTypeCustom];
    bt.frame = CGRectMake(0, 0, 0, PM_ALERT_ACTION_HEIGHT);
    [bt setTitle:_title forState:UIControlStateNormal];
    bt.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    if (_style == PMAlertActionStyleDefault) {
        bt.titleLabel.font = [UIFont systemFontOfSize:17.f];
        [bt setTitleColor:[UIColor colorWithRed:0.0 green:0.48 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
    } else if (_style == PMAlertActionStyleCancel) {
        bt.titleLabel.font = [UIFont boldSystemFontOfSize:17.f];
        [bt setTitleColor:[UIColor colorWithRed:0.0 green:0.48 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
    } else if (_style == PmAlertActionStyleDestructive) {
        bt.titleLabel.font = [UIFont systemFontOfSize:17.f];
        [bt setTitleColor:[UIColor colorWithRed:1.0 green:0.23 blue:0.19 alpha:1.0] forState:UIControlStateNormal];
    }
    [bt addTarget:self action:@selector(btAction:) forControlEvents:UIControlEventTouchUpInside];
    return bt;
}

- (void)btAction:(id)sender {
    if (self.alertController) {
        [self.alertController dismissViewControllerAnimated:YES completion:nil];
    }
    if (_handler) {
        _handler (self);
    }
}

@end

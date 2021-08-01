//
//  PMContentView.m
//  PMAlertControllerDemo
//
//  Created by Petey Mi on 2021/7/27.
//

#import "PMContentView.h"

#define PM_ALERT_TEXT_INTERVAL                  4.f
#define PM_ALERT_ACTION_HEIGHT                  44.f
#define PM_SHEET_ACTION_HEIGHT                  57.f
#define PM_ALERT_SEPARATOR_HEIGHT               0.33f

#define PM_SHEET_CANCEL_INTERVAL                8.f


#define PM_ALERT_HORIZONTAL_NUMBER              2.f
#define PM_ALERT_SEPARATOR_TAG                  9999

#define PM_AUTO_LAYOUT_HEIGHT                   1200

@interface PMAlertAction (Private)

- (UIView*)createActionView;

@end

@interface PMContentView ()

@property (nonatomic, strong) UIScrollView  *scrollView;
@property (nonatomic, strong) UIView    *contentView;
@property (nonatomic, strong) UIView    *titleView;
@property (nonatomic, strong) UIView    *messageView;
@property (nonatomic, strong) NSArray<PMAlertAction*>*  alertActions;

@end

@implementation PMContentView

- (id)initWithTitleView:(nullable UIView*)titleView message:(nullable UIView*)messageView stackView:(nullable NSArray<PMAlertAction*>*)actionArray {
    if (self = [super initWithFrame:CGRectZero]) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        _titleView = titleView;
        _messageView = messageView;
        _alertActions = actionArray;
        _contentInsets = UIEdgeInsetsZero;
        [self setupView];
    }
    return self;
}

- (void)updateConstraints {
    [super updateConstraints];
    UIView *lastView = nil;
    if (_titleView) {
        [_titleView.leftAnchor constraintEqualToAnchor:_contentView.leftAnchor constant:_contentInsets.left].active = true;
        [_titleView.topAnchor constraintEqualToAnchor:_contentView.topAnchor constant:_contentInsets.top].active = true;
        [_titleView.rightAnchor constraintEqualToAnchor:_contentView.rightAnchor constant:-_contentInsets.right].active = true;
        [_titleView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        lastView = _titleView;
    }
    
    if (_messageView) {
        if (_titleView) {
            [_messageView.topAnchor constraintEqualToAnchor:_titleView.bottomAnchor constant:5.f].active = true;
        } else {
            [_messageView.topAnchor constraintEqualToAnchor:_contentView.topAnchor constant:_contentInsets.top].active = true;
        }
        [_messageView.leftAnchor constraintEqualToAnchor:_contentView.leftAnchor constant:_contentInsets.left].active = true;
        [_messageView.rightAnchor constraintEqualToAnchor:_contentView.rightAnchor constant:-_contentInsets.right].active = true;
        lastView = _messageView;
        [_messageView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    }
    
    if (_contentView) {
        [_contentView.leftAnchor constraintEqualToAnchor:_scrollView.leftAnchor].active = true;
        [_contentView.topAnchor constraintEqualToAnchor:_scrollView.topAnchor].active = true;
        [_contentView.rightAnchor constraintEqualToAnchor:_scrollView.rightAnchor constant:0.f].active = true;
        [_contentView.widthAnchor constraintEqualToAnchor:_scrollView.widthAnchor].active = true;
        [_contentView.bottomAnchor constraintEqualToAnchor:lastView.bottomAnchor constant:_contentInsets.bottom].active = true;
        
        NSLayoutConstraint *height = [_scrollView.heightAnchor constraintEqualToAnchor:_contentView.heightAnchor];
        height.priority = UILayoutPriorityDefaultHigh;
        height.active = true;
    }
    
    if (_stackView) {
        [self.bottomAnchor constraintEqualToAnchor:_stackView.bottomAnchor].active = true;
    } else if (_scrollView) {
        [self.bottomAnchor constraintEqualToAnchor:_scrollView.bottomAnchor].active = true;
    }
}

- (void)setupView {
    _contentView = [[UIView alloc] initWithFrame:self.bounds];
    
    if (_titleView) {
        [_contentView addSubview:_titleView];
        _titleView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    if (_messageView) {
        [_contentView addSubview:_messageView];
        _messageView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    if (_contentView.subviews.count) {
        
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        [self addSubview:_scrollView];
        _scrollView.translatesAutoresizingMaskIntoConstraints = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        [_scrollView.leftAnchor constraintEqualToAnchor:self.leftAnchor].active = true;
        [_scrollView.topAnchor constraintEqualToAnchor:self.topAnchor].active = true;
        [_scrollView.rightAnchor constraintEqualToAnchor:self.rightAnchor].active = true;
        
        [_scrollView addSubview:_contentView];
        _contentView.translatesAutoresizingMaskIntoConstraints = NO;
        [_scrollView.bottomAnchor constraintEqualToAnchor:_contentView.bottomAnchor].active = true;
    } else {
        _contentView = nil;
    }
}

- (void)setContentInsets:(UIEdgeInsets)contentInsets {
    _contentInsets = contentInsets;
    [self setNeedsUpdateConstraints];
}

- (UIView*)createSeparatorView {
    UIView *separatorView = [[UIView alloc] init];
    separatorView.translatesAutoresizingMaskIntoConstraints = NO;
    separatorView.backgroundColor = UIColor.grayColor;
    separatorView.tag = PM_ALERT_SEPARATOR_TAG;
    return separatorView;
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    _cornerRadius = cornerRadius;
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = YES;
}

@end

@implementation PMAlertContentView

- (id)initWithTitleView:(UIView *)titleView message:(UIView *)messageView stackView:(NSArray<PMAlertAction *> *)actionArray {
    if (self = [super initWithTitleView:titleView message:messageView stackView:actionArray]) {
        self.stackView = [self createStackViewWithActionArray:actionArray];
        
        if (self.stackView) {
            if (self.scrollView ) {
                UIView *separatorView = [self createSeparatorView];
                [self addSubview:separatorView];
                [separatorView.leftAnchor constraintEqualToAnchor:self.leftAnchor].active = true;
                [separatorView.rightAnchor constraintEqualToAnchor:self.rightAnchor].active = true;
                [separatorView.topAnchor constraintEqualToAnchor:self.scrollView.bottomAnchor].active = true;
                [separatorView.heightAnchor constraintEqualToConstant:PM_ALERT_SEPARATOR_HEIGHT].active = true;
                    
                [self addSubview:self.stackView];
                [self.stackView.topAnchor constraintEqualToAnchor:separatorView.bottomAnchor].active = true;
            } else {
                [self addSubview:self.stackView];
                [self.stackView.topAnchor constraintEqualToAnchor:self.topAnchor].active = true;
            }
            
            [self.stackView.leftAnchor constraintEqualToAnchor:self.leftAnchor].active = true;
            [self.stackView.rightAnchor constraintEqualToAnchor:self.rightAnchor].active = true;
        }
    }
    return self;
}

- (UIStackView*)createStackViewWithActionArray:(NSArray<PMAlertAction*>*)actionArray {
    
    NSMutableArray *mutableArray = [[NSMutableArray alloc] initWithCapacity:actionArray.count];
    PMAlertAction *cancelAction = nil;
   
    for (NSInteger index = 0; index < actionArray.count; index++) {
        PMAlertAction *action = actionArray[index];
        if (action.style == PMAlertActionStyleCancel) {
            cancelAction = action;
        } else {
            UIView *view = [action createActionView];
            [mutableArray addObject:view];
            if (index < actionArray.count - 1) {
                UIView *separatorView = [self createSeparatorView];
                [mutableArray addObject:separatorView];
            }
        }
    }
    
    UIView *lastView = mutableArray.lastObject;
    if (lastView.tag == PM_ALERT_SEPARATOR_TAG) {
        [mutableArray removeObject:lastView];
    }
    
    if (cancelAction && actionArray.count <= PM_ALERT_HORIZONTAL_NUMBER) {
        UIView *separatorView = [self createSeparatorView];
        [mutableArray insertObject:separatorView atIndex:0];
        UIView *view = [cancelAction createActionView];
        [mutableArray insertObject:view atIndex:0];
    } else if (cancelAction && actionArray.count > PM_ALERT_HORIZONTAL_NUMBER) {
        UIView *separatorView = [self createSeparatorView];
        [mutableArray addObject:separatorView];
        UIView *view = [cancelAction createActionView];
        [mutableArray addObject:view];
    }
    
    
    return [self createStackViewWithArray:mutableArray];
}

- (UIStackView*)createStackViewWithArray:(NSArray<UIView*>*)arrayViews {
    if (arrayViews.count == 0) {
        return nil;
    }

    UILayoutConstraintAxis stackAxis = UILayoutConstraintAxisHorizontal;
    
    if (self.alertActions.count > PM_ALERT_HORIZONTAL_NUMBER) {
        stackAxis = UILayoutConstraintAxisVertical;
    }
    
    UIStackView *stackView = [[UIStackView alloc] init];
    stackView.translatesAutoresizingMaskIntoConstraints = NO;
    stackView.spacing = 0.f;
    
    stackView.axis = stackAxis;
    stackView.alignment = UIStackViewAlignmentFill;
    
    if (stackAxis == UILayoutConstraintAxisHorizontal) {
        stackView.distribution = UIStackViewDistributionFillProportionally;
    } else {
        stackView.distribution = UIStackViewDistributionFill;
    }
    
    __block UIView *preView = nil;
    if (stackAxis == UILayoutConstraintAxisHorizontal) {
        [arrayViews enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [stackView addArrangedSubview:obj];
            if ([obj isKindOfClass:UIButton.class]) {
                [obj.heightAnchor constraintEqualToConstant:PM_ALERT_ACTION_HEIGHT].active = true;
                if (preView) {
                    [obj.widthAnchor constraintEqualToAnchor:preView.widthAnchor].active = true;
                } else {
                    preView = obj;
                }
            } else {
                [obj.widthAnchor constraintEqualToConstant:PM_ALERT_SEPARATOR_HEIGHT].active = true;
            }
        }];
    } else {
        [arrayViews enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [stackView addArrangedSubview:obj];
            if ([obj isKindOfClass:UIButton.class]) {
                [obj.heightAnchor constraintEqualToConstant:PM_ALERT_ACTION_HEIGHT].active = true;
            } else {
                [obj.heightAnchor constraintEqualToConstant:PM_ALERT_SEPARATOR_HEIGHT].active = true;
            }
        }];
    }
    
    return stackView;
}


@end


@implementation PMSheetContentView
    
- (id)initWithTitleView:(UIView *)titleView message:(UIView *)messageView stackView:(NSArray<PMAlertAction *> *)actionArray {
    if (self = [super initWithTitleView:titleView message:messageView stackView:actionArray]) {
        self.stackView = [self createStackViewWithActionArray:actionArray];
        if (self.stackView) {
            if (self.scrollView ) {
                UIView *separatorView = [self createSeparatorView];
                [self addSubview:separatorView];
                [separatorView.leftAnchor constraintEqualToAnchor:self.leftAnchor].active = true;
                [separatorView.rightAnchor constraintEqualToAnchor:self.rightAnchor].active = true;
                [separatorView.topAnchor constraintEqualToAnchor:self.scrollView.bottomAnchor].active = true;
                [separatorView.heightAnchor constraintEqualToConstant:PM_ALERT_SEPARATOR_HEIGHT].active = true;
                    
                [self addSubview:self.stackView];
                [self.stackView.topAnchor constraintEqualToAnchor:separatorView.bottomAnchor].active = true;
            } else {
                [self addSubview:self.stackView];
                [self.stackView.topAnchor constraintEqualToAnchor:self.topAnchor].active = true;
            }
            
            [self.stackView.leftAnchor constraintEqualToAnchor:self.leftAnchor].active = true;
            [self.stackView.rightAnchor constraintEqualToAnchor:self.rightAnchor].active = true;
        }
    }
    return self;
}


- (UIStackView*)createStackViewWithActionArray:(NSArray<PMAlertAction*>*)actionArray {
    
    NSMutableArray *mutableArray = [[NSMutableArray alloc] initWithCapacity:actionArray.count];
    
    for (NSInteger index = 0; index < actionArray.count; index++) {
        PMAlertAction *action = actionArray[index];
        
        UIView *view = [action createActionView];
        [mutableArray addObject:view];
        if (index < actionArray.count - 1) {
            UIView *separatorView = [self createSeparatorView];
            [mutableArray addObject:separatorView];
        }
    }
    
    UIView *lastView = mutableArray.lastObject;
    if (lastView.tag == PM_ALERT_SEPARATOR_TAG) {
        [mutableArray removeObject:lastView];
    }
    
    return  [self createStackViewWithArray:mutableArray];
}

- (UIStackView*)createStackViewWithArray:(NSArray<UIView*>*)arrayViews {
    if (arrayViews.count == 0) {
        return nil;
    }

    UIStackView *stackView = [[UIStackView alloc] init];
    stackView.translatesAutoresizingMaskIntoConstraints = NO;
    stackView.spacing = 0.f;
    
    stackView.axis = UILayoutConstraintAxisVertical;
    stackView.alignment = UIStackViewAlignmentFill;
    stackView.distribution = UIStackViewDistributionFill;
    
    [arrayViews enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [stackView addArrangedSubview:obj];
        if ([obj isKindOfClass:UIButton.class]) {
            [obj.heightAnchor constraintEqualToConstant:PM_SHEET_ACTION_HEIGHT].active = true;
        } else {
            [obj.heightAnchor constraintEqualToConstant:PM_ALERT_SEPARATOR_HEIGHT].active = true;
        }
    }];
    
    return stackView;
}
@end



@implementation PMContainerView {
    PMContentView   *_cancelView;
    PMContentView   *_contentView;
}

- (id)initWithTitleView:(nullable UIView*)titleView message:(nullable UIView*)messageView stackView:(nullable NSArray<PMAlertAction*>*)actionArray style:(PMAlertControllerStyle)style {
    if (self = [super initWithFrame:CGRectZero]) {
        self.translatesAutoresizingMaskIntoConstraints = false;
        _contrllerStyle = style;
        if (_contrllerStyle == PMAlertControllerStyleActionSheet) {
            [self setupSheetViewWithTitleView:titleView message:messageView stackView:actionArray];
        } else {
            [self setupAlertViewWithTitleView:titleView message:messageView stackView:actionArray];
        }
    }
    return self;
}


- (void)setupAlertViewWithTitleView:(nullable UIView*)titleView message:(nullable UIView*)messageView stackView:(nullable NSArray<PMAlertAction*>*)actionArray {
    _contentView = [[PMAlertContentView alloc] initWithTitleView:titleView message:messageView stackView:actionArray];
    if (_contentView) {
        [self addSubview:_contentView];
        [_contentView.leftAnchor constraintEqualToAnchor:self.leftAnchor].active = true;
        [_contentView.rightAnchor constraintEqualToAnchor:self.rightAnchor].active = true;
        [_contentView.topAnchor constraintEqualToAnchor:self.topAnchor].active = true;
        [self.bottomAnchor constraintEqualToAnchor:_contentView.bottomAnchor].active = true;
    }
}

- (void)setupSheetViewWithTitleView:(nullable UIView*)titleView message:(nullable UIView*)messageView stackView:(nullable NSArray<PMAlertAction*>*)actionArray {
        
    __block PMAlertAction *cancelAction = nil;
    [actionArray enumerateObjectsUsingBlock:^(PMAlertAction * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.style == PMAlertActionStyleCancel) {
            cancelAction = obj;
            *stop = YES;
        }
    }];
    NSMutableArray<PMAlertAction*> *array = actionArray.mutableCopy;
    if (cancelAction) {
        [array removeObject:cancelAction];
        _cancelView = [[PMSheetContentView alloc] initWithTitleView:nil message:nil stackView:@[cancelAction]];
    }
    _contentView = [[PMSheetContentView alloc] initWithTitleView:titleView message:messageView stackView:array];
    if (_contentView) {
        [self addSubview:_contentView];
        [_contentView.leftAnchor constraintEqualToAnchor:self.leftAnchor].active = true;
        [_contentView.rightAnchor constraintEqualToAnchor:self.rightAnchor].active = true;
        [_contentView.topAnchor constraintEqualToAnchor:self.topAnchor].active = true;
    }
    if (_cancelView) {
        [self addSubview:_cancelView];
        [_cancelView.leftAnchor constraintEqualToAnchor:self.leftAnchor].active = true;
        [_cancelView.rightAnchor constraintEqualToAnchor:self.rightAnchor].active = true;
    }
    if (_cancelView) {
        if (_contentView) {
            [_cancelView.topAnchor constraintEqualToAnchor:_contentView.bottomAnchor constant:8.f].active = true;
        } else {
            [_cancelView.topAnchor constraintEqualToAnchor:self.bottomAnchor].active = true;
        }
        [self.bottomAnchor constraintEqualToAnchor:_cancelView.bottomAnchor].active = true;
    } else if(_contentView){
        [self.bottomAnchor constraintEqualToAnchor:_contentView.bottomAnchor].active = true;
    }
}

- (void)setContentInsets:(UIEdgeInsets)contentInsets {
    _contentInsets = contentInsets;
    if (_contentView) {
        _contentView.contentInsets = contentInsets;
    }
}
- (void)setBackgroundColor:(UIColor *)backgroundColor {
    if (_contentView) {
        _contentView.backgroundColor = backgroundColor;
    }
    if (_cancelView) {
        _cancelView.backgroundColor = backgroundColor;
    }
}
- (UIColor*)backgroundColor {
    return _contentView.backgroundColor;
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    _cornerRadius = cornerRadius;
    if (_contentView) {
        _contentView.cornerRadius = cornerRadius;
    }
    if (_cancelView) {
        _cancelView.cornerRadius = cornerRadius;
    }
}

@end


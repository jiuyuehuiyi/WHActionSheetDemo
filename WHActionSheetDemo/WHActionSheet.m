//
//  WHActionSheet.m
//  WHActionSheetDemo
//
//  Created by dengweihao on 15/8/5.
//  Copyright (c) 2015年 vcyber. All rights reserved.
//

#import "WHActionSheet.h"
#import "Masonry.h"
#define WS(weakSelf) __weak typeof(self) weakSelf = self
#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width

#define TITLE_HEIGHT 50     //标题高度
#define TITLE_FONT_SIZE 20  //标题字体大小
#define LINEVIEW_HEIGHT 1   //分割线高度
#define BUTTON_HEIGHT 44    //按钮高度
#define BUTTON_FONT_SIZE 18 //按钮标题字体大小
#define CANCELBUTTON_HEIGHT 44 //取消按钮高度
#define CANCEL_FONT_SIZE 18 //取消按钮标题字体大小
#define SPACE_SMALL 5 //间距

@interface WHActionSheet ()

/** 背景视图 */
@property (strong, nonatomic) UIView *backgroundView;
/** 内容视图 */
@property (strong, nonatomic) UIImageView *contentView;
/** 按钮视图 */
@property (strong, nonatomic) UIView *buttonView;
/** 按钮容器 */
@property (strong, nonatomic) UIView *buttonContentView;
/** 标题标签 */
@property (strong, nonatomic) UILabel *titleLabel;
/** 按钮数组 */
@property (strong, nonatomic) NSMutableArray *buttonArray;
/** 取消按钮 */
@property (strong, nonatomic) UIButton *cancelButton;
/** 按钮标题数组 */
@property (strong, nonatomic) NSMutableArray *buttonTitleArray;

@end

@implementation WHActionSheet

#pragma mark - 生命周期方法

/** 初始化WHActionSheet */
- (id)initWithTitle:(NSString *)title delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...
{
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        _title = title;
        _delegate = delegate;
        _cancelButtonTitle = cancelButtonTitle;
        _buttonArray = [NSMutableArray array];
        _buttonTitleArray = [NSMutableArray array];
        
        //获取可变参数
        va_list args;
        va_start(args, otherButtonTitles);
        if (otherButtonTitles) {
            [_buttonTitleArray addObject:otherButtonTitles];
            while (1) {
                NSString *otherButtonTitle = va_arg(args, NSString *);
                if (otherButtonTitle == nil) {
                    break;
                } else {
                    [_buttonTitleArray addObject:otherButtonTitle];
                }
            }
        }
        va_end(args);
        
        //背景颜色
        self.backgroundColor = [UIColor clearColor];
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeAnimation)];
        _backgroundView = [[UIView alloc] init];
        _backgroundView.alpha = 0;
        //背景视图颜色
        _backgroundView.backgroundColor = [UIColor blackColor];
        [_backgroundView addGestureRecognizer:tapGestureRecognizer];
        [self addSubview:_backgroundView];
        
        // 约束backgroundView
        WS(weakSelf);
        [self.backgroundView mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.edges.equalTo(weakSelf).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        
        [self initContentView];
    }
    return self;

}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    WS(weakSelf);
    
    CGFloat titleHeight = 0;
    if (_title != nil && ![_title isEqualToString:@""]) {
        titleHeight = TITLE_HEIGHT;
    }
    
    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(SCREENWIDTH * (290.0/320.0)); // 约束宽度等于屏幕宽度的290/320倍
        make.height.mas_equalTo(titleHeight + (LINEVIEW_HEIGHT + BUTTON_HEIGHT)*_buttonArray.count + SPACE_SMALL + CANCELBUTTON_HEIGHT + SPACE_SMALL);
        make.centerX.mas_equalTo(weakSelf);
        make.bottom.mas_equalTo(weakSelf.mas_bottom);
    }];
    
    [self.buttonView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(weakSelf.contentView.mas_width);
        make.height.mas_equalTo(titleHeight + (LINEVIEW_HEIGHT + BUTTON_HEIGHT)*_buttonArray.count);
        make.centerX.mas_equalTo(weakSelf.contentView);
        make.top.mas_equalTo(weakSelf.contentView);
    }];
    
    [self.buttonContentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(weakSelf.buttonView);
        make.height.mas_equalTo((LINEVIEW_HEIGHT + BUTTON_HEIGHT)*_buttonArray.count);
        make.centerX.mas_equalTo(weakSelf.buttonView);
        make.top.mas_equalTo(weakSelf.contentView.mas_top).offset(titleHeight);
    }];
}

/** 初始化内容视图 */
- (void)initContentView
{
    self.contentView = [[UIImageView alloc] init];
    self.contentView.backgroundColor = [UIColor clearColor];
    self.contentView.userInteractionEnabled = YES;
    [self addSubview:self.contentView];
    
    self.buttonView = [[UIView alloc] init];
    self.buttonView.layer.cornerRadius = 10.0;
    self.buttonView.layer.masksToBounds = YES;
    self.buttonView.backgroundColor = [UIColor clearColor]; //按钮视图的背景颜色
    [self.contentView addSubview:self.buttonView];
    
    self.buttonContentView = [[UIView alloc] init];
    self.buttonContentView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.8];
    [self.contentView addSubview:self.buttonContentView];
    
    [self initTitle]; //初始化标题
    [self initButtons]; //初始化按钮
    [self initCancelButton]; //初始化取消按钮
    
    
}

/** 初始化标题 */
- (void)initTitle
{
    if (_title != nil && ![_title isEqualToString:@""]) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = _title;
        _titleLabel.textAlignment = NSTextAlignmentCenter; //标题居中
        _titleLabel.textColor = [UIColor blackColor]; //标题颜色
        _titleLabel.font = [UIFont boldSystemFontOfSize:TITLE_FONT_SIZE]; //标题字体大小,默认15
        _titleLabel.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.8]; //标签背景颜色
        [_buttonView addSubview:_titleLabel];
        
        WS(weakSelf);
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(weakSelf.buttonView);
            make.height.mas_equalTo(TITLE_HEIGHT);
            make.centerX.mas_equalTo(weakSelf.buttonView);
            make.top.mas_equalTo(weakSelf.buttonView);
        }];
    }
}

/** 初始化按钮 */
- (void)initButtons
{
    WS(weakSelf);
    if (_buttonTitleArray.count > 0) {
        NSInteger count = _buttonTitleArray.count;
        for (int i = 0; i < count; i++) {
            UIView *lineView = [[UIView alloc] init]; //分割线
            lineView.backgroundColor = [UIColor colorWithRed:230 / 255.0 green:230 / 255.0 blue:230 / 255.0 alpha:1.0]; //分割线颜色
            
            [_buttonContentView addSubview:lineView];
            
            [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(weakSelf.buttonContentView);
                make.height.mas_equalTo(LINEVIEW_HEIGHT);
                make.centerX.mas_equalTo(weakSelf.buttonContentView);
                make.top.mas_equalTo((LINEVIEW_HEIGHT + BUTTON_HEIGHT)*i);
            }];
            
            UIButton *button = [[UIButton alloc] init]; //按钮frame,高度为44
            button.backgroundColor = [UIColor clearColor]; //按钮背景颜色
            button.titleLabel.font = [UIFont systemFontOfSize:BUTTON_FONT_SIZE]; //按钮标题字体大小
            [button setTitleColor:[UIColor orangeColor] forState:UIControlStateHighlighted];
            [button setTitle:_buttonTitleArray[i] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithRed:0 / 255.0 green:122 / 255.0 blue:255 / 255.0 alpha:1.0] forState:UIControlStateNormal]; //按钮标题颜色
            [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside]; //按钮注册响应事件
            [_buttonArray addObject:button];
            [_buttonContentView addSubview:button];
            
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(weakSelf.buttonContentView);
                make.height.mas_equalTo(BUTTON_HEIGHT);
                make.centerX.mas_equalTo(weakSelf.buttonContentView);
                make.top.mas_equalTo((LINEVIEW_HEIGHT + BUTTON_HEIGHT)*i + LINEVIEW_HEIGHT);
            }];
            
            button.tag = i;
        }
    }
}

/** 初始化取消按钮 */
- (void)initCancelButton
{
    WS(weakSelf);
    
    if (_cancelButtonTitle != nil) {
        _cancelButton = [[UIButton alloc] init];
        _cancelButton.backgroundColor = [UIColor whiteColor]; //取消按钮背景颜色
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:CANCEL_FONT_SIZE]; //取消按钮标题字体大小
        _cancelButton.layer.cornerRadius = 5.0; //取消按钮设置圆角
        [_cancelButton setTitle:_cancelButtonTitle forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor colorWithRed:255 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:1.0] forState:UIControlStateNormal]; //取消按钮标题颜色
        [_cancelButton addTarget:self action:@selector(cancelButtonPressed:) forControlEvents:UIControlEventTouchUpInside]; //取消按钮注册响应事件
        [_contentView addSubview:_cancelButton];
        
        [_cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(weakSelf.contentView);
            make.height.mas_equalTo(CANCELBUTTON_HEIGHT);
            make.centerX.mas_equalTo(weakSelf.contentView);
            make.bottom.mas_equalTo(weakSelf.contentView.mas_bottom).with.offset(-SPACE_SMALL);
        }];
        
        _cancelButton.tag = -1;
    }
}

#pragma mark - 设置样式方法

- (void)setContentViewImage:(UIImage *)contentViewImage {
    self.contentView.image = contentViewImage;
}

- (void)setButtonContentViewBgColor:(UIColor *)buttonContentViewBgColor {
    self.buttonContentView.backgroundColor = buttonContentViewBgColor;
}

- (void)setTitleLabelBgColor:(UIColor *)titleLabelBgColor {
    self.titleLabel.backgroundColor = titleLabelBgColor;
}

/** 设置标题 */
- (void)setTitle:(NSString *)title
{
    if (_title != nil) {
        _titleLabel.text = title;
    } else {
        _title = title;
        [self initTitle];
    }
}

/** 设置取消按钮标题 */
- (void)setCancelButtonTitle:(NSString *)cancelButtonTitle {
    _cancelButtonTitle = cancelButtonTitle;
    [_cancelButton setTitle:cancelButtonTitle forState:UIControlStateNormal];
}

/** 设置标题的字体和颜色. 默认字体颜色是黑色, 字体大小是15 */
- (void)setTitleColor:(UIColor *)color fontSize:(CGFloat)size
{
    if (color != nil) {
        _titleLabel.textColor = color;
    }
    
    if (size > 0) {
        _titleLabel.font = [UIFont systemFontOfSize:size];
    }
}

/** 设置按钮的标题字体和颜色以及按钮的背景颜色. 默认按钮标题颜色是黑色, 按钮背景颜色是白色, 按钮上字体大小是14 */
- (void)setButtonTitleColor:(UIColor *)color bgColor:(UIColor *)bgcolor fontSize:(CGFloat)size atIndex:(int)index
{
    UIButton *button = _buttonArray[index];
    if (color != nil) {
        [button setTitleColor:color forState:UIControlStateNormal];
    }
    
    if (bgcolor != nil) {
        [button setBackgroundColor:bgcolor];
    }
    
    if (size > 0) {
        button.titleLabel.font = [UIFont systemFontOfSize:size];
    }
}

/** 设置取消按钮的标题字体和颜色以及按钮的背景颜色. 默认按钮标题颜色是红色, 按钮背景颜色是白色, 按钮上字体大小是14 */
- (void)setCancelButtonTitleColor:(UIColor *)color bgColor:(UIColor *)bgcolor fontSize:(CGFloat)size
{
    if (color != nil) {
        [_cancelButton setTitleColor:color forState:UIControlStateNormal];
    }
    
    if (bgcolor != nil) {
        [_cancelButton setBackgroundColor:bgcolor];
    }
    
    if (size > 0) {
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:size];
    }
}

- (NSInteger)addButtonWithTitle:(NSString *)title
{
    WS(weakSelf);
    [_buttonTitleArray addObject:title];
    UIView *lineView = [[UIView alloc] init]; //分割线
    lineView.backgroundColor = [UIColor colorWithRed:230 / 255.0 green:230 / 255.0 blue:230 / 255.0 alpha:1.0];
    [_buttonContentView addSubview:lineView];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(weakSelf.buttonContentView);
        make.height.mas_equalTo(LINEVIEW_HEIGHT);
        make.centerX.mas_equalTo(weakSelf.buttonContentView);
        make.top.mas_equalTo((LINEVIEW_HEIGHT + BUTTON_HEIGHT)*(_buttonArray.count));
    }];
    
    UIButton *button = [[UIButton alloc] init];
    button.backgroundColor = [UIColor clearColor];
    button.titleLabel.font = [UIFont systemFontOfSize:BUTTON_FONT_SIZE];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:0 / 255.0 green:122 / 255.0 blue:255 / 255.0 alpha:1.0] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_buttonArray addObject:button];
    [_buttonContentView addSubview:button];
    button.tag = _buttonArray.count-1;
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(weakSelf.buttonContentView);
        make.height.mas_equalTo(BUTTON_HEIGHT);
        make.centerX.mas_equalTo(weakSelf.buttonContentView);
        make.top.mas_equalTo((LINEVIEW_HEIGHT + BUTTON_HEIGHT)*(_buttonArray.count-1) + LINEVIEW_HEIGHT);
    }];
    
    return _buttonArray.count-1;
}

#pragma mark - 添加和移除ActionSheet方法

/** 显示ActionSheet */
- (void)show
{
    UIWindow *window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    [window addSubview:self];
    
    UIWindow *keyWindow = [[[UIApplication sharedApplication] delegate] window];
    
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(keyWindow).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(willPresentActionSheet:)]) {
        [_delegate willPresentActionSheet:self];
    }
    
    [self addAnimation];
}

/** 移除ActionSheet */
- (void)hideByClickButtonIndex:(NSInteger)index
{
    [self removeAnimationByClickButtonIndex:index];
}

/** 添加ActionSheet时的动画效果 */
- (void)addAnimation
{
    self.contentView.transform = CGAffineTransformTranslate(self.contentView.transform, 0, TITLE_HEIGHT + (LINEVIEW_HEIGHT + BUTTON_HEIGHT)*_buttonArray.count + SPACE_SMALL + CANCELBUTTON_HEIGHT + SPACE_SMALL);
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        self.contentView.transform = CGAffineTransformIdentity;
        
        _backgroundView.alpha = 0.7;
    } completion:^(BOOL finished) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(didPresentActionSheet:)]) {
            [_delegate didPresentActionSheet:self];
        }
    }];
}

/** 移除ActionSheet时的动画效果 */
- (void)removeAnimationByClickButtonIndex:(NSInteger)index
{
    [UIView animateWithDuration:0.3 delay:0 options: UIViewAnimationOptionCurveEaseOut animations:^{
        _contentView.frame = CGRectMake(_contentView.frame.origin.x, self.frame.size.height, _contentView.frame.size.width, _contentView.frame.size.height);
        _backgroundView.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(actionSheet:didDismissWithButtonIndex:)] && index != -1) {
            [_delegate actionSheet:self didDismissWithButtonIndex:index];
        }
    }];
}

- (void)removeAnimation
{
    [UIView animateWithDuration:0.3 delay:0 options: UIViewAnimationOptionCurveEaseOut animations:^{
        self.contentView.transform = CGAffineTransformTranslate(self.contentView.transform, 0, TITLE_HEIGHT + (LINEVIEW_HEIGHT + BUTTON_HEIGHT)*_buttonArray.count + SPACE_SMALL + CANCELBUTTON_HEIGHT + SPACE_SMALL);
        _backgroundView.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - 按钮点击事件

- (void)buttonPressed:(UIButton *)button
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(actionSheet:clickedButtonAtIndex:)]) {
        for (int i = 0; i < _buttonArray.count; i++) {
            if (button == _buttonArray[i]) {
                [_delegate actionSheet:self clickedButtonAtIndex:i];
                break;
            }
        }
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(actionSheet:willDismissWithButtonIndex:)]) {
        [_delegate actionSheet:self willDismissWithButtonIndex:button.tag];
    }
    
    [self hideByClickButtonIndex:button.tag];
}

- (void)cancelButtonPressed:(UIButton *)button
{
    NSLog(@"-----点击取消按钮-----");
    if (_delegate && [_delegate respondsToSelector:@selector(actionSheetCancel:)]) {
        [_delegate actionSheetCancel:self];
    }
    [self hideByClickButtonIndex:button.tag];
}




@end

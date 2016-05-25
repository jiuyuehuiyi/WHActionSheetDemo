//
//  WHActionSheet.h
//  WHActionSheetDemo
//
//  Created by dengweihao on 15/8/5.
//  Copyright (c) 2015年 vcyber. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WHActionSheet;

@protocol WHActionSheetDelegate <NSObject>

@optional

/**
 *  当点击Actionsheet上的一个按钮,发送消息给代理,
 *  包含该按钮的Actionsheet将被自动移除在当前方法被调用之后
 *
 *  @param actionSheet 包含被点击按钮的ActionSheet
 *  @param buttonIndex 被点击按钮的索引,索引从0开始
 */
- (void)actionSheet:(WHActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;

/**
 *  当点击Actionsheet上的取消按钮,发送消息给代理,
 *  包含该取消按钮的Actionsheet将被自动移除在当前方法被调用之后
 *
 *  @param actionSheet 包含被点击按钮的ActionSheet
 */
- (void)actionSheetCancel:(WHActionSheet *)actionSheet;

/** ActionSheet即将显示时 */
- (void)willPresentActionSheet:(WHActionSheet *)actionSheet;

/** ActionSheet已经显示时 */
- (void)didPresentActionSheet:(WHActionSheet *)actionSheet;

/** ActionSheet即将消失时 */
- (void)actionSheet:(WHActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex;

/** ActionSheet已经消失时 */
- (void)actionSheet:(WHActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex;



@end

/**
 *  创建一个自定义的ActionSheet, title的设置必须在show方法调用前才能生效
 */
@interface WHActionSheet : UIView

/** 代理 */
@property (weak, nonatomic) id<WHActionSheetDelegate> delegate;
/** 标题 */
@property (strong, nonatomic) NSString *title;
/** 取消按钮标题 */
@property (strong, nonatomic) NSString *cancelButtonTitle;

/**
 *  初始化WHActionSheet
 *
 *  @param title             标题
 *  @param delegate          代理
 *  @param cancelButtonTitle 取消按钮标题
 *  @param otherButtonTitles 其他按钮标题
 *
 *  @return 一个新的初始化的ActionSheet
 */
- (id)initWithTitle:(NSString *)title delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

/**
 *  设置标题的字体和颜色. 默认字体颜色是黑色, 字体大小是15
 *
 *  @param color 标题颜色
 *  @param size  标题字体大小
 */
- (void)setTitleColor:(UIColor *)color fontSize:(CGFloat)size;

/**
 *  设置按钮的标题字体和颜色以及按钮的背景颜色. 默认按钮标题颜色是黑色, 按钮背景颜色是白色, 按钮上字体大小是14
 *
 *  @param color   按钮标题颜色
 *  @param bgcolor 按钮背景颜色
 *  @param size    按钮字体大小
 *  @param index   按钮索引
 */
- (void)setButtonTitleColor:(UIColor *)color bgColor:(UIColor *)bgcolor fontSize:(CGFloat)size atIndex:(int)index;

/**
 *  设置取消按钮的标题字体和颜色以及按钮的背景颜色. 默认按钮标题颜色是红色, 按钮背景颜色是白色, 按钮上字体大小是14
 *
 *  @param color   取消按钮标题颜色
 *  @param bgcolor 取消按钮背景颜色
 *  @param size    取消按钮字体大小
 */
- (void)setCancelButtonTitleColor:(UIColor *)color bgColor:(UIColor *)bgcolor fontSize:(CGFloat)size;

/** 将Actionsheet显示在当前window */
- (void)show;

/** 添加按钮 */
- (NSInteger)addButtonWithTitle:(NSString *)title;

/** 容器视图图片 */
@property (nonatomic, strong) UIImage *contentViewImage;
/** 按钮容器视图背景颜色 */
@property (nonatomic, strong) UIColor *buttonContentViewBgColor;
/** 标题背景颜色 */
@property (nonatomic, strong) UIColor *titleLabelBgColor;


@end

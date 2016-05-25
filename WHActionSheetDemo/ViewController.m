//
//  ViewController.m
//  WHActionSheetDemo
//
//  Created by dengweihao on 15/8/5.
//  Copyright (c) 2015年 vcyber. All rights reserved.
//

#import "ViewController.h"
#import "WHActionSheet.h"
#import "Masonry.h"

#define WS(weakSelf) __weak typeof(self) weakSelf = self

@interface ViewController () <WHActionSheetDelegate>

@property (nonatomic, strong) UIButton *btn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *btn = [[UIButton alloc] init];
    btn.backgroundColor = [UIColor redColor];
    [btn setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:btn];
    [btn setTitle:@"显示ActionSheet" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(ActionSheetShow) forControlEvents:UIControlEventTouchUpInside];
    _btn = btn;
    
    WS(weakSelf);
    
    [_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weakSelf.view);
    }];
    [_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(weakSelf.view);
    }];
    [_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(200);
    }];
    [_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(30);
    }];
    
    self.view.backgroundColor = [UIColor greenColor];
}

- (void)ActionSheetShow
{
    WHActionSheet *sheet = [[WHActionSheet alloc] initWithTitle:@"自定义选择器" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"按钮1", @"按钮2", @"按钮3", nil];
    
    [sheet addButtonWithTitle:@"YES"];
    
    [sheet show];
}

/** 根据被点击按钮的索引处理点击事件 */
- (void)actionSheet:(WHActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"-----点击索引为 \"%ld\" 的按钮-----",(long)buttonIndex);
}

/** ActionSheet即将显示时 */
- (void)willPresentActionSheet:(WHActionSheet *)actionSheet
{
    NSLog(@"-----ActionSheet即将显示-----");
}

/** ActionSheet已经显示时 */
- (void)didPresentActionSheet:(WHActionSheet *)actionSheet
{
    NSLog(@"-----ActionSheet已经显示-----");
}

/** ActionSheet即将消失时 */
- (void)actionSheet:(WHActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSLog(@"-----ActionSheet点击了索引为 \"%ld\" 的按钮即将消失-----", (long)buttonIndex);
}

/** ActionSheet已经消失时 */
- (void)actionSheet:(WHActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSLog(@"-----ActionSheet点击了索引为 \"%ld\" 的按钮已经消失-----", (long)buttonIndex);
}


@end

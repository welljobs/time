//
//  CommandViewController.m
//  time
//
//  Created by mac on 2018/4/29.
//  Copyright © 2018年 1ge. All rights reserved.
//

#import "CommandViewController.h"
#import <YYText/YYText.h>
#import <Masonry/Masonry.h>
#import "UIColor+Helper.h"

#define Screen_TH        [UIScreen mainScreen].bounds.size.height
@interface CommandViewController ()
@property (nonatomic,strong) UIView *contentView;
@property (nonatomic,strong) YYTextView *cmdTextView;
@property (nonatomic,strong) UIButton *commentButton;
@property (nonatomic,copy) NSString *placeholder;
@property (nonatomic,copy) SuccessBlock success;
@end

@implementation CommandViewController

+ (instancetype)commandWithPlaceholder:(NSString *)placeholder success:(SuccessBlock)success {
    return [[self alloc] initWithPlaceholder:placeholder success:success];
}
- (instancetype)initWithPlaceholder:(NSString *)placeholder success:(SuccessBlock)success {
    self = [super init];
    if (self) {
        self.placeholder = placeholder;
        self.success = success;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    
    [self setupUI];
    [self setupLayout];
    [self addEventResponsors];
    
    
}
- (void)setupUI {
    self.contentView = [[UIView alloc] initWithFrame:CGRectZero];
    self.contentView.backgroundColor = [UIColor colorWithHex:0xF5F5F5];
    [self.view addSubview:self.contentView];
    
    self.cmdTextView = [[YYTextView alloc] init];
    self.cmdTextView.backgroundColor = [UIColor whiteColor];
    self.cmdTextView.placeholderText = self.placeholder;
    self.cmdTextView.placeholderFont = [UIFont systemFontOfSize:15];
    self.cmdTextView.font = [UIFont systemFontOfSize:15];
    [self.cmdTextView becomeFirstResponder];
    [self.contentView addSubview:self.cmdTextView];
    
    self.commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.commentButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
    [self.commentButton setTitle:@"发送" forState:UIControlStateNormal];
    [self.commentButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    self.commentButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.commentButton addTarget:self action:@selector(comment:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.commentButton];
}
- (void)setupLayout {
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(180);
    }];
    
    [self.commentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.right.mas_equalTo(-20);
        make.bottom.mas_equalTo(-10);
        make.size.mas_equalTo(CGSizeMake(80, 35));
    }];
    
    [self.cmdTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(10);
        make.bottom.equalTo(self.commentButton);
        make.right.mas_equalTo(self.commentButton.mas_left).mas_offset(-5);
    }];
}

- (void)addEventResponsors {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
- (void)comment:(id)sender {
    // 验证数据
#pragma make --
#warning ---验证数据，提示用户
    if (self.cmdTextView.text.length == 0) {
        //        [CRToastUtil showAttentionMessageWithText:@"请输入评论内容"];
        return;
    }
    //发送请求
    assert(self.success);
    self.success(self.cmdTextView.text);

    [self dismiss];
}

- (void)showInController:(UIViewController *)controller {
    if(controller && [controller isKindOfClass:[UIViewController class]]){
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        [keyWindow addSubview:self.view];
        [controller addChildViewController:self];
    }
}

- (void)dismiss {
    [UIView animateWithDuration:0.15 animations:^{

    }completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self dismiss];
}

#pragma mark - Keyboard Notification Action
- (void)keyboardWillShow:(NSNotification *)notification {
    CGFloat keyboardHeight = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    NSTimeInterval animationDuration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationOptions options = [notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] unsignedIntegerValue];
    
    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
    }];
    [UIView animateWithDuration:animationDuration delay:0 options:options animations:^{
        self.contentView.transform = CGAffineTransformMakeTranslation(0, -keyboardHeight);
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {

    }];
}
- (void)keyboardWillHide:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    NSTimeInterval animationDuration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationOptions options = [notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] unsignedIntegerValue];

    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-49);
    }];
    [UIView animateWithDuration:animationDuration delay:0 options:options animations:^{
        self.contentView.transform = CGAffineTransformIdentity;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {

    }];
}
@end

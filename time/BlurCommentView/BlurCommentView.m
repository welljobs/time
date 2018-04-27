//
//  JSGCommentView.m
//  blur_comment
//
//  Created by dai.fengyi on 15/5/15.
//  Copyright (c) 2015年 childrenOurFuture. All rights reserved.
//
#import "BlurCommentView.h"
#import "UIImageEffects.h"
#import "BRPlaceholderTextView.h"
#import "UIColor+Helper.h"
#define ANIMATE_DURATION    0.3f
#define kMarginWH           10
#define kButtonWidth        50
#define kButtonHeight       30
#define kTextViewHeight     100
#define kSheetViewHeight    (kMarginWH * 3 + kButtonHeight + kTextViewHeight)
#define FONT_15 [UIFont systemFontOfSize:15]
#define FONT_16 [UIFont systemFontOfSize:16]
@interface BlurCommentView ()
@property (strong, nonatomic) SuccessBlock success;
@property (weak, nonatomic) id<BlurCommentViewDelegate> delegate;
@property (strong, nonatomic) UIView *sheetView;
@property (strong, nonatomic) BRPlaceholderTextView *commentTextView;
@property (nonatomic,strong) UILabel *label;
@end
@implementation BlurCommentView
+ (void)commentshowInView:(UIView *)view withTitle:(NSString*)title success:(SuccessBlock)success delegate:(id <BlurCommentViewDelegate>)delegate
{
    BlurCommentView *commentView = [[BlurCommentView alloc] initWithFrame:view.bounds];
    if (commentView) {
        //挡住响应
        commentView.userInteractionEnabled = YES;
        //增加EventResponsor
        [commentView addEventResponsors];
        //block or delegate
        commentView.success = success;
        commentView.delegate = delegate;
        //截图并虚化
        //        commentView.image = [UIImageEffects imageByApplyingLightEffectToImage:[commentView snapShot:view]];
        commentView.backgroundColor = [UIColor colorWithHex:0x000000 alpha:0.8];
        [view addSubview:commentView];
        [view addSubview:commentView.sheetView];
        [commentView.commentTextView becomeFirstResponder];
    }
    if (title) {
        commentView.label.text = title;
    }
}
#pragma mark - 外部调用
+ (void)commentshowSuccess:(SuccessBlock)success withTitle:(NSString*)title
{
    [BlurCommentView commentshowInView:[UIApplication sharedApplication].keyWindow  withTitle:title success:success delegate:nil];
}
+ (void)commentshowDelegate:(id<BlurCommentViewDelegate>)delegate  withTitle:(NSString*)title
{
    [BlurCommentView commentshowInView:[UIApplication sharedApplication].keyWindow  withTitle:title success:nil delegate:delegate];
}
+ (void)commentshowInView:(UIView *)view success:(SuccessBlock)success  withTitle:(NSString*)title
{
    [BlurCommentView commentshowInView:view withTitle:title success:success delegate:nil];
}
+ (void)commentshowInView:(UIView *)view delegate:(id<BlurCommentViewDelegate>)delegate  withTitle:(NSString*)title
{
    [BlurCommentView commentshowInView:view withTitle:title success:nil delegate:delegate];
}
#pragma mark - 内部调用
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubviews];
    }
    return self;
}
- (void)initSubviews
{
    self.alpha = 0;
    CGRect rect = self.bounds;
    _sheetView = [[UIView alloc] initWithFrame:CGRectMake(0, rect.size.height - kSheetViewHeight, rect.size.width, kSheetViewHeight)];
    _sheetView.backgroundColor = [UIColor colorWithHex:0xF5F5F5];
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(kMarginWH, kMarginWH, kButtonWidth, kButtonHeight);
    cancelButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    cancelButton.titleLabel.font = FONT_15;
    [cancelButton addTarget:self action:@selector(cancelComment:) forControlEvents:UIControlEventTouchUpInside];
    [_sheetView addSubview:cancelButton];
    UIButton *commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    commentButton.frame = CGRectMake(_sheetView.bounds.size.width - kButtonWidth - kMarginWH, kMarginWH, kButtonWidth, kButtonHeight);
    commentButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
    [commentButton setTitle:@"发送" forState:UIControlStateNormal];
    [commentButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    commentButton.titleLabel.font = FONT_15;
    [commentButton addTarget:self action:@selector(comment:) forControlEvents:UIControlEventTouchUpInside];
    [_sheetView addSubview:commentButton];
    self.label = [[UILabel alloc] init];
    self.label.text = @"写评论";
    self.label.frame = CGRectMake((_sheetView.bounds.size.width - kButtonWidth) / 2, kMarginWH, kButtonWidth, kButtonHeight);
    self.label.font = FONT_16;
    self.label.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    [_sheetView addSubview:self.label];
    
    _commentTextView = [[BRPlaceholderTextView alloc] initWithFrame:CGRectMake(kMarginWH, _sheetView.bounds.size.height - kMarginWH - kTextViewHeight, rect.size.width - kMarginWH * 2, kTextViewHeight)];
    _commentTextView.text = nil;
    _commentTextView.font = [UIFont systemFontOfSize:14];
    self.commentTextView.placeholder = @"请输入评论";
    [self.commentTextView setPlaceholderColor:[UIColor colorWithHex:0xD0D0D0]];
    [_sheetView addSubview:_commentTextView];
}
- (UIImage *)snapShot:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, YES, 0.0f);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
- (void)addEventResponsors
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
#pragma mark - Botton Action
- (void)cancelComment:(id)sender {
    [_sheetView endEditing:YES];
}
- (void)comment:(id)sender {
    // 验证数据
#pragma make --
#warning ---验证数据，提示用户
    if (_commentTextView.text.length == 0) {
//        [CRToastUtil showAttentionMessageWithText:@"请输入评论内容"];
        return;
    }
    //发送请求
    if (_success) {
        _success(_commentTextView.text);
    }
    if ([_delegate respondsToSelector:@selector(commentDidFinished:)]) {
        [_delegate commentDidFinished:_commentTextView.text];
    }
    [_sheetView endEditing:YES];
}
- (void)dismissCommentView
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self removeFromSuperview];
    [_sheetView removeFromSuperview];
}
#pragma mark - Keyboard Notification Action
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    NSLog(@"%@", aNotification);
    CGFloat keyboardHeight = [[aNotification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    NSTimeInterval animationDuration = [[aNotification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:animationDuration animations:^{
        self.alpha = 1;
        _sheetView.frame = CGRectMake(0, self.superview.bounds.size.height - _sheetView.bounds.size.height - keyboardHeight, _sheetView.bounds.size.width, kSheetViewHeight);
    } completion:nil];
}
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    NSDictionary *userInfo = [aNotification userInfo];
    NSTimeInterval animationDuration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:animationDuration animations:^{
        self.alpha = 0;
        _sheetView.frame = CGRectMake(0, self.superview.bounds.size.height, _sheetView.bounds.size.width, kSheetViewHeight);
    } completion:^(BOOL finished){
        [self dismissCommentView];
    }];
}
@end

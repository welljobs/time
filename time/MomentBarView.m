//
//  MomentBarView.m
//  time
//
//  Created by mac on 2018/4/29.
//  Copyright © 2018年 1ge. All rights reserved.
//

#import "MomentBarView.h"
#import "UIColor+Helper.h"

// 标题滚动视图的高度
static CGFloat const TitleScrollViewHeight = 45;
// 默认标题间距
static CGFloat const margin = 20;
// 标题缩放比例
static CGFloat const TitleTransformScale = 1.3;
// 下划线默认高度
static CGFloat const underLineHeight = 2.5;
// 下划线默认宽度
static CGFloat const underLineWidth = 20;

static NSInteger const tagBaseValue = 1000;

@interface MomentBarView ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *titleScrollView;
/**
 标题滚动视图背景颜色
 */
@property (nonatomic, strong) UIColor *titleScrollViewColor;


/**
 标题高度
 */
@property (nonatomic, assign) CGFloat titleHeight;

/**
 标题宽度
 */
@property (nonatomic, assign) CGFloat titleWidth;


/**
 正常标题颜色
 */
@property (nonatomic, strong) UIColor *norColor;

/**
 选中标题颜色
 */
@property (nonatomic, strong) UIColor *selColor;
/** 记录是否点击 */
@property (nonatomic, assign) BOOL isClickTitle;

/**
 标题字体
 */
@property (nonatomic, strong) UIFont *titleFont;

/** 所以标题数组 */
@property (nonatomic, strong) NSMutableArray *titleLabels;
/** 所以竖线数组 */
@property (nonatomic, strong) NSMutableArray *lines;
/** 是否显示竖线 */
@property (nonatomic, assign) BOOL isShowVerticalLine;
/** 所以标题宽度数组 */
@property (nonatomic, strong) NSMutableArray *titleWidths;

/** 下标视图 */
@property (nonatomic, weak) UIView *underLine;
/** 标题间距 */
@property (nonatomic, assign) CGFloat titleMargin;
/** 计算上一次选中角标 */
@property (nonatomic, assign) NSInteger selIndex;
@end

@implementation MomentBarView
#pragma mark - 懒加载

- (UIFont *)titleFont
{
    if (_titleFont == nil) {
        _titleFont = [UIFont systemFontOfSize:16];
    }
    return _titleFont;
}


- (NSMutableArray *)titleWidths
{
    if (_titleWidths == nil) {
        _titleWidths = [NSMutableArray array];
    }
    return _titleWidths;
}

- (UIColor *)norColor
{
    if (_norColor == nil) {
        self.norColor = [UIColor blackColor];
    }
    return _norColor;
}

- (UIColor *)selColor
{
    if (_selColor == nil) {
        self.selColor = [UIColor redColor];
    }
    return _selColor;
}



- (NSMutableArray *)titleLabels
{
    if (_titleLabels == nil) {
        _titleLabels = [NSMutableArray array];
    }
    return _titleLabels;
}

- (NSMutableArray *)lines {
    if (_lines == nil) {
        _lines = [NSMutableArray array];
    }
    return _lines;
}
// 懒加载标题滚动视图
- (UIScrollView *)titleScrollView
{
    if (_titleScrollView == nil) {
        
        UIScrollView *titleScrollView = [[UIScrollView alloc] init];
        titleScrollView.scrollsToTop = NO;
        titleScrollView.backgroundColor = _titleScrollViewColor?_titleScrollViewColor:[UIColor whiteColor];
        
        [self addSubview:titleScrollView];
        
        _titleScrollView = titleScrollView;
        
    }
    return _titleScrollView;
}
#pragma mark - 添加标题方法
// 计算所有标题宽度
- (void)setUpTitleWidth
{
    // 判断是否能占据整个屏幕
    NSUInteger count = self.viewControllerArray.count;
    
    NSArray *titles = self.viewControllerArray.copy;
    
    [self.titleWidths removeAllObjects];
    
    CGFloat totalWidth = 0;
    
    // 计算所有标题的宽度
    for (NSString *title in titles) {
        
        if ([title isKindOfClass:[NSNull class]]) {
            // 抛异常
            NSException *excp = [NSException exceptionWithName:@"DisplayViewControllerException" reason:@"没有设置Controller.title属性，应该把子标题保存到对应子控制器中" userInfo:nil];
            [excp raise];
            
        }
        
        CGRect titleBounds = [title boundingRectWithSize:CGSizeMake(MAXFLOAT, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.titleFont} context:nil];
        
        CGFloat width = titleBounds.size.width;
        
        [self.titleWidths addObject:@(width)];
        
        totalWidth += width;
    }
    
    if (totalWidth > self.frame.size.width) {
        
        _titleMargin = margin;
        
        self.titleScrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, _titleMargin);
        
        return;
    }
    
    CGFloat titleMargin = (self.frame.size.width - totalWidth) / (count + 1);
    
    _titleMargin = titleMargin < margin? margin: titleMargin;
    
    self.titleScrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, _titleMargin);
}


// 设置所有标题
- (void)setUpAllTitle
{
    
    // 遍历所有的子控制器
    NSUInteger count = self.viewControllerArray.count;
    
    // 添加所有的标题
    CGFloat labelW = _titleWidth;
    CGFloat labelH = self.titleHeight;
    CGFloat labelX = 0;
    CGFloat labelY = 0;
    
    for (int i = 0; i < count; i++) {
        
//        UIViewController *vc = self.childViewControllers[i];
        
        UILabel *label = [[UILabel alloc] init];
        label.userInteractionEnabled = YES;
        label.tag = i;
        
        // 设置按钮的文字颜色
        label.textColor = self.norColor;
        
        label.font = self.titleFont;
        
        // 设置按钮标题
        label.text = self.viewControllerArray[i];
        UIView *line = [[UIView alloc] initWithFrame:CGRectZero];
        line.tag = tagBaseValue + i;
        line.backgroundColor = [UIColor colorWithHex:0XCBDCFF];
        
        if (_titleWidth == 0) { // 填充样式才需要
            labelW = [self.titleWidths[i] floatValue];
            
            // 设置按钮位置
            UILabel *lastLabel = [self.titleLabels lastObject];
            
            labelX = _titleMargin + CGRectGetMaxX(lastLabel.frame);
        } else {
            
            labelX = i * labelW;
        }
        
        label.frame = CGRectMake(labelX, labelY, labelW, labelH);
        CGFloat lineX = 0.0;
        if (i == 0) {
            lineX = labelX - _titleMargin;
            line.hidden = YES;
        } else {
            lineX = labelX - _titleMargin/2;
            line.hidden = NO;
        }
        line.frame = CGRectMake(lineX, labelY, .5, 15);
        
        CGPoint lineCenter = line.center;
        lineCenter.y = label.center.y;
        line.center = lineCenter;
        
        // 监听标题的点击
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleClick:)];
        [label addGestureRecognizer:tap];
        
        // 保存到数组
        [self.titleLabels addObject:label];
        [self.lines addObject:line];
        [_titleScrollView addSubview:label];
        [self.titleScrollView addSubview:line];
        
        if (i == _selectIndex) {
            [self titleClick:tap];
        }
    }
    
    // 设置标题滚动视图的内容范围
    UILabel *lastLabel = self.titleLabels.lastObject;
    _titleScrollView.contentSize = CGSizeMake(CGRectGetMaxX(lastLabel.frame), 0);
    _titleScrollView.showsHorizontalScrollIndicator = NO;
    
//    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.titleHeight-.5, self.frame.size.width, .5)];
//    lineView.backgroundColor = [UIColor colorWithHex:0xe3ecfe];
//    [self.titleScrollView addSubview:lineView];
    
}
// 一次性设置所有标题属性
- (void)setUpTitleEffect:(void(^)(UIColor **titleScrollViewColor,UIColor **norColor,UIColor **selColor,UIFont **titleFont,CGFloat *titleHeight,CGFloat *titleWidth))titleEffectBlock{
    UIColor *titleScrollViewColor;
    UIColor *norColor;
    UIColor *selColor;
    UIFont *titleFont;
    if (titleEffectBlock) {
        titleEffectBlock(&titleScrollViewColor,&norColor,&selColor,&titleFont,&_titleHeight,&_titleWidth);
        if (norColor) {
            self.norColor = norColor;
        }
        if (selColor) {
            self.selColor = selColor;
        }
        if (titleScrollViewColor) {
            _titleScrollViewColor = titleScrollViewColor;
        }
        _titleFont = titleFont;
    }
    
    if (_titleWidth > 0) {
        @throw [NSException exceptionWithName:@"ERROR" reason:@"标题颜色填充不需要设置标题宽度" userInfo:nil];
    }
    
}
- (instancetype)init {
    self = [super init];
    if (self) {
        self.titleHeight = 45;
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    // 顶部标题View尺寸
    self.titleScrollView.frame = CGRectMake(0, 0, self.frame.size.width, self.titleHeight);
    [self setUpTitleWidth];
    [self setUpAllTitle];
}

// 标题按钮点击
- (void)titleClick:(UITapGestureRecognizer *)tap
{
    // 记录是否点击标题
    _isClickTitle = YES;
    
    // 获取对应标题label
    UILabel *label = (UILabel *)tap.view;
    
    // 获取当前角标
    NSInteger i = label.tag;
    
    // 选中label
    [self selectLabel:label];
    
    // 内容滚动视图滚动到对应位置
    CGFloat offsetX = i * self.frame.size.width;
    
//    self.contentScrollView.contentOffset = CGPointMake(offsetX, 0);
//    
//    // 记录上一次偏移量,因为点击的时候不会调用scrollView代理记录，因此需要主动记录
//    _lastOffsetX = offsetX;
//    
//    // 添加控制器
//    UIViewController *vc = self.childViewControllers[i];
//    
//    // 判断控制器的view有没有加载，没有就加载，加载完在发送通知
//    if (vc.view) {
//        // 发出通知点击标题通知
//        [[NSNotificationCenter defaultCenter] postNotificationName:DisplayViewClickOrScrollDidFinshNotification  object:vc];
//        
//    }
    // 发出重复点击标题通知
    if (_selIndex == i) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:DisplayViewRepeatClickTitleNotification object:vc];
    }
    
    _selIndex = i;
//    self.currentPage = i;
    // 点击事件处理完成
    _isClickTitle = NO;
}
- (void)selectLabel:(UILabel *)label
{
    
    for (UILabel *labelView in self.titleLabels) {
        
//        if (label == labelView) continue;
        
//        if (_isShowTitleGradient) {
//            
//        }
        labelView.transform = CGAffineTransformIdentity;
        
        labelView.textColor = self.norColor;
        
//        if (_isShowTitleGradient && _titleColorGradientStyle == TitleColorGradientStyleFill) {
//            
//            labelView.fillColor = self.norColor;
//            
//            labelView.progress = 1;
//        }
        
    }
    
    // 标题缩放
//    if (_isShowTitleScale) {
//        
//        CGFloat scaleTransform = _titleScale?_titleScale:TitleTransformScale;
//        
//        label.transform = CGAffineTransformMakeScale(scaleTransform, scaleTransform);
//    }
    
    // 修改标题选中颜色
    label.textColor = self.selColor;
    
    // 设置标题居中
    [self setLabelTitleCenter:label];
    
    // 设置下标的位置
//    if (_isShowUnderLine) {
//        [self setUpUnderLine:label];
//    }
//    
//    // 设置cover
//    if (_isShowTitleCover) {
//        [self setUpCoverView:label];
//    }
    
}
// 让选中的按钮居中显示
- (void)setLabelTitleCenter:(UILabel *)label
{
    
    // 设置标题滚动区域的偏移量
    CGFloat offsetX = label.center.x - self.frame.size.width * 0.5;
    
    if (offsetX < 0) {
        offsetX = 0;
    }
    
    // 计算下最大的标题视图滚动区域
    CGFloat maxOffsetX = self.titleScrollView.contentSize.width - self.frame.size.width + _titleMargin;
    
    if (maxOffsetX < 0) {
        maxOffsetX = 0;
    }
    
    if (offsetX > maxOffsetX) {
        offsetX = maxOffsetX;
    }
    
    // 滚动区域
    [self.titleScrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    
}
#pragma mark - UIScrollViewDelegate

// 减速完成
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat offsetX = scrollView.contentOffset.x;
    NSInteger offsetXInt = offsetX;
    NSInteger screenWInt = self.frame.size.width;
    
    NSInteger extre = offsetXInt % screenWInt;
    if (extre > self.frame.size.width * 0.5) {
        // 往右边移动
        offsetX = offsetX + (self.frame.size.width - extre);
//        _isAniming = YES;
    }else if (extre < self.frame.size.width * 0.5 && extre > 0){
//        _isAniming = YES;
        // 往左边移动
        offsetX =  offsetX - extre;
    }
    
//    [self.contentScrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
//    // 获取角标
    NSInteger i = offsetX / self.frame.size.width;
//    self.currentPage = i;
    // 选中标题
    [self selectLabel:self.titleLabels[i]];
    // 取出对应控制器发出通知
//    UIViewController *vc = self.childViewControllers[i];
//    // 发出通知
//    [[NSNotificationCenter defaultCenter] postNotificationName:DisplayViewClickOrScrollDidFinshNotification object:vc];
}


// 监听滚动动画是否完成
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
//    _isAniming = NO;
//    self.currentPage = (NSInteger)((scrollView.contentOffset.x) / self.view.width);;
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
//    if (self.dragingFollow) {
        // 获取角标
        NSInteger i = scrollView.contentOffset.x / self.frame.size.width;
        [self setLabelTitleCenter:self.titleLabels[i]];
//    }
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 点击和动画的时候不需要设置
//    if (_isAniming || self.titleLabels.count == 0) return;
    
    // 获取偏移量
    CGFloat offsetX = scrollView.contentOffset.x;
    
    // 获取左边角标
    NSInteger leftIndex = offsetX / self.frame.size.width;
    
    // 左边按钮
    UILabel *leftLabel = self.titleLabels[leftIndex];
    
    // 右边角标
    NSInteger rightIndex = leftIndex + 1;
    
    // 右边按钮
    UILabel *rightLabel = nil;
    
    if (rightIndex < self.titleLabels.count) {
        rightLabel = self.titleLabels[rightIndex];
    }
    
    // 字体放大
//    [self setUpTitleScaleWithOffset:offsetX rightLabel:rightLabel leftLabel:leftLabel];
    
    // 设置下标偏移
//    if (_isDelayScroll == NO) { // 延迟滚动，不需要移动下标
//        
//        [self setUpUnderLineOffset:offsetX rightLabel:rightLabel leftLabel:leftLabel];
//    }
    
    // 设置遮盖偏移
//    [self setUpCoverOffset:offsetX rightLabel:rightLabel leftLabel:leftLabel];
    
    // 设置标题渐变
//    [self setUpTitleColorGradientWithOffset:offsetX rightLabel:rightLabel leftLabel:leftLabel];
    
    // 记录上一次的偏移量
//    _lastOffsetX = offsetX;
    
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
}


@end

//
//  CircleViewController.m
//  time
//
//  Created by mac on 2018/4/26.
//  Copyright © 2018年 1ge. All rights reserved.
//

#import "CircleViewController.h"
#import "MomentViewController.h"
#import "MomentPageView.h"
#import "Masonry.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "SynchronizeScrollTop.h"
#import "MomentBarView.h"
#import "UIColor+Helper.h"
@interface CircleViewController ()
@property (nonatomic, strong) UIScrollView *backgroundScrollView;
@property (nonatomic, strong) MomentPageView *contentView;
@property (nonatomic, strong) UIImageView *bgmView;
@property (nonatomic, strong) MomentBarView *segmentBarView;
@property (nonatomic, strong) MomentViewController *currentController;


@end

@implementation CircleViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupBackground];
    
    [self setupPageScroll];
    
    [self setupLayout];
}

- (void)setupBackground {
    self.backgroundScrollView = [[UIScrollView alloc] init];
    self.backgroundScrollView.contentSize =  CGSizeMake(0, Screen_H - 49 - 64 + 100);
    self.backgroundScrollView.backgroundColor = [UIColor yellowColor];
    
    self.bgmView = [[UIImageView alloc] init];
    self.bgmView.backgroundColor = [UIColor redColor];
    
    self.segmentBarView = [[MomentBarView alloc] init];
    self.segmentBarView.viewControllerArray = @[@"全部",@"圈子",@"社区"];
    self.segmentBarView.backgroundColor = [UIColor greenColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.segmentBarView setUpTitleEffect:^(UIColor *__autoreleasing *titleScrollViewColor, UIColor *__autoreleasing *norColor, UIColor *__autoreleasing *selColor, UIFont *__autoreleasing *titleFont, CGFloat *titleHeight, CGFloat *titleWidth) {
        *norColor = [UIColor colorWithHex:0X1A192B];
        *selColor = [UIColor colorWithHex:0XFFC000];
    }];
}

- (void)setupPageScroll {
    NSMutableArray *controllerArray = [NSMutableArray array];
    NSArray *title = @[@"全部",@"圈子",@"社区"];
    for (NSInteger i = 0; i < title.count; i++) {
        
        self.currentController = [[MomentViewController alloc] init];
        self.currentController.type = i;
        [controllerArray addObject:self.currentController];
        
        [[self.currentController rac_signalForSelector:@selector(scrollViewDidScroll:)] subscribeNext:^(id x) {
            UIScrollView *scrollView = [x first];
            [SynchronizeScrollTop synchronizeBottomScrollView:scrollView TopScrollView:self.backgroundScrollView top:100];
            
        }];

    }
    self.contentView = [[MomentPageView alloc] initWithHeight:Screen_H - 64 - 49 - 100 - 45 - 1];
    self.contentView.viewControllerArray = controllerArray;
    
    self.contentView.scrollToIndexBlock = ^(NSInteger index) {
//        self.segmentBarView.selectIndex = index;
        NSLog(@"-------%lu",index);
    };

}


#pragma mark - Layout
- (void)setupLayout {
    [self.view addSubview:self.backgroundScrollView];
    [self.backgroundScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view);
        make.top.mas_equalTo(64);
        make.left.right.offset = 0;
        make.bottom.mas_equalTo(-49);
        make.width.mas_equalTo(Screen_W);
        make.height.mas_equalTo(Screen_H - 49 - 64);
    }];
    [self.backgroundScrollView addSubview:self.bgmView];
    [self.bgmView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(100);
        make.width.mas_equalTo(Screen_W);
    }];
    [self.backgroundScrollView addSubview:self.segmentBarView];
    [self.segmentBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.equalTo(self.bgmView.mas_bottom);
        make.height.mas_equalTo(45);
    }];
    [self.backgroundScrollView insertSubview:self.contentView belowSubview:self.segmentBarView];

    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.segmentBarView.mas_bottom);
        make.left.bottom.right.mas_equalTo(0);
        make.height.mas_equalTo(Screen_H - 64 - 49 - 45 - 100 - 1);
    }];
//    [self.segmentBarView layoutIfNeeded];
}
@end

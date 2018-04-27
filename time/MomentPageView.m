//
//  MomentPageView.m
//  time
//
//  Created by mac on 2018/4/26.
//  Copyright © 2018年 1ge. All rights reserved.
//

#import "MomentPageView.h"
#import "MomentViewController.h"
#import <Masonry.h>

static NSString *kCollectionViewIdentifier = @"CollectionViewIdentifier";

@interface MomentPageView () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *collectionLayout;
@property (nonatomic, assign) CGFloat viewHeight;
@end
@implementation MomentPageView

#pragma mark - Init
- (instancetype)initWithHeight:(CGFloat)height {
    if (self = [super init]) {
        self.viewHeight = height;
        [self setupUI];
        [self setupLayout];
        [self registerNotification];
    }
    return self;
}

#pragma mark - UI
- (void)setupUI {
    self.contentView = [[UIView alloc] init];
    
    self.collectionLayout = [UICollectionViewFlowLayout new];
    self.collectionLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionLayout.minimumInteritemSpacing = 0;
    self.collectionLayout.minimumLineSpacing = 0;
    self.collectionLayout.itemSize = CGSizeMake(Screen_W, self.viewHeight);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.collectionLayout];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.userInteractionEnabled = YES;
    self.collectionView.pagingEnabled = YES;
    self.collectionView.clipsToBounds = NO;
    self.collectionView.bounces = NO;
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kCollectionViewIdentifier];
}

#pragma mark - Layout
- (void)setupLayout {
    [self addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    [self.contentView addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

#pragma mark - Notification
- (void)registerNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(titleViewDidScroll:) name:TitleDidScrollNotification object:nil];
}

- (void)titleViewDidScroll:(NSNotification *)notification {
    NSInteger index = [(NSString *)notification.object integerValue];
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    //[self selecteItemAt:index];
    BLOCK_EXEC(self.scrollToIndexBlock, index);
    UIViewController *vc = self.viewControllerArray[index];
    [[NSNotificationCenter defaultCenter] postNotificationName:ContentFirstLaunchNotification object:vc];
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.viewControllerArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCollectionViewIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [self randomColor];
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    UIViewController *vc = self.viewControllerArray[indexPath.row];
    vc.view.frame = CGRectMake(0, 0, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
    [cell.contentView addSubview:vc.view];
    
    return cell;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat offSetX = scrollView.contentOffset.x;
    NSInteger index = offSetX / Screen_W;
    
    MomentViewController *vc = self.viewControllerArray[index];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ContentFirstLaunchNotification object:vc];
    [[NSNotificationCenter defaultCenter] postNotificationName:ContentDidScrollNotification object:[NSString stringWithFormat:@"%ld", (long)index]];
    BLOCK_EXEC(self.scrollToIndexBlock, index);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    SAFE_CALL_OneParam(self.delegate, scrollViewDidScroll, scrollView);
//    if (self.delegate && [self.delegate respondsToSelector:@selector(didScrollView:)]) {
//        [self.delegate didScrollView:scrollView];
//    }
}

#pragma mark - Helper
-(UIColor *)randomColor {
    CGFloat hue = ( arc4random() % 256 / 256.0 );
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;
    UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
    return color;
}

@end

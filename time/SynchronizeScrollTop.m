//
//  SynchronizeScrollTop.m
//  time
//
//  Created by mac on 2018/4/27.
//  Copyright © 2018年 1ge. All rights reserved.
//

#import "SynchronizeScrollTop.h"


@implementation SynchronizeScrollTop
+ (void)synchronizeBottomScrollView:(UIScrollView *)bottomScrollView TopScrollView:(UIScrollView *)topScrollView top:(CGFloat)top {
    CGFloat by = bottomScrollView.contentOffset.y;
    CGFloat ty = topScrollView.contentOffset.y;
    if (ty < top && by > 0) {
        topScrollView.contentOffset = CGPointMake(0, ty + by);
        bottomScrollView.contentOffset = CGPointZero;
    }
    else if (ty > 0 && by < 0){
        topScrollView.contentOffset = CGPointMake(0, ty + by);
        bottomScrollView.contentOffset = CGPointZero;
    }
    if (ty > top) {
        topScrollView.contentOffset = CGPointMake(0, top);
    }
    if (ty < 0) {
        topScrollView.contentOffset = CGPointMake(0, 0);
    }
}
@end

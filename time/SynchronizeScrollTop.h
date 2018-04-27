//
//  SynchronizeScrollTop.h
//  time
//
//  Created by mac on 2018/4/27.
//  Copyright © 2018年 1ge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SynchronizeScrollTop : NSObject
+ (void)synchronizeBottomScrollView:(UIScrollView *)bottomScrollView TopScrollView:(UIScrollView *)topScrollView top:(CGFloat)top;
@end

//
//  MomentBarView.h
//  time
//
//  Created by mac on 2018/4/29.
//  Copyright © 2018年 1ge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MomentBarView : UIView
/**
 根据角标，选中对应的控制器
 */
@property (nonatomic, assign) NSInteger selectIndex;
@property (nonatomic, strong) NSArray *viewControllerArray;
/***********************************【顶部标题样式】********************************/
- (void)setUpTitleEffect:(void(^)(UIColor **titleScrollViewColor,UIColor **norColor,UIColor **selColor,UIFont **titleFont,CGFloat *titleHeight,CGFloat *titleWidth))titleEffectBlock;
@end

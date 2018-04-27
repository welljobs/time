//
//  MomentViewController.h
//  time
//
//  Created by mac on 2018/4/26.
//  Copyright © 2018年 1ge. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSUInteger, MomentType) {
    MomentFriendType = 0,
    MomentCicleType,
    MomentGroupType
};

@interface MomentViewController : UIViewController
@property (nonatomic, assign) MomentType type;
@end

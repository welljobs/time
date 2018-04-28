//
//  CommandViewController.h
//  time
//
//  Created by mac on 2018/4/29.
//  Copyright © 2018年 1ge. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SuccessBlock)(NSString *commentText);

@interface CommandViewController : UIViewController
+ (instancetype)commandWithPlaceholder:(NSString *)placeholder success:(SuccessBlock)success;
- (instancetype)initWithPlaceholder:(NSString *)placeholder success:(SuccessBlock)success;
- (void)showInController:(UIViewController *)controller;
@end

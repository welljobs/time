//
//  MomentPageView.h
//  time
//
//  Created by mac on 2018/4/26.
//  Copyright © 2018年 1ge. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SAFE_CALL_OneParam(obj,method,firstParam) \
([obj respondsToSelector:@selector(method:)] ? [obj method:firstParam] : nil)

#define BLOCK_EXEC(block, ...) if (block) { block(__VA_ARGS__); };
#define Screen_TH        [UIScreen mainScreen].bounds.size.height
#define Screen_TW        [UIScreen mainScreen].bounds.size.width

#define Screen_H        (Screen_TH > Screen_TW? Screen_TH: Screen_TW)
#define Screen_W        (Screen_TH > Screen_TW? Screen_TW: Screen_TH)


static NSString *ContentDidScrollNotification = @"ContentDidScrollNotification";
static NSString *ContentFirstLaunchNotification = @"ContentFirstLaunchNotification";
static NSString *TitleDidScrollNotification = @"TitleDidScrollNotification";

@protocol MomentPageViewDelegate <NSObject>
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
@end

@interface MomentPageView : UIView
@property (nonatomic, weak) id<MomentPageViewDelegate> delegate;
@property (nonatomic, strong) NSArray *viewControllerArray;
@property (nonatomic, copy) void(^scrollToIndexBlock)(NSInteger index);
- (instancetype)initWithHeight:(CGFloat)height;
@end

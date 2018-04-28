//
//  FHMessageInputView.h
//  time
//
//  Created by mac on 2018/4/28.
//  Copyright © 2018年 1ge. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, UIMessageInputViewContentType) {
    UIMessageInputViewContentTypePhoto = 0,
    UIMessageInputViewContentTypeVideo,
    UIMessageInputViewContentTypeForward
};

@interface FHMessageInputView : UIView
@property (assign, nonatomic) UIMessageInputViewContentType contentType;

@end

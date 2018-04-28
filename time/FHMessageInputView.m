//
//  FHMessageInputView.m
//  time
//
//  Created by mac on 2018/4/28.
//  Copyright © 2018年 1ge. All rights reserved.
//

#import "FHMessageInputView.h"
#import <YYText/YYText.h>

@interface FHMessageInputView ()
@property (nonatomic, strong) YYTextView *inputTextView;
@property (strong, nonatomic) UICollectionView *mediaView;
@property (strong, nonatomic) NSMutableArray *mediaArray;
@end

@implementation FHMessageInputView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}


@end

//
//  FHMessageMediaCell.h
//  time
//
//  Created by mac on 2018/4/29.
//  Copyright © 2018年 1ge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FHMessageMediaCell : UICollectionViewCell
@property (copy, nonatomic) void (^deleteBlock)(NSObject *toDelete);
- (void)setCurMedia:(NSObject *)curMedia totalCount:(NSInteger)totalCount;
@end

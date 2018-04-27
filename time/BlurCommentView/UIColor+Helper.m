//
//  UIColor+Helper.m
//  time
//
//  Created by mac on 2018/4/27.
//  Copyright © 2018年 1ge. All rights reserved.
//

#import "UIColor+Helper.h"

@implementation UIColor (Helper)
+ (UIColor *)colorWithHex:(int)hexValue alpha:(CGFloat)alpha
{
    return [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0
                           green:((float)((hexValue & 0xFF00) >> 8))/255.0
                            blue:((float)(hexValue & 0xFF))/255.0
                           alpha:alpha];
}
+ (UIColor *)colorWithHex:(int)hexValue
{
    return [UIColor colorWithHex:hexValue alpha:1.0];
}
@end

//
//  RCTConvert+StatusBarAnimation.m
//  NativeExchangeProject
//
//  Created by Mr.GCY on 2018/3/22.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import "RCTConvert+StatusBarAnimation.h"

@implementation RCTConvert (StatusBarAnimation)
//RCT_ENUM_CONVERTER(type, values, default, getter)
RCT_ENUM_CONVERTER(CYStatusBarAnimation,
                   (@{
                      @"statusBarAnimationNone" :@(CYStatusBarAnimationNone),
                      @"statusBarAnimationFade" : @(CYStatusBarAnimationFade),
                      @"statusBarAnimationSlide" : @(CYStatusBarAnimationSlide)}),
                   CYStatusBarAnimationNone,
                   integerValue)
@end

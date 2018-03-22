//
//  RCTConvert+StatusBarAnimation.h
//  NativeExchangeProject
//
//  Created by Mr.GCY on 2018/3/22.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import <React/RCTConvert.h>

typedef NS_ENUM(NSInteger, CYStatusBarAnimation) {
  CYStatusBarAnimationNone,
  CYStatusBarAnimationFade,
  CYStatusBarAnimationSlide,
};

@interface RCTConvert (StatusBarAnimation)

@end

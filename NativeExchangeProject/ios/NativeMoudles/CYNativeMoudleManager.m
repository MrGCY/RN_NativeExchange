//
//  CYNativeMoudleManager.m
//  RNComponentProject
//
//  Created by Mr.GCY on 2018/3/22.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import "CYNativeMoudleManager.h"
#import "RCTConvert+StatusBarAnimation.h"
@interface CYNativeMoudleManager()

@end
@implementation CYNativeMoudleManager

//2.为了实现该协议,需要含有一个宏:RCT_EXPORT_MODULE(),
RCT_EXPORT_MODULE();
//使用原生定义的常量
-(NSDictionary *)constantsToExport
{
    return @{ @"data": @"我是从原生定义的~",
              @"statusBarAnimationNone" : @(CYStatusBarAnimationNone),
              @"statusBarAnimationFade" : @(CYStatusBarAnimationFade),
              @"statusBarAnimationSlide" : @(CYStatusBarAnimationSlide)
              };
}

// 接收React传递过来的数据 NSString
RCT_EXPORT_METHOD(receiveForReactSendData:(NSString *)name){
  NSLog(@"接收传过来的NSString: %@", name);
  [CYNativeMoudleManager alertMsg:name];
}

// 接收React传递过来的数据 NSString + NSDictionary
RCT_EXPORT_METHOD(receiveForReactSendWithDicData:(NSString *)name andDetail: (NSDictionary *)detailDic){
  NSLog(@"接收传过来的NSString + NSDictionary: %@-----%@", name , detailDic);
  [CYNativeMoudleManager alertMsg:[NSString stringWithFormat:@"%@----%@",name,detailDic]];
}

// 接收React传递过来的数据 NSString + NSDate
RCT_EXPORT_METHOD(receiveForReactSendWithDate:(NSString *)name andDate: (NSDate *)date){
  //内部进行了类型转换 或者可以使用[RCTConvert NSDate:secondsSinceUnixEpoch]进行转换
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
  [formatter setDateFormat:@"yyyy-MM-dd"];
  [CYNativeMoudleManager alertMsg:[NSString stringWithFormat:@"%@----%@",name,[formatter stringFromDate:date]]];
}

// 原生函数回调 如果你传递了回调函数，那么在原生端就必须执行它
RCT_EXPORT_METHOD(receiveForReactSendWithDateAndSuccessCallBack:(NSString *)name andSuccessCallBack: (RCTResponseSenderBlock)successCallBack){
  [CYNativeMoudleManager alertMsg:[NSString stringWithFormat:@"数据展示%@",name]];
  successCallBack(@[@"成功",@{@"status" : @1,@"data" : @"原生函数回调并且是多参数返回的"}]);
}

//Promises
//  对外提供调用方法,演示Promise使用   resolver成功回调 rejecter失败回调
RCT_REMAP_METHOD(receiveForReactSendCallbackEvents,
                 name:(NSString *)name
                 resolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject)
{
    [CYNativeMoudleManager alertMsg:[NSString stringWithFormat:@"数据展示%@",name]];
    NSArray *events = nil;//@[@"one ",@"two ",@"three"];//准备回调回去的数据
    if (events) {
      resolve(events);
    } else {
      NSError *error=[NSError errorWithDomain:@"我是Promise回调错误信息..." code:101 userInfo:nil];
      reject(@"no_events", @"There were no events", error);
    }
}

//枚举常量  用NS_ENUM定义的枚举类型必须要先扩展对应的RCTConvert方法才可以作为函数参数传递。
RCT_EXPORT_METHOD(updateStatusBarAnimation:(CYStatusBarAnimation)animation
                  completion:(RCTResponseSenderBlock)callback){
  NSString * msg = @"";
  switch (animation) {
    case CYStatusBarAnimationFade:
      msg = @"使用折叠效果";
      break;
    case CYStatusBarAnimationNone:
      msg = @"没有使用效果";
      break;
    case CYStatusBarAnimationSlide:
      msg = @"使用滑动效果";
      break;
    default:
      break;
  }
  [CYNativeMoudleManager alertMsg:msg];
  callback(@[@"接收到动画展示枚举值"]);
}

//弹框
+(void)alertMsg:(NSString *)msg{
  dispatch_async(dispatch_get_main_queue(), ^{
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"接受reactnative数据" message:msg delegate:nil cancelButtonTitle:nil otherButtonTitles:@"知道了！", nil];
    [window addSubview:alertView];
    [alertView show];
  });
}
@end

//
//  CYEventEmitterManager.m
//  NativeExchangeProject
//
//  Created by Mr.GCY on 2018/3/22.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import "CYEventEmitterManager.h"
@interface CYEventEmitterManager()
{
  bool hasListeners;
}
@end
@implementation CYEventEmitterManager
RCT_EXPORT_MODULE();

- (NSArray<NSString *> *)supportedEvents
{
  return @[@"EventReminder"];
}
#pragma mark- 优化无监听处理的事件
/*
 如果你发送了一个事件却没有任何监听处理，则会因此收到一个资源警告。要优化因此带来的额外开销，你可以在你的RCTEventEmitter子类中覆盖startObserving和stopObserving方法。
 */
// 在添加第一个监听函数时触发
-(void)startObserving {
  hasListeners = YES;
}

-(void)stopObserving {
  hasListeners = NO;
}

RCT_EXPORT_METHOD(nativeEventReminderReceived:(NSString *)data){
    [CYEventEmitterManager alertMsg:data];
    if (hasListeners) { // Only send events if anyone is listening
      //发送消息
      [self sendEventWithName:@"EventReminder" body:@{@"name": @"发送消息---Mr.GCY"}];
    }
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

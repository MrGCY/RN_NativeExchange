//
//  CYEventEmitterManager.h
//  NativeExchangeProject
//
//  Created by Mr.GCY on 2018/3/22.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>
//即使没有被JavaScript调用，原生模块也可以给JavaScript发送事件通知。最好的方法是继承RCTEventEmitter，实现suppportEvents方法并调用self sendEventWithName:。
@interface CYEventEmitterManager : RCTEventEmitter<RCTBridgeModule>

@end

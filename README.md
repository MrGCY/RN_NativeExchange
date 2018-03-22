# RN_NativeExchange
reactnative于iOS原生代码之间的交互
###1.接收React传递过来的数据 NSString + NSDictionary
oc代码：
```
RCT_EXPORT_METHOD(receiveForReactSendWithDicData:(NSString *)name andDetail: (NSDictionary *)detailDic){
NSLog(@"接收传过来的NSString + NSDictionary: %@-----%@", name , detailDic);
[CYNativeMoudleManager alertMsg:[NSString stringWithFormat:@"%@----%@",name,detailDic]];
}
```
RN代码：
```
nativeMoudleManager.receiveForReactSendWithDicData('Mr.GCY-2',{EnglishName : 'Mr.GCY',age : 18,professional : 'iOS'});
```
###2.接收React传递过来的数据 NSString + NSDate
oc代码：
```
RCT_EXPORT_METHOD(receiveForReactSendWithDate:(NSString *)name andDate: (NSDate *)date){
//内部进行了类型转换 或者可以使用[RCTConvert NSDate:secondsSinceUnixEpoch]进行转换
NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
[formatter setDateFormat:@"yyyy-MM-dd"];
[CYNativeMoudleManager alertMsg:[NSString stringWithFormat:@"%@----%@",name,[formatter stringFromDate:date]]];
}
```
RN代码：
```
nativeMoudleManager.receiveForReactSendWithDate('Mr.GCY-3',1234567890);
```
###3.原生函数回调 如果你传递了回调函数，那么在原生端就必须执行它
oc代码：
```
RCT_EXPORT_METHOD(receiveForReactSendWithDateAndSuccessCallBack:(NSString *)name andSuccessCallBack: (RCTResponseSenderBlock)successCallBack){
[CYNativeMoudleManager alertMsg:[NSString stringWithFormat:@"数据展示%@",name]];
successCallBack(@[@"成功",@{@"status" : @1,@"data" : @"原生函数回调并且是多参数返回的"}]);
}
```
RN代码：
```
nativeMoudleManager.receiveForReactSendWithDateAndSuccessCallBack('Mr.GCY-4',(msg , callData) => {
var info = '回调信息：' + 'msg---' + msg + 'status---' + callData.status + 'data---' + callData.data;
this.setState({
callBackInfo : info,
})
});
```
###4.Promises  对外提供调用方法,演示Promise使用   resolver成功回调rejecter失败回调
oc代码：
```
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
```
RN代码：
```
//Promise使用来进行回调展示
async updateEvents() {
try {
var events = await nativeMoudleManager.receiveForReactSendCallbackEvents('Mr.GCY-5');
var info = '回调信息：' + 'data---' + events;
this.setState({
callBackInfo : info,
})
} catch (e) {
var info = '回调错误信息：' + 'error---' + e;
this.setState({
callBackInfo : info,
})
}
}
```
###5.枚举常量  用NS_ENUM定义的枚举类型必须要先扩展对应的RCTConvert方法才可以作为函数参数传递。
oc代码：
```
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
```
RN代码：
```
nativeMoudleManager.updateStatusBarAnimation(nativeMoudleManager.statusBarAnimationFade,(data)=> {
this.setState({
callBackInfo : '使用枚举值信息回调：' + data,
})
});
```
###6.javascript没有调用原生方法，原生可以发送消息进行事件传递
oc代码：
```
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
@end
```
RN代码：
```
//监听原生消息事件
subscription_native = eventEmitter.addListener(
'EventReminder',
(reminder) => {
var info = '原生发送消息：' + reminder.name;
this.setState({
callBackInfo : info,
})
});

//不用的时候需要移除
componentWillUnMount() {
//移除订阅/移除监听
this.subscription_native.remove();
}
```







/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 * @flow
 */

import React, { Component } from 'react';
import {
    Platform,
    StyleSheet,
    Text,
    View,
    NativeModules,
    NativeEventEmitter,
    TouchableOpacity,
    ListView,
} from 'react-native';
//3.导入原生组件
var nativeMoudleManager = NativeModules.CYNativeMoudleManager;
var eventEmitterManager = NativeModules.CYEventEmitterManager;
//创建一个包含你的模块的NativeEventEmitter实例来订阅这些事件
const eventEmitter = new NativeEventEmitter(eventEmitterManager);


var Dimensions = require('Dimensions');
var {width} = Dimensions.get('window');



export default class App extends Component<Props> {

  constructor(props){
    super(props);
    var ds = new ListView.DataSource({rowHasChanged : (r1,r2) => r1 !==r2});
    this.state = {
      dataSource : ds.cloneWithRows([
          {title : '1.传递字符串给原生',type : 1},
          {title : '2.传递字符串+字典给原生',type : 2},
          {title : '3.传递字符串+日期给原生',type : 3},
          {title : '4.原生回调数据',type : 4},
          {title : '5.使用Promises回调数据',type : 5},
          {title : '6.使用原生定义的常量',type : 6},
          {title : '7.枚举常量的使用',type : 7},
          {title : '8.接受原生发送的消息',type : 8},
      ]),
      callBackInfo : '回调数据展示'
    }
  }
  onPressSelectCell = (rowRow)=>{
    //调用原生方法
    var type = rowRow.type;
    switch (type){
        case 1 : {
            nativeMoudleManager.receiveForReactSendData('Mr.GCY-1');
            break;
        }
        case 2 : {
            nativeMoudleManager.receiveForReactSendWithDicData('Mr.GCY-2',{EnglishName : 'Mr.GCY',age : 18,professional : 'iOS'});
            break;
        }
        case 3 : {
            nativeMoudleManager.receiveForReactSendWithDate('Mr.GCY-3',1234567890);
            break;
        }
        case 4 : {
            nativeMoudleManager.receiveForReactSendWithDateAndSuccessCallBack('Mr.GCY-4',(msg , callData) => {
                var info = '回调信息：' + 'msg---' + msg + 'status---' + callData.status + 'data---' + callData.data;
                this.setState({
                    callBackInfo : info,
                })
            });
            break;
        }
        case 5 : {
            this.updateEvents();
            break;
        }
        case 6 : {
            this.setState({
                callBackInfo : '原生定义的常量：' + nativeMoudleManager.data,
            })
            break;
        }
        case 7 : {
            nativeMoudleManager.updateStatusBarAnimation(nativeMoudleManager.statusBarAnimationFade,(data)=> {
                this.setState({
                    callBackInfo : '使用枚举值信息回调：' + data,
                })
            });
            break;
        }
        case 8 : {
            eventEmitterManager.nativeEventReminderReceived('Mr.GCY-6');
            break;
        }
    }
  }
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
    renderRowCell = (rowData)=> {
      return (
          <TouchableOpacity
              activeOpacity={0.5}
              onPress={()=> this.onPressSelectCell(rowData)}
          >
              <View style={styles.cellViewStyle}>
                  <Text style={styles.cellTextStyle}>
                      {rowData.title}
                  </Text>
              </View>
          </TouchableOpacity>
      );
    }
    //监听原生消息事件
    subscription_native = eventEmitter.addListener(
        'EventReminder',
        (reminder) => {
            var info = '原生发送消息：' + reminder.name;
            this.setState({
                callBackInfo : info,
            })
    });

    componentWillUnMount() {
        //移除订阅/移除监听
        this.subscription_native.remove();
    }
  render() {
    return (
        <View style={styles.container}>
            <View style={styles.topViewStyle}>
                <Text style={styles.topTextStyle}>
                    {this.state.callBackInfo}
                </Text>
            </View>
            <ListView
                style={styles.listViewStyle}
                dataSource={this.state.dataSource}
                renderRow={this.renderRowCell}
            />
        </View>
    );
  }
}

const styles = StyleSheet.create({
    container : {
        marginTop: 25,
    },
    topTextStyle : {
        color: 'white',
        width : width - 30,
        fontSize: 15,
        textAlign:'center'
    },
    topViewStyle : {
        justifyContent:'center',
        alignItems: 'center',
        backgroundColor : 'deeppink',
        padding:15
    },
    cellViewStyle: {
        justifyContent: 'center',
        height: 70,
        borderBottomWidth:0.5,
        borderBottomColor : '#e8e8e8'
    },
    cellTextStyle: {
        marginLeft : 15,
        color : 'red',
        fontSize : 20
    },
    listViewStyle : {
    }
});

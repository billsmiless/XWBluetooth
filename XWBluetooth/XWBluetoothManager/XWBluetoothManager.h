//
//  XWBluetoothManager.h
//  WKDemo
//
//  Created by cgw on 2018/11/7.
//  Copyright © 2018 cgw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

NS_ASSUME_NONNULL_BEGIN

@protocol XWBluetoothManagerDelegate;
/**
 蓝牙介绍。一种短距离无线通信技术。
 */
@interface XWBluetoothManager : NSObject

+ (XWBluetoothManager*)sharedBluetoothManager;

@property (nonatomic, assign) id<XWBluetoothManagerDelegate> delegate;

/**
 已连接的外围蓝牙设备。
 */
@property (strong, nonatomic, nullable) CBPeripheral *connectedPeripheral;

+ (void)showMsg:(NSString*)msg;

/**
 扫描蓝牙设备
 */
- (void)scanBluetoothDevice;

/**
 连接蓝牙设备

 @param per 设备的数据
 */
- (void)connectDeviceWithPeripheral:(CBPeripheral*)per;

/**
 断开设备

 @param per 设备信息
 */
- (void)disConnectDeviceWithPeripheral:(CBPeripheral*)per;

- (void)sendData:(NSData*)data;

@end

@protocol XWBluetoothManagerDelegate <NSObject>


@required

/**
 扫描到蓝牙设备的回调

 @param btManager 蓝牙管理
 @param deviceList 设备列表
 */
- (void)bluetoothManager:(XWBluetoothManager*)btManager deviceListOfScaned:(NSArray<CBPeripheral*>*)deviceList;

/**
 中心设备状态改变
 
 @param btManager 蓝牙管理类
 @param central 中心设备
 */
- (void)bluetoothManager:(XWBluetoothManager *)btManager didUpdateState:(CBCentralManager *)central;


@optional
/**
 连接设备成功

 @param btManager 连接成功
 @param peripheral 连接设备数据
 */
- (void)bluetoothManager:(XWBluetoothManager *)btManager didConnectPeripheral:(CBPeripheral *)peripheral;

/**
 连接设备失败

 @param btManager 管理
 @param peripheral 设备
 @param error 错误
 */
- (void)bluetoothManager:(XWBluetoothManager *)btManager didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error;

/**
 设备已断开的回调

 @param btManager 蓝牙管理
 @param peripheral 断开的设备
 @param error 错误描述
 */
- (void)bluetoothManager:(XWBluetoothManager *)btManager didDisconnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error;

@end

@interface XWBluetoothDeviceModel : NSObject

@property (nonatomic, strong) NSString *deviceName;

/**
 CBPeripheral 外围设备的信息
 */
@property (nonatomic, strong) id deviceInfo;

@end

NS_ASSUME_NONNULL_END

/*

本文主要涉及的是手机作为中心设备，搜索周边的外围设备，这在大部分的实践中比较常见。

下一篇将写手机作为周边，建立一个蓝牙热点(个人认为)，让中心设备搜索。

开发流程

在实践中，主要的开发流程有以下：
1. 新建Central Manager实例并进行监听蓝牙设备状态
2. 开始搜索外围设备，通过delegate获得数据
3. 连接外围设备，delegate通知连接结果
4. 获得外围设备的服务，delegate获得结果
5. 获得服务的特征，delegate获得结果
6. 根据服务和特征给外围设备发送数据
7. 根据delegate回调，从外围设备读数据

蓝牙相关解释

本文要介绍的CoreBluetooth,专门用于与BLE设备通讯。并且现在很多蓝牙设备都支持4.0,4.0以其低功耗著称，所以一般也叫BLE(Bluetoothlow energy)，所以也是在iOS比较推荐的一种开发方法。
Central（中心设备）；
Peripheral（外围设备）；
advertising（广告）；
Services（服务）；
Characteristic（特征）
CoreBluetooth介绍

在CoreBluetooth中有两个主要的部分,Central和Peripheral，CBPeripheralManager 作为周边设备。CBCentralManager作为中心设备。所有可用的iOS设备可以作为周边（Peripheral）也可以作为中央（Central），但不可以同时既是周边也是中央。

周边设备（Peripheral）是广播数据的设备，中央设备（Central）是管理并且使用这些数据的设备。
也就是说周边（Peripheral）向周围发送广播，告诉周围的中央设备（Central）它（周边（Peripheral）这里有数据，并且说明了能提供的服务和特征值（连接之后才能获取），
其实蓝牙传值相当于网络接口，硬件的service的UUID加上characteristic的UUID，
打一个比喻：service的UUID相当于主地址，characteristic的UUID相当于短链接，短链接必须是主地址的分支，拼在一起的是接口，你和硬件设定的蓝牙传输格式类似于json，双方可识别的数据，因为蓝牙只能支持16进制，而且每次传输只能20个字节，所以要把信息流转成双方可识别的16进制
---------------------
作者：darling_shadow
来源：CSDN
原文：https://blog.csdn.net/darling_shadow/article/details/70141128
版权声明：本文为博主原创文章，转载请附上博文链接！
*/

//
//  XWBluetoothManager.m
//  WKDemo
//
//  Created by cgw on 2018/11/7.
//  Copyright © 2018 cgw. All rights reserved.
//

#import "XWBluetoothManager.h"
#import <UIKit/UIKit.h>

#define BleServiceUUIDBleString @"FFF0" //Device Information"//@"1910"
#define BleCharacteristicRXUUIDString @"FFF6"//@"FFF4"
#define BleCharacteristicTXUUIDString @"FFF7"//@"FFF2"

@interface XWBluetoothManager()<CBCentralManagerDelegate,CBPeripheralDelegate>

/**
 中心设备事件处理的队列
 */
@property (nonatomic, strong) dispatch_queue_t bluetoothQueue;

/**
 中心设备管理，把本机作为中心设备
 */
@property (strong, nonatomic) CBCentralManager *centralManager;

/**
 搜索到的所有外围设备
 */
@property (strong, nonatomic) NSMutableArray *peripherals;

@property (strong, nonatomic) CBCharacteristic *writeCharacteristic;
@property (strong, nonatomic) CBCharacteristic *readCharacteristic;

@end

@implementation XWBluetoothManager

#pragma mark - Public

+ (void)showMsg:(NSString*)msg{
    [[self sharedBluetoothManager] showMsg:msg];
}

+ (XWBluetoothManager *)sharedBluetoothManager{
    static XWBluetoothManager *bm = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        bm = [[XWBluetoothManager alloc] init];
    });
    
    return bm;
}

- (void)scanBluetoothDevice{
    if( ![self checkBluetoothState] ) return;
    
    [self.peripherals removeAllObjects];

    [self.centralManager scanForPeripheralsWithServices:nil options:@{CBCentralManagerScanOptionAllowDuplicatesKey:@YES }];
}

- (void)stopScan{

    [self.centralManager stopScan];
}

- (void)connectDeviceWithPeripheral:(CBPeripheral *)per{
    if( per ){
        [self stopScan];
        
        [self.centralManager connectPeripheral:per options:@{CBConnectPeripheralOptionNotifyOnDisconnectionKey:@YES}];
    }
}

- (void)disConnectDeviceWithPeripheral:(CBPeripheral *)per{
    if( per ){
        [self.centralManager cancelPeripheralConnection:per];
    }
}

- (void)sendData:(NSData *)data{
    [self.connectedPeripheral writeValue:data forCharacteristic:self.writeCharacteristic type:CBCharacteristicWriteWithResponse];//CBCharacteristicWriteWithResponse];
}

#pragma mark - Private

- (BOOL)checkBluetoothState{
    //10.0以上 ，判断蓝牙状态
    BOOL ret = YES;
    if( @available(iOS 10.0, *) ){
        
        if(self.centralManager.state == CBManagerStatePoweredOff){
            
            [self showMsg:@"请打开蓝牙"];
            ret = NO;
        }
        
        else if(self.centralManager.state == CBManagerStateUnsupported){
            
            [self showMsg:@"设备不支持蓝牙"];
            ret = NO;
        }

        
        else if(self.centralManager.state == CBManagerStateUnauthorized){
            
            [self showMsg:@"没有使用蓝牙的权限，请开启权限"];
            ret = NO;
        }
    }
    return ret;
}

- (void)showMsg:(NSString*)msg{
    /*  消息提示  */
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

    }];

    UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:nil message:msg preferredStyle:UIAlertControllerStyleAlert];
    [alertCtrl addAction:action];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertCtrl animated:YES completion:nil];
}

#pragma mark - CBCentralManagerDelegate 中心设备的代理

/*!
 *  @method centralManagerDidUpdateState:
 *
 *  @param central  The central manager whose state has changed.
 *
 *  @discussion     Invoked whenever the central manager's state has been updated. Commands should only be issued when the state is
 *                  <code>CBCentralManagerStatePoweredOn</code>. A state below <code>CBCentralManagerStatePoweredOn</code>
 *                  implies that scanning has stopped and any connected peripherals have been disconnected. If the state moves below
 *                  <code>CBCentralManagerStatePoweredOff</code>, all <code>CBPeripheral</code> objects obtained from this central
 *                  manager become invalid and must be retrieved or discovered again.
 *
 *  @see            state
 *
 */
- (void)centralManagerDidUpdateState:(CBCentralManager *)central{
    
    if( _delegate && [_delegate respondsToSelector:@selector(bluetoothManager:didUpdateState:)]){
        [_delegate bluetoothManager:self didUpdateState:central];
    }

    switch (central.state) {
        case CBManagerStateUnknown:
        {
            //未知状态
        }
            break;
            
        case CBManagerStateResetting:
        {
            //重置中
        }
            break;
        case CBManagerStateUnsupported:
        {
            //不支持
            [self showMsg:@"设备不支持蓝牙"];
        }
            break;
        case CBManagerStateUnauthorized:
        {
            //未授权
            [self showMsg:@"用户未授权"];
        }
            break;
        case CBManagerStatePoweredOff:{
            //蓝牙关闭
            [self showMsg:@"请打开蓝牙"];
        }
            break;
        case CBManagerStatePoweredOn:{
            //可用状态
        }
            break;
        default:
            break;
    }
}


/*!
 *  @method centralManager:willRestoreState:
 *
 *  @param central      The central manager providing this information.
 *  @param dict            A dictionary containing information about <i>central</i> that was preserved by the system at the time the app was terminated.
 *
 *  @discussion            For apps that opt-in to state preservation and restoration, this is the first method invoked when your app is relaunched into
 *                        the background to complete some Bluetooth-related task. Use this method to synchronize your app's state with the state of the
 *                        Bluetooth system.
 *
 *  @seealso            CBCentralManagerRestoredStatePeripheralsKey;
 *  @seealso            CBCentralManagerRestoredStateScanServicesKey;
 *  @seealso            CBCentralManagerRestoredStateScanOptionsKey;
 *
 */
- (void)centralManager:(CBCentralManager *)central willRestoreState:(NSDictionary<NSString *, id> *)dict{
    //当App 被终止后，再次启动App时， 会恢复之前的蓝牙状态，中断之前的数据存在dict中
}

/*!
 *  @method centralManager:didDiscoverPeripheral:advertisementData:RSSI:
 *
 *  @param central              The central manager providing this update.
 *  @param peripheral           A <code>CBPeripheral</code> object.
 *  @param advertisementData    A dictionary containing any advertisement and scan response data.
 *  @param RSSI                 The current RSSI of <i>peripheral</i>, in dBm. A value of <code>127</code> is reserved and indicates the RSSI
 *                                was not available.
 *
 *  @discussion                 This method is invoked while scanning, upon the discovery of <i>peripheral</i> by <i>central</i>. A discovered peripheral must
 *                              be retained in order to use it; otherwise, it is assumed to not be of interest and will be cleaned up by the central manager. For
 *                              a list of <i>advertisementData</i> keys, see {@link CBAdvertisementDataLocalNameKey} and other similar constants.
 *
 *  @seealso                    CBAdvertisementData.h
 *
 */
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *, id> *)advertisementData RSSI:(NSNumber *)RSSI{
    //扫描外围蓝牙设备时，得到扫描的设备
    
    //保存扫描到的外围蓝牙设备
    if( peripheral && [self.peripherals containsObject:peripheral] ==NO ){
        
//        if( [peripheral.name containsString:@"hu"]){
        
            NSLog(@"find Device");
            
            [self.peripherals addObject:peripheral];
            peripheral.delegate = self;
            
            if( _delegate && [_delegate respondsToSelector:@selector(bluetoothManager:deviceListOfScaned:)]){
                [_delegate bluetoothManager:self deviceListOfScaned:self.peripherals];
            }
//        }

    }
}

/*!
 *  @method centralManager:didConnectPeripheral:
 *
 *  @param central      The central manager providing this information.
 *  @param peripheral   The <code>CBPeripheral</code> that has connected.
 *
 *  @discussion         This method is invoked when a connection initiated by {@link connectPeripheral:options:} has succeeded.
 *
 */
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral{
    //连接外围设备成功
    self.connectedPeripheral = peripheral;
    
    //获取该设备的用于交互的服务

    [self.connectedPeripheral discoverServices:nil];
    
    if( _delegate && [_delegate respondsToSelector:@selector(bluetoothManager:didConnectPeripheral:)] ){
        [_delegate bluetoothManager:self didConnectPeripheral:peripheral];
    }
}

/*!
 *  @method centralManager:didFailToConnectPeripheral:error:
 *
 *  @param central      The central manager providing this information.
 *  @param peripheral   The <code>CBPeripheral</code> that has failed to connect.
 *  @param error        The cause of the failure.
 *
 *  @discussion         This method is invoked when a connection initiated by {@link connectPeripheral:options:} has failed to complete. As connection attempts do not
 *                      timeout, the failure of a connection is atypical and usually indicative of a transient issue.
 *
 */
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error{
    //连接外围设备失败
    [self showMsg:@"连接设备失败"];
    self.connectedPeripheral = nil;
    
    if( _delegate && [_delegate respondsToSelector:@selector(bluetoothManager:didFailToConnectPeripheral:error:)]){
        [_delegate bluetoothManager:self didFailToConnectPeripheral:peripheral error:error];
    }
}

/*!
 *  @method centralManager:didDisconnectPeripheral:error:
 *
 *  @param central      The central manager providing this information.
 *  @param peripheral   The <code>CBPeripheral</code> that has disconnected.
 *  @param error        If an error occurred, the cause of the failure.
 *
 *  @discussion         This method is invoked upon the disconnection of a peripheral that was connected by {@link connectPeripheral:options:}. If the disconnection
 *                      was not initiated by {@link cancelPeripheralConnection}, the cause will be detailed in the <i>error</i> parameter. Once this method has been
 *                      called, no more methods will be invoked on <i>peripheral</i>'s <code>CBPeripheralDelegate</code>.
 *
 */
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error{
    //与外围蓝牙设备失去连接
    [self showMsg:@"设备已断开"];
    self.connectedPeripheral = nil;
    
    if( _delegate && [_delegate respondsToSelector:@selector(bluetoothManager:didDisconnectPeripheral:error:)]){
        [_delegate bluetoothManager:self didDisconnectPeripheral:peripheral error:error];
    }
}

#pragma mark - CBPeripheralDelegate 外围设备的代理
/*
 *  @method peripheral:didDiscoverServices:
 *
 *  @param peripheral    The peripheral providing this information.
 *    @param error        If an error occurred, the cause of the failure.
 *
 *  @discussion            This method returns the result of a @link discoverServices: @/link call. If the service(s) were read successfully, they can be retrieved via
 *                        <i>peripheral</i>'s @link services @/link property.
 * 4.查找当前主程序的服务ID
 */
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
    
    //查找所有服务 如果是当前设备的 则查该服务下的有的特征
    for (CBService *service in peripheral.services ) {
        
//        CBUUID *serviceUUID = [CBUUID UUIDWithString:BleServiceUUIDBleString];
//
//        //如果找到写的服务 则继续查找服务下所有特性
//        if ([service.UUID isEqual:serviceUUID]) {
            //BtLog(@"Discovering Characteristics...");
            [self.connectedPeripheral discoverCharacteristics:nil forService:service];
//        }
    }
}
/*
 *  @method peripheral:didDiscoverCharacteristicsForService:error:
 *
 *  @param peripheral    The peripheral providing this information.
 *  @param service        The <code>CBService</code> object containing the characteristic(s).
 *    @param error        If an error occurred, the cause of the failure.
 *
 *  @discussion            This method returns the result of a @link discoverCharacteristics:forService: @/link call. If the characteristic(s) were read successfully,
 *                        they can be retrieved via <i>service</i>'s <code>characteristics</code> property.
 返回当前服务的UUID的所有特性
 */
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
    
    if (error)//如果有错误
    {
        NSLog(@"Discovered characteristics for %@ with error: %@", service.UUID, [error localizedDescription]);

        return;
    }
    
    //查找该服务的所有特性 如果是就把当前特性保存起来
    NSUInteger idx = 0;
    for (CBCharacteristic *characteristic in service.characteristics)
    {
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:BleCharacteristicTXUUIDString]])
        {
            NSLog(@"Discovered read characteristics:%@ for service: %@", characteristic.UUID, service.UUID);
            
            self.readCharacteristic = characteristic;//保存读的特征
             [self.connectedPeripheral setNotifyValue:YES forCharacteristic:self.readCharacteristic];
            idx ++;
        }
        
        //写特征
        else if([characteristic.UUID isEqual:[CBUUID UUIDWithString:BleCharacteristicRXUUIDString]])
        {
            
            NSLog(@"Discovered write characteristics:%@ for service: %@", characteristic.UUID, service.UUID);
            self.writeCharacteristic = characteristic;//保存写的特征
            //接收开启通知
//            [self.connectedPeripheral setNotifyValue:YES forCharacteristic:self.writeCharacteristic];
            
            //回掉函数
            //if ([self.delegate respondsToSelector:@selector(DidFoundWriteChar:)])
            // [self.delegate DidFoundWriteChar:characteristic];
            idx ++;
        }
        
        if( idx == 2 ){
            return;
        }
    }
}

/*
 *  @method peripheral:didWriteValueForCharacteristic:error:
 *
 *  @param peripheral        The peripheral providing this information.
 *  @param characteristic    A <code>CBCharacteristic</code> object.
 *    @param error            If an error occurred, the cause of the failure.
 *
 *  @discussion                This method returns the result of a @link writeValue:forCharacteristic: @/link call.
 向蓝牙发送数据调用
 */

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    
    NSLog(@"%s---%@",__func__,error);
}
/*
 *  @method peripheral:didUpdateNotificationStateForCharacteristic:error:
 *
 *  @param peripheral        The peripheral providing this information.
 *  @param characteristic    A <code>CBCharacteristic</code> object.
 *    @param error            If an error occurred, the cause of the failure.
 *
 *  @discussion                This method returns the result of a @link setNotifyValue:forCharacteristic: @/link call.
 
 开启特征通知时的回调
 */
- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    
    ///
    NSLog(@"%s---%@",__func__,error);
//    [self myBleSetConnectBool:YES err:error];//连接
}

/*
 *  @method peripheral:didUpdateValueForCharacteristic:error:
 *
 *  @param peripheral        The peripheral providing this information.
 *  @param characteristic    A <code>CBCharacteristic</code> object.
 *    @param error            If an error occurred, the cause of the failure.
 *
 *  @discussion                This method is invoked after a @link readValueForCharacteristic: @/link call, or upon receipt of a notification/indication.
 收到数据了
 */

- (void)sendfeedback{
    Byte mybytes[] = {0x02,0x03,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00};
    
    //    Byte mybytes[] = {0x04,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00};
    
    NSData *data=[NSData dataWithBytes:mybytes length:sizeof(mybytes)];
    [self sendData:data];
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    static int a = 0;
    // BtLog(@"");
    NSLog(@"收到设备发出的消息");
    
    [self sendfeedback];
    //
    NSData *data = [characteristic value];
    
    NSLog(@"recive data:%@",data);
    //    NSLog(@"Read leng = %ld ** %@",data.length,data);
    //    //
    //   // if(self.delegate != NULL)
    //   // {
    //    [self.delegate MyBleDelegateDisConnectBle:data];
    //    //}
    //    ///////////////////////////////////
    Byte *testByte = (Byte *)[data bytes];
    
    if (testByte[10] == 0) {
        if (testByte[6] == 0) {
            a = 18 ;
        }
        if (testByte[6] == 1) {
            a = 36;
        }
        if (testByte[6] == 2) {
            a = 72;
        }
    }
    //    NSLog(@"@@@@qqqqqqq@@%d",a);
    //    if (testByte[10]< a) {
    NSLog(@"收到通知：123@@@@@@%hhu",testByte[10]);
//    [[NSNotificationCenter defaultCenter]postNotificationName:MyBleDidRecieveDeviceMsgNotification object:nil userInfo:@{@"index":[NSString stringWithFormat:@"%d",testByte[10]]}];
    
    //        if( testByte[10] == a-1 )
    //            [[NSNotificationCenter defaultCenter]postNotificationName:@"postNavigation" object:nil];
    //    }
}

#pragma mark - Propertys
- (dispatch_queue_t)bluetoothQueue {
    if( !_bluetoothQueue ){
        //串行队列
        _bluetoothQueue = dispatch_queue_create("bluetoothQ", NULL);//dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    }
    return _bluetoothQueue;
}

- (CBCentralManager *)centralManager {
    if( !_centralManager ){
        dispatch_queue_t globalQ = self.bluetoothQueue;
        
        _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:globalQ options:@{CBCentralManagerOptionShowPowerAlertKey:@(YES).stringValue}];
    }
    
    return _centralManager;
}

- (NSMutableArray *)peripherals{
    if( !_peripherals ){
        _peripherals = [NSMutableArray new];
    }
    return _peripherals;
}

@end

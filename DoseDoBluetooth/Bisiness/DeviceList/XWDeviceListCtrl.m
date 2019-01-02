//
//  XWDeviceListCtrl.m
//  XWBluetooth
//
//  Created by wkun on 2019/1/1.
//  Copyright © 2019 bill. All rights reserved.
//

#import "XWDeviceListCtrl.h"
#import "UINavigationController+Ext.h"
#import "UIViewController+Ext.h"
#import "NSString+Ext.h"
#import "XWServiceListCtrl.h"
#import <CoreBluetooth/CoreBluetooth.h>

@interface XWDeviceListCtrl ()<UITableViewDelegate,UITableViewDataSource,CBCentralManagerDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *datas;
@property (nonatomic, strong) CBCentralManager *centralManager;
@property (nonatomic, strong) CBPeripheral *connectedPeripheral;
@end

@implementation XWDeviceListCtrl

#pragma mark - LifeCycel

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configSelfData];
    self.navigationItem.title = @"设备列表";
    
    [self addRightBarItemWithTitle:@"扫描" action:@selector(handleScan)];
    
//    [self addLeftBarItemWithTitle:@"断开设备" action:@selector(handleDisconnectAll)];
    
    self.navigationItem.leftBarButtonItems = @[[[UIBarButtonItem alloc] initWithTitle:@"断开设备" style:UIBarButtonItemStyleDone target:self action:@selector(handleDisconnectAll)]];
}

#pragma mark - TouchEvents
- (void)handleScan{

    [self.centralManager scanForPeripheralsWithServices:nil options:@{CBCentralManagerScanOptionAllowDuplicatesKey:@YES }];
}

- (void)handleDisconnectAll{
    //断开所有设备
    if( self.connectedPeripheral ){
        [self.centralManager cancelPeripheralConnection:self.connectedPeripheral];
    }else{
        
    }
}

#pragma mark - TableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CBPeripheral *per = _datas[indexPath.row];
    
    [self.centralManager connectPeripheral:per options:@{CBConnectPeripheralOptionNotifyOnDisconnectionKey:@YES}];
}

#pragma mark - TableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseId = @"reuseid";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if( cell==nil ){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
    }
    CBPeripheral *per = _datas[indexPath.row];
    if( [per isKindOfClass:[CBPeripheral class]] ){
        NSString *name = @"未知设备";
        if( ![NSString isNullString:per.name] ){
            name = per.name;
        }else if(![NSString isNullString:per.identifier.UUIDString] ){
            name = per.identifier.UUIDString;
        }
        
        cell.textLabel.text = name;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

#pragma mark - Propertys
- (UITableView *)tableView{
    if( !_tableView ){
        
        _tableView = [[UITableView alloc] init];
        CGFloat iy = NAVGATION_VIEW_HEIGHT;
        _tableView.frame = CGRectMake(0, iy, SCREEN_WIDTH, SCREEN_HEIGHT-iy);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        //适配ios11
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        [self.view addSubview:_tableView];
        [self.view bringSubviewToFront:[self getNaviBgView]];
    }
    return _tableView;
}

@end


@implementation XWDeviceListCtrl(RootCtrl)

+ (UIViewController*)rootCtrl{
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:[XWDeviceListCtrl new]];
    [navi configNavigationCtrl];
    [navi setNavigationBarBgClear];
    
    return navi;
}

@end

@implementation XWDeviceListCtrl(CentralManager)

#pragma mark - Private

#pragma mark - CBCentralManagerDelegate 中心设备的代理


- (void)centralManagerDidUpdateState:(CBCentralManager *)central{
    
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


- (void)centralManager:(CBCentralManager *)central willRestoreState:(NSDictionary<NSString *, id> *)dict{
    //当App 被终止后，再次启动App时， 会恢复之前的蓝牙状态，中断之前的数据存在dict中
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *, id> *)advertisementData RSSI:(NSNumber *)RSSI{
    //扫描外围蓝牙设备时，得到扫描的设备
    
    //保存扫描到的外围蓝牙设备
    if( peripheral && [self.datas containsObject:peripheral] ==NO ){

        if( _datas == nil ) _datas = [NSMutableArray new];
        [_datas addObject:peripheral];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }
}


- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral{
    //连接外围设备成功
    self.connectedPeripheral = peripheral;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        XWServiceListCtrl *lc = [XWServiceListCtrl new];
        lc.peripheral = peripheral;
        [self.navigationController pushViewController:lc animated:nil];
    });
    
//    //获取该设备的用于交互的服务
//    [self.connectedPeripheral discoverServices:nil];
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error{
    //连接外围设备失败
    [self showMsg:@"连接设备失败"];
    self.connectedPeripheral = nil;
    
//    if( _delegate && [_delegate respondsToSelector:@selector(bluetoothManager:didFailToConnectPeripheral:error:)]){
//        [_delegate bluetoothManager:self didFailToConnectPeripheral:peripheral error:error];
//    }
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error{
    //与外围蓝牙设备失去连接
    [self showMsg:@"设备已断开"];
    self.connectedPeripheral = nil;
    
//    if( _delegate && [_delegate respondsToSelector:@selector(bluetoothManager:didDisconnectPeripheral:error:)]){
//        [_delegate bluetoothManager:self didDisconnectPeripheral:peripheral error:error];
//    }
}

#pragma mark - Propertys

- (CBCentralManager *)centralManager {
    if( !_centralManager ){
        dispatch_queue_t globalQ = dispatch_queue_create("bluetoothQ", NULL);
        
        _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:globalQ options:@{CBCentralManagerOptionShowPowerAlertKey:@(YES).stringValue}];
    }
    
    return _centralManager;
}

@end

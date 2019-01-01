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
#import "XWBluetoothManager.h"
#import "NSString+Ext.h"

@interface XWDeviceListCtrl ()<XWBluetoothManagerDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *datas;
@property (nonatomic, strong) XWBluetoothManager *bluetoothManager;
@end

@implementation XWDeviceListCtrl

#pragma mark - LifeCycel

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configSelfData];
    self.navigationItem.title = @"设备列表";
    
    [self addRightBarItemWithTitle:@"扫描" action:@selector(handleScan)];
}

#pragma mark - TouchEvents
- (void)handleScan{
    [self.bluetoothManager scanBluetoothDevice];
}

#pragma mark - BluetoothDelegate
- (void)bluetoothManager:(XWBluetoothManager *)btManager deviceListOfScaned:(NSArray<CBPeripheral *> *)deviceList{
    _datas = deviceList;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

- (void)bluetoothManager:(XWBluetoothManager *)btManager didConnectPeripheral:(CBPeripheral *)peripheral{
    //连接设备成功
    NSInteger index = [self.datas indexOfObject:peripheral];
    dispatch_async(dispatch_get_main_queue(), ^{
        
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
        NSString *text = [cell.textLabel.text stringByAppendingString:@"      已连接"];
        cell.textLabel.text = text;
    });
}

- (void)bluetoothManager:(XWBluetoothManager *)btManager didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

/**
 中心设备状态改变
 
 @param btManager 蓝牙管理类
 @param central 中心设备
 */
- (void)bluetoothManager:(XWBluetoothManager *)btManager didUpdateState:(CBCentralManager *)central{
    
}

#pragma mark - TableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CBPeripheral *per = _datas[indexPath.row];
    
    if( per.state == CBPeripheralStateConnecting ){
        [XWBluetoothManager showMsg:@"正在连接中..."];
        return;
    }
    
    if( per.state == CBPeripheralStateConnected || [per isEqual:self.bluetoothManager.connectedPeripheral] ){
        [self.bluetoothManager disConnectDeviceWithPeripheral:per];
    }
    else
        [self.bluetoothManager connectDeviceWithPeripheral:per];
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

- (XWBluetoothManager *)bluetoothManager{
    if( !_bluetoothManager ){
        _bluetoothManager = [XWBluetoothManager sharedBluetoothManager];
        _bluetoothManager.delegate = self;
    }
    return _bluetoothManager;
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

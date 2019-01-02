//
//  XWServiceListCtrl.m
//  XWBluetooth
//
//  Created by cgw on 2019/1/2.
//  Copyright © 2019 bill. All rights reserved.
//

#import "XWServiceListCtrl.h"
#import "UIViewController+Ext.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "NSString+Ext.h"
#import "XWCharacteristicsListCtrl.h"

@interface XWServiceListCtrl ()<UITableViewDelegate,UITableViewDataSource,CBPeripheralDelegate>
@property (nonatomic, strong) NSArray<CBService*> *datas;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation XWServiceListCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configSelfData];
    self.navigationItem.title = @"服务列表";
    
    self.peripheral.delegate = self;
    [self.peripheral discoverServices:nil];
}

#pragma mark - CBPeripheralDelegate 外围设备的代理
/*
 * 4.查找当前主程序的服务ID
 */
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
    
    //找到设备的所有服务
    _datas = peripheral.services;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
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
    CBService *ser = _datas[indexPath.row];
    
    if( [ser isKindOfClass:[CBService class]] ){
        NSString *name = @"未知服务";
       if(![NSString isNullString:ser.UUID.UUIDString] ){
           name = ser.UUID.UUIDString;
           if( [name isEqualToString:@"180A"]){
               name = @"Device Information";
           }
        }
        
        cell.textLabel.text = name;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CBService *ser = _datas[indexPath.row];
    
    XWCharacteristicsListCtrl *lc = [XWCharacteristicsListCtrl new];
    lc.service = ser;
    lc.peripheral = self.peripheral;
    [self.navigationController pushViewController:lc animated:YES];
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

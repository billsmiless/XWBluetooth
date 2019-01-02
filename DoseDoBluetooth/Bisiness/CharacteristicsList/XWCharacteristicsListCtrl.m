//
//  XWCharacteristicsListCtrl.m
//  XWBluetooth
//
//  Created by cgw on 2019/1/2.
//  Copyright © 2019 bill. All rights reserved.
//

#import "XWCharacteristicsListCtrl.h"
#import "UIViewController+Ext.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "NSString+Ext.h"
#import "XWCharacteristicCell.h"
#import "XWWriteCharacteristicView.h"
#import "KKeyBoard.h"

@interface XWCharacteristicsListCtrl ()<UITableViewDelegate,UITableViewDataSource,CBPeripheralDelegate,KKeyBoardDelegate,UITextFieldDelegate,XWCharacteristicCellDelegate>
@property (nonatomic, strong) NSArray<CBCharacteristic*> *datas;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) XWWriteCharacteristicView *writeView;
@property (nonatomic, strong) KKeyBoard *keyboard;

@end

@implementation XWCharacteristicsListCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configSelfData];
    self.navigationItem.title = @"特征列表";
    
    self.peripheral.delegate = self;
    [self.peripheral discoverCharacteristics:nil forService:self.service];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.keyboard addObserverKeyBoard];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self.keyboard removeObserver];
}

#pragma mark - Private

- (void)updateCellCharacticValue:(NSString*)valueText cellIndex:(NSUInteger)idx{
    XWCharacteristicCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:0]];
    cell.valueL.text = valueText;
}

#pragma mark - TextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    //发送数据
    [self sendDataWithText:textField.text];
    
    return YES;
}

- (void)sendDataWithText:(NSString*)text{
    
    NSString *temp = @"0000000000000000000000000000000000000000";
    NSString *dataText = text;
    //不够20位补0
    if( dataText.length < temp.length ){

        NSString *tailText = [temp substringFromIndex:dataText.length];
        dataText = [dataText stringByAppendingString:tailText];
    }
    
    [self updateCellCharacticValue:dataText cellIndex:self.writeView.tag];
    
    NSData *data= [NSString convertHexStrToData:dataText];
    [self sendData:data];
}

- (void)sendData:(NSData *)data{
    CBCharacteristic *cha = _datas[self.writeView.tag];
    [self.peripheral writeValue:data forCharacteristic:cha type:CBCharacteristicWriteWithResponse];
}

#pragma mark - CBPeripheralDelegate 外围设备的代理
/*
 * 4.查找当前主程序的服务ID
 */
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(nonnull CBService *)service error:(nullable NSError *)error {

    //找到设备的所有服务
    _datas = service.characteristics;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

/*
开启特征通知时的回调
*/
- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {

    [self showMsg:@"特征通知已打开"];
}

/**
 特征值改变通知

 @param peripheral 外围设别
 @param characteristic 特征
 @param error 错误
 */
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {

    NSLog(@"收到设备发出的消息");

    NSData *data = [characteristic value];
    //收到设备的消息
    NSString *text = [NSString convertDataToHexStr:data];
    
    NSLog(@"recieveData:%@",text);
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateCellCharacticValue:text cellIndex:self.writeView.tag+1];
    });
}

#pragma mark - KKeyBoardDelegate

- (void)keyBoardWillShow:(KKeyBoard *)keyBoard keyBoardHeight:(CGFloat)height{
    
    CGRect fr = self.writeView.frame;
    fr.origin.y = SCREEN_HEIGHT-height-fr.size.height;
    self.writeView.frame =fr;
    
    fr = self.tableView.frame;
    fr.size.height = (self.writeView.y-fr.origin.y);
    self.tableView.frame = fr;
}

- (void)keyBoardWillHide:(KKeyBoard *)keyBoard keyBoardHeight:(CGFloat)height{
    CGRect fr = self.writeView.frame ;
    fr.origin.y = SCREEN_HEIGHT;
    self.writeView.frame =fr;
    
    fr = self.tableView.frame;
    fr.size.height = (SCREEN_HEIGHT-fr.origin.y);
    self.tableView.frame = fr;
}

#pragma mark - TableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseId = @"reuseid";
    XWCharacteristicCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if( cell==nil ){
        cell = [[XWCharacteristicCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
        cell.delegate = self;
    }
    CBCharacteristic *cha = _datas[indexPath.row];
    
    cell.chara = cha;

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CBCharacteristic *cha = _datas[indexPath.row];
    if( cha.properties & CBCharacteristicPropertyWrite ){
        //可写属性，则弹出键盘
        self.writeView.tag = indexPath.row;
        self.writeView.textField.text = @"";
        [self.writeView.textField becomeFirstResponder];
    }
}

#pragma mark - CellDelegate
- (void)characteristicCell:(XWCharacteristicCell *)cell handleNotifiSwitch:(UISwitch *)swi{
    
    [self.peripheral setNotifyValue:YES forCharacteristic:cell.chara];
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
        
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _tableView.width, 10)];
    }
    return _tableView;
}

- (XWWriteCharacteristicView *)writeView {
    if( !_writeView ){
        _writeView = [[XWWriteCharacteristicView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 60)];
        _writeView.backgroundColor = [UIColor whiteColor];
        _writeView.textField.delegate = self;
        _writeView.textField.returnKeyType = UIReturnKeySend;
        [self.view addSubview:_writeView];
    }
    
    return _writeView;
}

- (KKeyBoard *)keyboard{
    if( !_keyboard ){
        _keyboard = [[KKeyBoard alloc] init];
        _keyboard.delegate = self;
    }
    return _keyboard;
}

@end

//
//  XWCharacteristicCell.h
//  XWBluetooth
//
//  Created by cgw on 2019/1/2.
//  Copyright © 2019 bill. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class CBCharacteristic;
@protocol XWCharacteristicCellDelegate;

@interface XWCharacteristicCell : UITableViewCell

@property (nonatomic, strong) UILabel *nameL;   //特征名字
@property (nonatomic, strong) UILabel *valueL;  //特征值

@property (nonatomic, weak) id<XWCharacteristicCellDelegate> delegate;
@property (nonatomic, strong) CBCharacteristic *chara;

@end

@protocol XWCharacteristicCellDelegate <NSObject>

@optional
- (void)characteristicCell:(XWCharacteristicCell*)cell handleNotifiSwitch:(UISwitch*)swi;

@end

NS_ASSUME_NONNULL_END

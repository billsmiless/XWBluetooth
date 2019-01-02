//
//  XWServiceListCtrl.h
//  XWBluetooth
//
//  Created by cgw on 2019/1/2.
//  Copyright © 2019 bill. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class CBPeripheral;
@interface XWServiceListCtrl : UIViewController

@property (nonatomic, strong) CBPeripheral *peripheral;

@end

NS_ASSUME_NONNULL_END

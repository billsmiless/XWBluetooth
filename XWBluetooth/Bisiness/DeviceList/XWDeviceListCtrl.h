//
//  XWDeviceListCtrl.h
//  XWBluetooth
//
//  Created by wkun on 2019/1/1.
//  Copyright © 2019 bill. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XWDeviceListCtrl : UIViewController

@end


@interface XWDeviceListCtrl(RootCtrl)
+ (UIViewController*)rootCtrl;
@end

@interface XWDeviceListCtrl(CentralManager)

@end

NS_ASSUME_NONNULL_END


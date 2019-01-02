//
//  XWWriteCharacteristicView.h
//  XWBluetooth
//
//  Created by cgw on 2019/1/2.
//  Copyright © 2019 bill. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 写特征值视图
 */
@interface XWWriteCharacteristicView : UIView

@property (nonatomic, strong, readonly) UITextField *textField;

- (void)setTitleTextWithCharacteristicName:(NSString*)cname;

@end

NS_ASSUME_NONNULL_END
